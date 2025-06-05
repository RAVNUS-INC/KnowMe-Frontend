import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/contests_model.dart';
import '../repositories/post_repository.dart';
import 'package:knowme_frontend/features/recommendation/repositories/saved_repository.dart';
import 'package:knowme_frontend/features/recommendation/controllers/recommendation_controller.dart';

/// 게시물 데이터 관련 비즈니스 로직을 담당하는 Controller 클래스
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

  // 탭별 데이터 캐싱을 위한 맵 추가
  final Map<int, List<Contest>> _cachedContestsByTab = {};

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

    // 애플리케이션 시작시 현재 탭 데이터 로드
    loadContests();

    // 선택된 탭이 변경될 때마다 해당 탭의 데이터 로드
    ever(selectedTabIndex, (index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadContests();
      });
    });

    // 선제적으로 모든 탭 데이터 초기 로딩 (화면 뒤에서 준비)
    _preloadAllTabsData();
  }

  // 모든 탭의 데이터를 미리 로드하는 메서드
  Future<void> _preloadAllTabsData() async {
    // 현재 선택된 탭은 loadContests()에서 처리하므로 제외
    final currentTab = selectedTabIndex.value;

    for (int i = 0; i < 5; i++) {
      if (i != currentTab) {
        getFilteredContentsByTabIndex(i).then((data) {
          _cachedContestsByTab[i] = data;
          _logger.d('탭 $i 데이터 미리 로드 완료: ${data.length} 항목');
        });
      }
    }
  }

  @override
  void onClose() {
    // PageController 자원 해제
    pageController.dispose();
    super.onClose();
  }

  /// 탭 변경 메서드
  void changeTab(int index) {
    if (selectedTabIndex.value != index) {
      selectedTabIndex.value = index;

      if (pageController.hasClients && pageController.page?.toInt() != index) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  // /// PageView에서 페이지 변경 시 호출하는 메서드
  // void onPageChanged(int index) {
  //   if (selectedTabIndex.value != index) {
  //     selectedTabIndex.value = index;
  //     ever(selectedTabIndex, (index) {
  //       _logger.d('ever: 탭 인덱스 바뀜 → $index');
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         _logger.d('addPostFrameCallback: loadContests 호출 직전');
  //         loadContests();
  //       });
  //     });
  //
  //   }
  // }
  /// PageView에서 스와이프로 페이지 변경 시 호출되는 메서드
  void onPageChanged(int index) {
    if (selectedTabIndex.value != index) {
      selectedTabIndex.value = index;
      // ever() 로직이 이미 onInit()에서 한 번만 등록되어 있으므로, 여기서는 추가 등록하지 않습니다.
    }
  }


  /// 특정 탭의 모든 필터 초기화
  void resetFiltersForTab(int tabIndex) {
    // 단일 선택 필터 초기화
    filtersByTab[tabIndex]?.forEach((_, value) => value.value = null);

    // 다중 선택 필터 초기화
    _resetMultiSelectFilters(tabIndex);

    // 캐시된 데이터 삭제하여 다시 로드되도록 함
    _cachedContestsByTab.remove(tabIndex);

    // 만약 현재 선택된 탭의 필터를 초기화했다면 데이터 다시 로드
    if (tabIndex == selectedTabIndex.value) {
      // 빌드 완료 후 loadContests 호출
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadContests();
      });
    }
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

    // 필터 값이 변경되면 해당 탭의 캐시 데이터 삭제
    _cachedContestsByTab.remove(selectedTabIndex.value);

    // 빌드 완료 후 데이터 다시 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadContests();
    });
  }

  /// 데이터 로드 메서드
  Future<void> loadContests() async {
    // if (isLoading.value) return; // 이미 로딩 중이면 리턴
    // isLoading.value = true;
    // ever(selectedTabIndex, (index) {
    //   _logger.d('ever: 탭 인덱스 바뀜 → $index');
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _logger.d('addPostFrameCallback: loadContests 호출 직전');
    //     loadContests();
    //   });
    // });

    // if (isLoading.value) return; // 이미 로딩 중이면 리턴
    // isLoading.value = true;



    try {
      final currentTab = selectedTabIndex.value;
      if (_cachedContestsByTab.containsKey(currentTab)) {
        // 1) 캐시된 데이터 사용
        _logger.d('탭 \$currentTab의 캐시된 데이터 사용');
        contests.assignAll(_cachedContestsByTab[currentTab]!);
      } else {
        // 2) 캐시가 없으면 서버에서 읽어서 캐시에 저장
        final results = await getFilteredContentsByCurrentTab();
        contests.assignAll(results);
        _cachedContestsByTab[currentTab] = results;
        _logger.d('탭 \$currentTab의 데이터 새로 로드: \${results.length} 항목');
      }

      await _initSavedStatuses();
    } catch (e) {
      _logger.e('Error loading contests: \${e.toString()}');
      contests.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// 서버에 저장된(북마크된) 공고 ID들을 가져와서
  /// contests 리스트의 해당 객체에 isBookmarked=true 로 초기화
  Future<void> _initSavedStatuses() async {
    try {
      // 1) 서버에서 "내가 저장(북마크)해 둔" Contest 리스트 조회
      final List<Contest> savedContests =
      await _savedRepository.getSavedContestsFromApi();

      // 2) 저장된 Contest들의 ID만 Set으로 추출
      final Set<String> savedIdSet =
      savedContests.map((c) => c.id).toSet();

      // 3) 현재 로드된 contests 리스트 순회하면서, ID가 Set에 있으면 isBookmarked=true
      for (var contest in contests) {
        contest.isBookmarked = savedIdSet.contains(contest.id);
      }

      // 4) RxList 갱신 → Obx로 묶인 UI에 반영
      contests.refresh();

      _logger.d('_initSavedStatuses 완료: ${savedIdSet.length}개 공고가 북마크됨');
    } catch (e) {
      _logger.e('_initSavedStatuses 중 예외 발생: $e');
    }
  }

  /// 현재 탭에 대한 필터링된 데이터 가져오기
  Future<List<Contest>> getFilteredContentsByCurrentTab() async {
    return await getFilteredContentsByTabIndex(selectedTabIndex.value);
  }

  /// 특정 탭에 대한 필터링된 데이터 가져오기 - 빌드 중에 호출될 수 있으므로
  /// 내부에서 contests.assignAll과 같은 상태 변경을 하지 않음
  Future<List<Contest>> getFilteredContentsByTabIndex(int tabIndex) async {
    // 이미 캐시된 데이터가 있다면 반환
    if (_cachedContestsByTab.containsKey(tabIndex)) {
      return List<Contest>.from(_cachedContestsByTab[tabIndex]!);
    }

    final filters = filtersByTab[tabIndex] ?? {};
    final values = filters.map((key, value) => MapEntry(key, value.value));

    List<Contest> result;

    switch (tabIndex) {
      case 0: // 채용
        result = await repository.getJobListings(
          job: values['직무'],
          experience: values['신입~5년'],
          location: values['지역'],
          education: values['학력'],
          educationList: multiSelectJobEducation.isEmpty
              ? null
              : multiSelectJobEducation.toList(),
        );
        break;
      case 1: // 인턴
        result = await repository.getInternListings(
          job: values['직무'],
          period: values['기간'],
          location: values['지역'],
          education: values['학력'],
          educationList: multiSelectInternEducation.isEmpty
              ? null
              : multiSelectInternEducation.toList(),
        );
        break;
      case 2: // 대외활동
        result = await repository.getExternalListings(
          field: values['분야'],
          organization: values['기관'],
          location: values['지역'],
          host: multiSelectHost.isEmpty
              ? values['주최기관']
              : multiSelectHost.join(", "),
        );
        break;
      case 3: // 교육/강연
        result = await repository.getEducationListings(
          field: values['분야'],
          period: values['기간'],
          location: values['지역'],
          onOffline: multiSelectOnOffline.isEmpty
              ? values['온/오프라인']
              : multiSelectOnOffline.join(", "),
        );
        break;
      case 4: // 공모전
      default:
        result = await repository.getFilteredContests(
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

    // 새로 로드한 데이터를 캐시에 저장 (contests.assignAll 호출하지 않음)
    _cachedContestsByTab[tabIndex] = result;

    return result;
  }

  /// 북마크 토글 (저장/저장 취소) 기능
  Future<void> toggleBookmark(Contest contest) async {
    try {
      _logger.d('북마크 토글 시작: ${contest.id}, 현재 상태: ${contest.isBookmarked}');

      bool success = false;

      if (!contest.isBookmarked) {
        // 북마크 추가 (저장)
        success = await _savedRepository.savePost(int.parse(contest.id));
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
        success = await _savedRepository.unsavePost(int.parse(contest.id));
        if (success) {
          _logger.d('🗑️ 북마크 제거 성공: ${contest.id}');
          Get.snackbar(
            '저장 취소',
            '${contest.title} 활동이 저장 목록에서 제거되었습니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.amber[100],
            colorText: Colors.amber[800],
            duration: const Duration(seconds: 1),
          );
        }
      }

      if (success) {
        // 1) PostController 내에서 토글 상태 반전
        contest.isBookmarked = !contest.isBookmarked;

        // 모든 탭의 캐시된 데이터에서도 북마크 상태 업데이트
        _updateBookmarkStatusInCachedData(contest.id, contest.isBookmarked);

        contests.refresh();

        // 2) RecommendationController(savedActivitiesTab)와 동기화
        if (Get.isRegistered<RecommendationController>()) {
          final recCtrl = Get.find<RecommendationController>();

          if (contest.isBookmarked) {
            // 새롭게 북마크된 경우 savedContests에 추가
            if (!recCtrl.savedContests.any((c) => c.id == contest.id)) {
              // savedContests는 RecommendationController 내부에서 isBookmarked=true로 초기화돼 있다고 간주
              contest.isBookmarked = true; // 확실히 true로 유지
              recCtrl.savedContests.add(contest);
            }
          } else {
            // 북마크 해제된 경우 savedContests에서 제거
            recCtrl.savedContests.removeWhere((c) => c.id == contest.id);
          }
          // RecommendationController 가 GetBuilder/Rebuilder로 UI를 갱신하도록 update() 호출
          recCtrl.update();
        }
      } else {
        _logger.e('북마크 토글 실패: ${contest.id}');
        Get.snackbar(
          '',
          '이미 저장된 북마크입니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber[100],
          colorText: Colors.amber[800],
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      _logger.e('북마크 토글 중 예외 발생: $e');
      Get.snackbar(
        '오류 발생',
        '북마크 상태를 변경하는 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: const Duration(seconds: 2),
      );
    }
  }

  // 모든 캐시된 탭 데이터에서 북마크 상태 업데이트
  void _updateBookmarkStatusInCachedData(String contestId, bool isBookmarked) {
    _cachedContestsByTab.forEach((tabIndex, contestList) {
      for (var contest in contestList) {
        if (contest.id == contestId) {
          contest.isBookmarked = isBookmarked;
        }
      }
    });
  }

  /// 특정 탭의 캐시된 Contest 리스트를 반환하는 Getter
  List<Contest>? getCachedContests(int tabIndex) {
    return _cachedContestsByTab[tabIndex];
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