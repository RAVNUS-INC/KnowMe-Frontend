import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/contests_model.dart';
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
  final RxList<Contest> contests = <Contest>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedTabIndex = 0.obs;

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
    loadContests();
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
    loadContests();
  }

  /// PageView에서 페이지 변경 시 호출하는 메서드
  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    loadContests();
  }

  /// 특정 탭의 모든 필터 초기화
  void resetFiltersForTab(int tabIndex) {
    // 단일 선택 필터 초기화
    filtersByTab[tabIndex]?.forEach((_, value) => value.value = null);

    // 다중 선택 필터 초기화
    _resetMultiSelectFilters(tabIndex);

    // 데이터 다시 로드
    loadContests();
  }

  /// 다중 선택 필터 초기화 메서드 (SRP 원칙 적용)
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

  /// 현재 탭의 모든 필터 초기화 (FilterController와의 호환성 유지)
  void resetFilters() => resetFiltersForTab(selectedTabIndex.value);

  /// 필터 값 업데이트
  void updateFilter(String filterType, String? value) {
    filtersByTab[selectedTabIndex.value]?[filterType]?.value = value;
    loadContests(); // 필터링 적용 후 데이터 갱신
  }

  /// 데이터 로드 메서드
  Future<void> loadContests() async {
    isLoading.value = true;

    try {
      final results = getFilteredContentsByCurrentTab();
      contests.assignAll(results);
    } catch (e) {
      _logger.e('Error loading contests: ${e.toString()}');
      contests.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// 현재 탭에 대한 필터링된 데이터 가져오기
  List<Contest> getFilteredContentsByCurrentTab() {
    return getFilteredContentsByTabIndex(selectedTabIndex.value);
  }

  /// 특정 탭에 대한 필터링된 데이터 가져오기
  List<Contest> getFilteredContentsByTabIndex(int tabIndex) {
    final filters = filtersByTab[tabIndex] ?? {};
    final values = filters.map((key, value) => MapEntry(key, value.value));

    switch (tabIndex) {
      case 0: // 채용
        return repository.getJobListings(
          job: values['직무'],
          experience: values['신입~5년'],
          location: values['지역'],
          education: values['학력'],
          educationList: multiSelectJobEducation.isEmpty
              ? null
              : multiSelectJobEducation.toList(),
        );
      case 1: // 인턴
        return repository.getInternships(
          job: values['직무'],
          period: values['기간'],
          location: values['지역'],
          education: values['학력'],
          educationList: multiSelectInternEducation.isEmpty
              ? null
              : multiSelectInternEducation.toList(),
        );
      case 2: // 대외활동
        return repository.getActivities(
          field: values['분야'],
          organization: values['기관'],
          location: values['지역'],
          host: multiSelectHost.isEmpty
              ? values['주최기관']
              : multiSelectHost.join(", "),
        );
      case 3: // 교육/강연
        return repository.getEducationEvents(
          field: values['분야'],
          period: values['기간'],
          location: values['지역'],
          onOffline: multiSelectOnOffline.isEmpty
              ? values['온/오프라인']
              : multiSelectOnOffline.join(", "),
        );
      case 4: // 공모전
      default:
        return repository.getFilteredContests(
          field: values['분야'],
          target: multiSelectTarget.isEmpty
              ? values['대상']
              : multiSelectTarget.join(", "),
          organizer: multiSelectOrganizer.isEmpty
              ? values['주최기관']
              : multiSelectOrganizer.join(", "),
          benefit: multiSelectBenefit.isEmpty
              ? values['혜택']
              : multiSelectBenefit.join(", "),
        );
    }
  }

  /// 탭별 필터 매핑 정보 제공 (리팩토링에 활용)
  static Map<String, Map<int, String>> getFilterMapping() {
    return {
      'job': {0: '직무', 1: '직무'},
      'experience': {0: '신입~5년'},
      'location': {0: '지역', 1: '지역', 2: '지역', 3: '지역'},
      'education': {0: '학력', 1: '학력'},
      'period': {1: '기간', 2: '기간', 3: '기간'},
      'field': {2: '분야', 3: '분야', 4: '분야'},
      'organization': {2: '기관'},
      'host': {2: '주최기관'},
      'onOffline': {3: '온/오프라인'},
      'target': {4: '대상'},
      'organizer': {4: '주최기관'},
      'benefit': {4: '혜택'},
    };
  }
}
