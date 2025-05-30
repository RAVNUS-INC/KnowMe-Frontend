import 'package:knowme_frontend/features/posts/models/contest_model.dart';
import '../repositories/recommendation_repositories.dart';

class RecommendationService {
  final RecommendationRepository _repository = RecommendationRepository();
  
  Future<List<ContestGroup>> getRecommendedContests() async {
    // API 호출을 시뮬레이션하기 위한 지연
    await Future.delayed(const Duration(seconds: 1));
    
    final jobContests = _repository.getJobCategoryContests();
    final activityContests = _repository.getActivityCategoryContests();
    final courseContests = _repository.getCourseCategoryContests();
    
    List<ContestGroup> recommendedContests = [];
    
    // 카테고리별 활동을 ContestGroup으로 변환
    for (var categoryContests in [...jobContests, ...activityContests, ...courseContests]) {
      recommendedContests.add(
        ContestGroup(
          groupName: categoryContests.categoryName,
          contests: categoryContests.contests,
        ),
      );
    }
    
    return recommendedContests;
  }
  
  Future<List<Contest>> getSavedContests() async {
    // API 호출을 시뮬레이션하기 위한 지연
    await Future.delayed(const Duration(seconds: 1));
    
    // 저장된 활동 반환
    return _repository.getSavedContests();
  }
  
  Future<bool> toggleBookmark(String contestId) async {
    // API 호출을 시뮬레이션하기 위한 지연
    await Future.delayed(const Duration(milliseconds: 300));
    
    // 실제로는 서버에 북마크 상태를 변경하는 API를 호출해야 합니다.
    // 성공적으로 처리되었다고 가정하고 true를 반환
    return true;
  }
}
