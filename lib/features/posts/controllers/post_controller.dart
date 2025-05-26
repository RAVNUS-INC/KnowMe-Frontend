import 'package:get/get.dart';
import '../models/contest_model.dart';
import '../repositories/post_repository.dart'; // 경로 수정

class PostController extends GetxController {
  final PostRepository repository; // 생성자를 통해 초기화할 예정

  // 생성자를 통해 repository 초기화
  PostController({PostRepository? repository}) : this.repository = repository ?? PostRepository();

  final RxList<Contest> contests = <Contest>[].obs;
  final RxBool isLoading = false.obs;

  final RxInt currentTabIndex = 0.obs; // 기본: 공모전 탭

  // 필터 구조: 탭 인덱스별 → 필터명 → Rx 값
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

  @override
  void onInit() {
    super.onInit();
    loadContests();
  }

  void changeTab(int index) => currentTabIndex.value = index;

  void resetFilters() {
    filtersByTab[currentTabIndex.value]?.forEach((_, value) => value.value = null);
  }

  void updateFilter(String filterType, String? value) {
    filtersByTab[currentTabIndex.value]?[filterType]?.value = value;
  }

  // 필터링 후 데이터를 다시 불러오는 메서드
  Future<void> loadContests() async {
    isLoading.value = true;
    try {
      final results = getFilteredContentsByCurrentTab();
      contests.assignAll(results);
    } catch (e) {
      // 에러 처리
      print('Error loading contests: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // 현재 탭 기반으로 필터링된 콘텐츠 가져오기
  List<Contest> getFilteredContentsByCurrentTab() {
    return getFilteredContentsByTabIndex(currentTabIndex.value);
  }

  List<Contest> getCurrentFilteredContents() {
    return getFilteredContentsByTabIndex(currentTabIndex.value);
  }

  // 탭 인덱스에 따라 적절한 필터링 메서드 호출
  // List<Contest> getFilteredContentsByTabIndex(int tabIndex) {
  //   switch (tabIndex) {
  //     case 0: // 채용
  //       return repository.getJobListings(
  //         job: selectedJob.value,
  //         experience: selectedExperience.value,
  //         location: selectedLocation.value,
  //         education: selectedEducation.value,
  //       );
  //     case 1: // 인턴
  //       return repository.getInternships(
  //         job: selectedInternJob.value,
  //         period: selectedPeriod.value,
  //         location: selectedInternLocation.value,
  //         education: selectedInternEducation.value,
  //       );
  //     case 2: // 대외활동
  //       return repository.getActivities(
  //         field: selectedField.value,
  //         organization: selectedActivityLocation.value,
  //         location: selectedActivityLocation.value,
  //         host: selectedHost.value,
  //       );
  //     case 3: // 교육/강연
  //       return repository.getEducationEvents(
  //         field: selectedEduField.value,
  //         period: selectedEduPeriod.value,
  //         location: selectedEduLocation.value,
  //         onOffline: selectedOnOffline.value,
  //       );
  //     case 4: // 공모전
  //     default:
  //       return repository.getFilteredContests(
  //         field: selectedContestField.value,
  //         target: selectedTarget.value,
  //         organizer: selectedOrganizer.value,
  //         benefit: selectedBenefit.value,
  //       );
  //   }
  // }

  // zip에 있던 거 불러옴
  List<Contest> getFilteredContentsByTabIndex(int tabIndex) {
    final filters = filtersByTab[tabIndex] ?? {};
    final values = filters.map((key, value) => MapEntry(key, value.value));

    switch (tabIndex) {
      case 0:
        return repository.getJobListings(
          job: values['직무'],
          experience: values['신입~5년'],
          location: values['지역'],
          education: values['학력'],
        );
      case 1:
        return repository.getInternships(
          job: values['직무'],
          period: values['기간'],
          location: values['지역'],
          education: values['학력'],
        );
      case 2:
        return repository.getActivities(
          field: values['분야'],
          organization: values['기관'],
          location: values['지역'],
          host: values['주최기관'],
        );
      case 3:
        return repository.getEducationEvents(
          field: values['분야'],
          period: values['기간'],
          location: values['지역'],
          onOffline: values['온/오프라인'],
        );
      case 4:
      default:
        return repository.getFilteredContests(
          field: values['분야'],
          target: values['대상'],
          organizer: values['주최기관'],
          benefit: values['혜택'],
        );
    }
  }

  // ✅ 호환성 유지용 Getter (기존 코드 지원용)

  // 채용 필터
  Rx<String?> get selectedJob => filtersByTab[0]!['직무']!;
  Rx<String?> get selectedExperience => filtersByTab[0]!['신입~5년']!;
  Rx<String?> get selectedLocation => filtersByTab[0]!['지역']!;
  Rx<String?> get selectedEducation => filtersByTab[0]!['학력']!;

  // 인턴 필터
  Rx<String?> get selectedInternJob => filtersByTab[1]!['직무']!;
  Rx<String?> get selectedPeriod => filtersByTab[1]!['기간']!;
  Rx<String?> get selectedInternLocation => filtersByTab[1]!['지역']!;
  Rx<String?> get selectedInternEducation => filtersByTab[1]!['학력']!;

  // 대외활동 필터
  Rx<String?> get selectedField => filtersByTab[2]!['분야']!;
  Rx<String?> get selectedOrganization => filtersByTab[2]!['기관']!;
  Rx<String?> get selectedActivityLocation => filtersByTab[2]!['지역']!;
  Rx<String?> get selectedHost => filtersByTab[2]!['주최기관']!;
  Rx<String?> get selectedActivityPeriod => filtersByTab[2]!['기간']!;

  // 교육/강연 필터
  Rx<String?> get selectedEduField => filtersByTab[3]!['분야']!;
  Rx<String?> get selectedEduPeriod => filtersByTab[3]!['기간']!;
  Rx<String?> get selectedEduLocation => filtersByTab[3]!['지역']!;
  Rx<String?> get selectedOnOffline => filtersByTab[3]!['온/오프라인']!;

  // 공모전 필터
  Rx<String?> get selectedContestField => filtersByTab[4]!['분야']!;
  Rx<String?> get selectedTarget => filtersByTab[4]!['대상']!;
  Rx<String?> get selectedOrganizer => filtersByTab[4]!['주최기관']!;
  Rx<String?> get selectedBenefit => filtersByTab[4]!['혜택']!;
}
