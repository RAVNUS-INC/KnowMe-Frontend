import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/contest_model.dart';
import '../repositories/post_repository.dart';

/// 게시물 데이터 관련 비즈니스 로직을 담당하는 Controller 클래스
/// 데이터 검색 및 필터 상태 관리를 담당합니다.
class PostController extends GetxController {
  // 의존성
  final PostRepository repository;
  final _logger = Logger();

  // 생성자를 통해 repository 초기화 (의존성 주입)
  PostController({PostRepository? repository}) : repository = repository ?? PostRepository();

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

  @override
  void onInit() {
    super.onInit();
    loadContests();
  }

  /// 탭 변경 메서드
  void changeTab(int index) {
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
          educationList: multiSelectJobEducation.isEmpty ? null : multiSelectJobEducation.toList(),
        );
      case 1: // 인턴
        return repository.getInternships(
          job: values['직무'],
          period: values['기간'],
          location: values['지역'],
          education: values['학력'],
          educationList: multiSelectInternEducation.isEmpty ? null : multiSelectInternEducation.toList(),
        );
      case 2: // 대외활동
        return repository.getActivities(
          field: values['분야'],
          organization: values['기관'],
          location: values['지역'],
          host: multiSelectHost.isEmpty ? values['주최기관'] : multiSelectHost.join(", "),
        );
      case 3: // 교육/강연
        return repository.getEducationEvents(
          field: values['분야'],
          period: values['기간'],
          location: values['지역'],
          onOffline: multiSelectOnOffline.isEmpty ? values['온/오프라인'] : multiSelectOnOffline.join(", "),
        );
      case 4: // 공모전
      default:
        return repository.getFilteredContests(
          field: values['분야'],
          target: multiSelectTarget.isEmpty ? values['대상'] : multiSelectTarget.join(", "),
          organizer: multiSelectOrganizer.isEmpty ? values['주최기관'] : multiSelectOrganizer.join(", "),
          benefit: multiSelectBenefit.isEmpty ? values['혜택'] : multiSelectBenefit.join(", "),
        );
    }
  }

  // TODO: 추후 리팩토링 - 아래 Getter들은 filter_controller.dart 및 filter_row_widget.dart에서
  // 직접 참조되고 있어 호환성을 위해 필요합니다. 이후 코드 리팩토링 시 filtersByTab을 직접 사용하도록 수정 필요
  
  /// 기존 코드와의 호환성 유지를 위한 Getter들
  /// filter_controller.dart와 filter_row_widget.dart에서 직접 참조하고 있음
  
  // 채용 관련 필터 Getter
  Rx<String?> get selectedJob => filtersByTab[0]!['직무']!;
  Rx<String?> get selectedExperience => filtersByTab[0]!['신입~5년']!;
  Rx<String?> get selectedLocation => filtersByTab[0]!['지역']!;
  Rx<String?> get selectedEducation => filtersByTab[0]!['학력']!;
  
  // 인턴 관련 필터 Getter
  Rx<String?> get selectedInternJob => filtersByTab[1]!['직무']!;
  Rx<String?> get selectedPeriod => filtersByTab[1]!['기간']!;
  Rx<String?> get selectedInternLocation => filtersByTab[1]!['지역']!;
  Rx<String?> get selectedInternEducation => filtersByTab[1]!['학력']!;
  
  // 대외활동 관련 필터 Getter
  Rx<String?> get selectedField => filtersByTab[2]!['분야']!;
  Rx<String?> get selectedOrganization => filtersByTab[2]!['기관']!;
  Rx<String?> get selectedActivityLocation => filtersByTab[2]!['지역']!;
  Rx<String?> get selectedHost => filtersByTab[2]!['주최기관']!;
  Rx<String?> get selectedActivityPeriod => filtersByTab[2]!['기간']!;
  
  // 교육/강연 관련 필터 Getter
  Rx<String?> get selectedEduField => filtersByTab[3]!['분야']!;
  Rx<String?> get selectedEduPeriod => filtersByTab[3]!['기간']!;
  Rx<String?> get selectedEduLocation => filtersByTab[3]!['지역']!;
  Rx<String?> get selectedOnOffline => filtersByTab[3]!['온/오프라인']!;
  
  // 공모전 관련 필터 Getter
  Rx<String?> get selectedContestField => filtersByTab[4]!['분야']!;
  Rx<String?> get selectedTarget => filtersByTab[4]!['대상']!;
  Rx<String?> get selectedOrganizer => filtersByTab[4]!['주최기관']!;
  Rx<String?> get selectedBenefit => filtersByTab[4]!['혜택']!;
}
