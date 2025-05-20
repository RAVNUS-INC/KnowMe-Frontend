import 'package:get/get.dart';
import '../models/contest_model.dart';
import 'package:knowme_frontend/feature/posts/repositories/PostRepository.dart';

class PostController extends GetxController {
  final PostRepository repository = PostRepository();

  final RxList<Contest> contests = <Contest>[].obs;
  final RxBool isLoading = false.obs;
  
  // 현재 선택된 탭 인덱스
  final RxInt currentTabIndex = 4.obs; // 기본값: 공모전 탭
  
  // 각 탭별 필터 상태 관리 (Rx로 상태 관리)
  // 채용 필터
  final Rx<String?> selectedJob = Rx<String?>(null);
  final Rx<String?> selectedExperience = Rx<String?>(null);
  final Rx<String?> selectedLocation = Rx<String?>(null);
  final Rx<String?> selectedEducation = Rx<String?>(null);

  // 인턴 필터
  final Rx<String?> selectedInternJob = Rx<String?>(null);
  final Rx<String?> selectedPeriod = Rx<String?>(null);
  final Rx<String?> selectedInternLocation = Rx<String?>(null);
  final Rx<String?> selectedInternEducation = Rx<String?>(null);

  // 대외활동 필터
  final Rx<String?> selectedField = Rx<String?>(null);
  final Rx<String?> selectedOrganization = Rx<String?>(null);
  final Rx<String?> selectedActivityLocation = Rx<String?>(null);
  final Rx<String?> selectedHost = Rx<String?>(null);

  // 교육/강연 필터
  final Rx<String?> selectedEduField = Rx<String?>(null);
  final Rx<String?> selectedEduPeriod = Rx<String?>(null);
  final Rx<String?> selectedEduLocation = Rx<String?>(null);
  final Rx<String?> selectedOnOffline = Rx<String?>(null);

  // 공모전 필터
  final Rx<String?> selectedContestField = Rx<String?>(null);
  final Rx<String?> selectedTarget = Rx<String?>(null);
  final Rx<String?> selectedOrganizer = Rx<String?>(null);
  final Rx<String?> selectedBenefit = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadContests();
  }

  // 선택된 탭 변경 시 호출
  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  // 현재 탭의 모든 필터 초기화
  void resetFilters() {
    switch (currentTabIndex.value) {
      case 0: // 채용
        selectedJob.value = null;
        selectedExperience.value = null;
        selectedLocation.value = null;
        selectedEducation.value = null;
        break;
      case 1: // 인턴
        selectedInternJob.value = null;
        selectedPeriod.value = null;
        selectedInternLocation.value = null;
        selectedInternEducation.value = null;
        break;
      case 2: // 대외활동
        selectedField.value = null;
        selectedOrganization.value = null;
        selectedActivityLocation.value = null;
        selectedHost.value = null;
        break;
      case 3: // 교육/강연
        selectedEduField.value = null;
        selectedEduPeriod.value = null;
        selectedEduLocation.value = null;
        selectedOnOffline.value = null;
        break;
      case 4: // 공모전
        selectedContestField.value = null;
        selectedTarget.value = null;
        selectedOrganizer.value = null;
        selectedBenefit.value = null;
        break;
    }
  }

  // 필터 값 업데이트
  void updateFilter(String filterType, String? value) {
    switch (currentTabIndex.value) {
      case 0: // 채용
        switch (filterType) {
          case '직무':
            selectedJob.value = value;
            break;
          case '신입~5년':
            selectedExperience.value = value;
            break;
          case '서울 전체':
          case '지역':
            selectedLocation.value = value;
            break;
          case '학력':
            selectedEducation.value = value;
            break;
        }
        break;
      case 1: // 인턴
        switch (filterType) {
          case '직무':
            selectedInternJob.value = value;
            break;
          case '기간':
            selectedPeriod.value = value;
            break;
          case '지역':
            selectedInternLocation.value = value;
            break;
          case '학력':
            selectedInternEducation.value = value;
            break;
        }
        break;
      case 2: // 대외활동
        switch (filterType) {
          case '분야':
            selectedField.value = value;
            break;
          case '기관':
            selectedOrganization.value = value;
            break;
          case '지역':
            selectedActivityLocation.value = value;
            break;
          case '주최기관':
            selectedHost.value = value;
            break;
        }
        break;
      case 3: // 교육/강연
        switch (filterType) {
          case '분야':
            selectedEduField.value = value;
            break;
          case '기간':
            selectedEduPeriod.value = value;
            break;
          case '지역':
            selectedEduLocation.value = value;
            break;
          case '온/오프라인':
            selectedOnOffline.value = value;
            break;
        }
        break;
      case 4: // 공모전
        switch (filterType) {
          case '분야':
            selectedContestField.value = value;
            break;
          case '대상':
            selectedTarget.value = value;
            break;
          case '주최기관':
            selectedOrganizer.value = value;
            break;
          case '혜택':
            selectedBenefit.value = value;
            break;
        }
        break;
    }
  }
  
  Future<void> loadContests() async {
    isLoading.value = true;
    try {
      final results = repository.getFilteredContests();
      contests.assignAll(results);
    } catch (e) {
      // 에러 처리
     e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // 각 탭별로 필터링된 공모전 목록을 가져오는 메서드
  List<Contest> getFilteredContests({
    String? field,
    String? target,
    String? organizer, 
    String? benefit,
  }) {
    return repository.getFilteredContests(
      field: field,
      target: target,
      organizer: organizer,
      benefit: benefit,
    );
  }

  // 탭 인덱스에 따라 적절한 필터링 메서드 호출
  List<Contest> getFilteredContentsByTabIndex(int tabIndex) {
    switch (tabIndex) {
      case 0: // 채용
        return repository.getJobListings(
          job: selectedJob.value,
          experience: selectedExperience.value,
          location: selectedLocation.value,
          education: selectedEducation.value,
        );
      case 1: // 인턴
        return repository.getInternships(
          job: selectedInternJob.value,
          period: selectedPeriod.value,
          location: selectedInternLocation.value,
          education: selectedInternEducation.value,
        );
      case 2: // 대외활동
        return repository.getActivities(
          field: selectedField.value,
          organization: selectedOrganization.value,
          location: selectedActivityLocation.value,
          host: selectedHost.value,
        );
      case 3: // 교육/강연
        return repository.getEducationEvents(
          field: selectedEduField.value,
          period: selectedEduPeriod.value,
          location: selectedEduLocation.value,
          onOffline: selectedOnOffline.value,
        );
      case 4: // 공모전
      default:
        return repository.getFilteredContests(
          field: selectedContestField.value,
          target: selectedTarget.value,
          organizer: selectedOrganizer.value,
          benefit: selectedBenefit.value,
        );
    }
  }
  
  // 현재 선택된 탭에 대한 필터링된 콘텐츠 가져오기
  List<Contest> getCurrentFilteredContents() {
    return getFilteredContentsByTabIndex(currentTabIndex.value);
  }
}
