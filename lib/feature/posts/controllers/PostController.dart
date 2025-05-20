import 'package:get/get.dart';
import '../models/contest_model.dart';
import 'package:knowme_frontend/feature/posts/repositories/PostRepository.dart';

class PostsController extends GetxController {
  final PostRepository repository = PostRepository();

  final RxList<Contest> contests = <Contest>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadContests();
  }

  Future<void> loadContests() async {
    isLoading.value = true;
    try {
      final results = await repository.getFilteredContests();
      contests.assignAll(results);
    } catch (e) {
      // 에러 처리
      print(e.toString());
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
  List<Contest> getFilteredContentsByTabIndex(
    int tabIndex, {
    // 채용 필터
    String? selectedJob,
    String? selectedExperience,
    String? selectedLocation,
    String? selectedEducation,
    // 인턴 필터
    String? selectedInternJob,
    String? selectedPeriod,
    String? selectedInternLocation,
    String? selectedInternEducation,
    // 대외활동 필터
    String? selectedField,
    String? selectedOrganization,
    String? selectedActivityLocation,
    String? selectedHost,
    // 교육/강연 필터
    String? selectedEduField,
    String? selectedEduPeriod,
    String? selectedEduLocation,
    String? selectedOnOffline,
    // 공모전 필터
    String? selectedContestField,
    String? selectedTarget,
    String? selectedOrganizer,
    String? selectedBenefit,
  }) {
    switch (tabIndex) {
      case 0: // 채용
        return repository.getJobListings(
          job: selectedJob,
          experience: selectedExperience,
          location: selectedLocation,
          education: selectedEducation,
        );
      case 1: // 인턴
        return repository.getInternships(
          job: selectedInternJob,
          period: selectedPeriod,
          location: selectedInternLocation,
          education: selectedInternEducation,
        );
      case 2: // 대외활동
        return repository.getActivities(
          field: selectedField,
          organization: selectedOrganization,
          location: selectedActivityLocation,
          host: selectedHost,
        );
      case 3: // 교육/강연
        return repository.getEducationEvents(
          field: selectedEduField,
          period: selectedEduPeriod,
          location: selectedEduLocation,
          onOffline: selectedOnOffline,
        );
      case 4: // 공모전
      default:
        return repository.getFilteredContests(
          field: selectedContestField,
          target: selectedTarget,
          organizer: selectedOrganizer,
          benefit: selectedBenefit,
        );
    }
  }
}
