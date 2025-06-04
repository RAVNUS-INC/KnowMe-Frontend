import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/contests_model.dart';
import '../repositories/post_repository.dart';
import 'package:knowme_frontend/features/recommendation/repositories/saved_repository.dart';

/// 게시물 데이터 관련 비즈니스 로직을 담당하는 Controller 클래스
/// 데이터 검색 및 필터 상태 관리를 담당합니다.
class PostController extends GetxController {
  // 의존성
  final PostRepository repository;
  final SavedRepository _savedRepository = SavedRepository();
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

  /// 북마크 토글 (저장/저장 취소) 기능
  Future<void> toggleBookmark(Contest contest) async {
    try {
      _logger.d('북마크 토글 시작: ${contest.id}, 현재 상태: ${contest.isBookmarked}');

      bool success = false;

      // 북마크 추가 또는 제거 요청
      if (!contest.isBookmarked) {
        // 북마크 추가 (저장)
        success = await _savedRepository.savePost("1", int.parse(contest.id));
        if (success) {
          _logger.d('🌟 북마크 추가 성공: ${contest.id}');
          Get.snackbar(
            '저장 완료',
            '${contest.title} 활동이 저장되었습니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[800],
            duration: const Duration(seconds: 1),
          );
        }
      } else {
        // 북마크 제거 (저장 취소)
        success = await _savedRepository.unsavePost(int.parse(contest.id)); // 메서드명 수정
        if (success) {
          _logger.d('❌ 북마크 제거 성공: ${contest.id}');
          Get.snackbar(
            '저장 취소',
            '${contest.title} 활동이 저장 취소되었습니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[800],
            duration: const Duration(seconds: 1),
          );
        }
      }

      // 상태 업데이트
      if (success) {
        contest.isBookmarked = !contest.isBookmarked;
        contests.refresh();
      }
    } catch (e) {
      _logger.e('북마크 토글 실패: ${e.toString()}');
      Get.snackbar(
        '오류 발생',
        '북마크 처리 중 문제가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[300],
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// 컨텐츠 로드 (탭 인덱스에 따라 다른 데이터 로드)
  Future<void> loadContests({bool refresh = false}) async {
    try {
      isLoading.value = true;
      final result = await repository.getContests(tabIndex: selectedTabIndex.value, userId: "1");
      contests.assignAll(result);
    } catch (e) {
      _logger.e('데이터 로드 실패: $e');
      Get.snackbar(
        '오류 발생',
        '데이터를 불러오는 중 문제가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 탭 변경 처리
  void changeTab(int index) {
    selectedTabIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    loadContests();
  }

  /// 페이지 변경 이벤트 처리
  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    loadContests();
  }

  /// 선택된 탭 인덱스에 따라 필터링된 컨텐츠 가져오기
  Future<List<Contest>> getFilteredContentsByTabIndex(int tabIndex) async {
    // 탭 인덱스가 현재 선택된 탭과 같으면 이미 로드된 데이터 반환
    if (tabIndex == selectedTabIndex.value) {
      return contests.where((contest) => contest.type.index == tabIndex).toList();
    }
    
    // 다른 탭의 경우 데이터 로드
    try {
      return await repository.getContests(tabIndex: tabIndex, userId: "1");
    } catch (e) {
      _logger.e('데이터 필터링 실패: $e');
      return [];
    }
  }

  /// 모든 필터 초기화
  void resetFilters() {
    final currentFilters = filtersByTab[selectedTabIndex.value];
    if (currentFilters != null) {
      for (var key in currentFilters.keys) {
        currentFilters[key]?.value = null;
      }
    }
    
    // 다중 선택 필터도 초기화
    multiSelectTarget.clear();
    multiSelectHost.clear();
    multiSelectOrganizer.clear();
    multiSelectBenefit.clear();
    multiSelectOnOffline.clear();
    multiSelectJobEducation.clear();
    multiSelectInternEducation.clear();
    
    // 필터 초기화 후 데이터 새로고침
    loadContests(refresh: true);
  }
  
  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedTabIndex.value);
    loadContests();
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
