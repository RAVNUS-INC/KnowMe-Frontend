import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/postsPostid_model.dart';
import '../repositories/post_repository.dart';

/// 게시물 데이터 관련 비즈니스 로직을 담당하는 Controller 클래스
/// 데이터 검색 및 필터 상태 관리를 담당합니다.
class PostController extends GetxController {
  // 의존성
  final PostRepository repository;
  final _logger = Logger();

  // 서브 컨트롤러로 PageController 추가
  late PageController pageController;

  // 생성자를 통해 repository 초기화 (의존성 주입)
  PostController({PostRepository? repository})
      : repository = repository ?? PostRepository();

  // 상태 변수들 - 반응형으로 관리
  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // 필터 상태 관리 - 탭별 필터 맵
  final Map<int, Map<String, Rx<String?>>> filtersByTab = {
    0: {
      '직무': Rx<String?>(null),
      '신입~5년': Rx<String?>(null),
      '지역': Rx<String?>(null),
      '학력': Rx<String?>(null),
    },
    1: {
      '직무': Rx<String?>(null),
      '기간': Rx<String?>(null),
      '지역': Rx<String?>(null),
      '학력': Rx<String?>(null),
    },
    2: {
      '분야': Rx<String?>(null),
      '기관': Rx<String?>(null),
      '지역': Rx<String?>(null),
      '주최기관': Rx<String?>(null),
      '기간': Rx<String?>(null),
    },
    3: {
      '분야': Rx<String?>(null),
      '기간': Rx<String?>(null),
      '지역': Rx<String?>(null),
      '온/오프라인': Rx<String?>(null),
    },
    4: {
      '분야': Rx<String?>(null),
      '대상': Rx<String?>(null),
      '주최기관': Rx<String?>(null),
      '혜택': Rx<String?>(null),
    },
  };

  // 다중 선택 필터 상태 관리
  final RxList<String> multiSelectTarget = <String>[].obs;
  final RxList<String> multiSelectHost = <String>[].obs;
  final RxList<String> multiSelectOrganizer = <String>[].obs;
  final RxList<String> multiSelectBenefit = <String>[].obs;
  final RxList<String> multiSelectOnOffline = <String>[].obs;
  final RxList<String> multiSelectJobEducation = <String>[].obs;
  final RxList<String> multiSelectInternEducation = <String>[].obs;

  // 호환성을 위한 getter
  RxInt get currentTabIndex => selectedTabIndex;

  // 필터 접근 메서드 (리팩토링을 위한 새로운 접근 방식)
  /// 현재 선택된 탭에서 특정 타입의 필터값 가져오기
  Rx<String?> getFilter(String filterType) {
    return filtersByTab[selectedTabIndex.value]?[filterType] ??
        Rx<String?>(null);
  }

  /// 특정 탭의 특정 타입 필터값 가져오기
  Rx<String?> getFilterByType(int tabIndex, String filterType) {
    return filtersByTab[tabIndex]?[filterType] ?? Rx<String?>(null);
  }

  /// 탭 인덱스에 따른 모든 필터값 Map 가져오기
  Map<String, Rx<String?>> getFiltersForTab(int tabIndex) {
    return filtersByTab[tabIndex] ?? {};
  }

  /// 현재 탭의 모든 필터값 Map 가져오기
  Map<String, Rx<String?>> getCurrentTabFilters() {
    return filtersByTab[selectedTabIndex.value] ?? {};
  }

  @override
  void onInit() {
    super.onInit();
    // PageController 초기화
    pageController = PageController(initialPage: selectedTabIndex.value);
    loadPosts(); // API로부터 데이터 로드
  }

  @override
  void onClose() {
    // PageController 자원 해제
    pageController.dispose();
    super.onClose();
  }

  /// 탭 변경 메서드 - PageController와 탭 인덱스 동기화 포함
  void changeTab(int index) {
    selectedTabIndex.value = index;
    // PageController 페이지도 함께 변경
    if (pageController.hasClients && pageController.page?.toInt() != index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    loadPosts(); // 탭이 변경됐으므로 해당 탭의 데이터 로드
  }

  /// PageView에서 페이지 변경 시 호출하는 메서드
  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    loadPosts(); // 페이지가 변경됐으므로 해당 탭의 데이터 로드
  }

  /// 특정 탭의 모든 필터 초기화
  void resetFiltersForTab(int tabIndex) {
    // 단일 선택 필터 초기화
    filtersByTab[tabIndex]?.forEach((_, value) => value.value = null);

    // 다중 선택 필터 초기화
    _resetMultiSelectFilters(tabIndex);

    // 데이터 다시 로드
    loadPosts();
  }

  /// 다중 선택 필터 초기화 메서드
  void _resetMultiSelectFilters(int tabIndex) {
    switch (tabIndex) {
      case 0: // 채용
        multiSelectJobEducation.clear();
        break;
      case 1: // 인턴
        multiSelectInternEducation.clear();
        break;
      case 2: // 대외활동
        multiSelectHost.clear();
        break;
      case 3: // 교육/강연
        multiSelectOnOffline.clear();
        break;
      case 4: // 공모전
        multiSelectTarget.clear();
        multiSelectOrganizer.clear();
        multiSelectBenefit.clear();
        break;
    }
  }

  /// 현재 탭의 모든 필터 초기화
  void resetFilters() => resetFiltersForTab(selectedTabIndex.value);

  /// 필터 값 업데이트
  void updateFilter(String filterType, String? value) {
    filtersByTab[selectedTabIndex.value]?[filterType]?.value = value;
    loadPosts(); // 필터링 적용 후 데이터 갱신
  }

  /// API를 통한 게시물 데이터 로드
  Future<void> loadPosts() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      List<PostModel> results = [];
      
      switch (selectedTabIndex.value) {
        case 0: // 채용
          results = await repository.fetchEmploymentPosts(
            job: filtersByTab[0]?['직무']?.value,
            experience: filtersByTab[0]?['신입~5년']?.value,
            location: filtersByTab[0]?['지역']?.value,
            education: filtersByTab[0]?['학력']?.value,
          );
          break;
        case 1: // 인턴
          results = await repository.fetchInternPosts(
            job: filtersByTab[1]?['직무']?.value,
            period: filtersByTab[1]?['기간']?.value,
            location: filtersByTab[1]?['지역']?.value,
            education: filtersByTab[1]?['학력']?.value,
          );
          break;
        case 2: // 대외활동
          results = await repository.fetchExternalActivityPosts(
            field: filtersByTab[2]?['분야']?.value,
            organization: filtersByTab[2]?['기관']?.value,
            location: filtersByTab[2]?['지역']?.value,
            host: filtersByTab[2]?['주최기관']?.value,
          );
          break;
        case 3: // 교육/강연
          results = await repository.fetchLecturePosts(
            field: filtersByTab[3]?['분야']?.value,
            period: filtersByTab[3]?['기간']?.value,
            location: filtersByTab[3]?['지역']?.value,
            onOffline: filtersByTab[3]?['온/오프라인']?.value,
          );
          break;
        case 4: // 공모전
          results = await repository.fetchContestPosts(
            field: filtersByTab[4]?['분야']?.value,
            target: filtersByTab[4]?['대상']?.value,
            organizer: filtersByTab[4]?['주최기관']?.value,
            benefit: filtersByTab[4]?['혜택']?.value,
          );
          break;
        default:
          results = await repository.fetchAllPosts();
      }
      
      posts.assignAll(results);
      _logger.i('탭 ${selectedTabIndex.value}에 대한 게시물 ${results.length}개 로드됨');
    } catch (e) {
      _logger.e('게시물 로드 중 오류 발생: $e');
      hasError.value = true;
      errorMessage.value = '데이터를 불러오는 데 실패했습니다: $e';
      posts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// 검색어를 기반으로 게시물 검색
  Future<void> searchPosts(String query) async {
    if (query.isEmpty) {
      loadPosts(); // 검색어가 비어있으면 전체 데이터 로드
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      final results = await repository.searchPosts(query);
      posts.assignAll(results);
      _logger.i('검색어 "$query"로 ${results.length}개 게시물 검색됨');
    } catch (e) {
      _logger.e('게시물 검색 중 오류 발생: $e');
      hasError.value = true;
      errorMessage.value = '검색에 실패했습니다: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// 새로고침 - 현재 상태를 유지하면서 데이터만 새로 로드
  Future<void> refreshPosts() async {
    return loadPosts();
  }
}
