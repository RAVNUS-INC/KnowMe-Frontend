import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import '../services/get_saved_posts_api_service.dart';
import 'package:logger/logger.dart';

class SavedRepository {
  final GetSavedPostsApiService _apiService = GetSavedPostsApiService();
  final Logger _logger = Logger();

  // API를 통해 저장된 활동 목록 가져오기
  Future<List<Contest>> getSavedContestsFromApi() async {
    try {
      final response = await _apiService.getUserSavedPosts();
      
      if (response.isSuccess && response.data != null) {
        // SavedPostResponse 객체를 Contest 모델로 변환
        if (response.data!.isEmpty) {
          _logger.d('저장한 활동이 없습니다.');
          return [];
        }
        
        _logger.d('저장한 활동을 성공적으로 가져왔습니다: ${response.data!.length}개');
        return response.data!.map((savedPost) => savedPost.toContest()).toList();
      } else {
        if (response.statusCode == 400) {
          _logger.e('잘못된 요청: API 경로 또는 매개변수가 올바르지 않습니다. 상태 코드: ${response.statusCode}');
        } else if (response.statusCode == 401) {
          _logger.e('인증 오류: 사용자 토큰이 유효하지 않거나 만료되었습니다. 상태 코드: ${response.statusCode}');
        } else if (response.statusCode == 404) {
          _logger.e('리소스를 찾을 수 없음: API 엔드포인트가 존재하지 않습니다. 상태 코드: ${response.statusCode}');
        } else {
          _logger.e('저장된 활동 로드 실패: ${response.message}, 상태 코드: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      _logger.e('저장된 활동 API 호출 중 예외 발생: $e');
      return [];
    }
  }
  
  // API를 사용하여 저장된 활동을 카테고리별로 가져오는 메서드
  Future<List<CategoryContests>> getSavedCategoryContestsFromApi() async {
    try {
      final savedItems = await getSavedContestsFromApi();
      
      if (savedItems.isEmpty) {
        _logger.d('저장된 활동이 없거나 API 호출에 실패했습니다.');
        return [];
      }
      
      // 활동 타입별로 그룹화
      return _groupContestsByType(savedItems);
    } catch (e) {
      _logger.e('저장된 활동 카테고리 생성 중 예외 발생: $e');
      return [];
    }
  }
  
  // 컨테스트를 타입별로 그룹화하는 헬퍼 메서드
  List<CategoryContests> _groupContestsByType(List<Contest> contests) {
    // 활동 타입별로 그룹화
    final Map<ActivityType, List<Contest>> groupedByType = {};
    
    for (var contest in contests) {
      if (!groupedByType.containsKey(contest.type)) {
        groupedByType[contest.type] = [];
      }
      groupedByType[contest.type]!.add(contest);
    }
    
    // 카테고리 리스트로 변환
    List<CategoryContests> categories = [];
    
    if (groupedByType.containsKey(ActivityType.job)) {
      categories.add(CategoryContests(
        categoryName: '저장한 채용 공고',
        contests: groupedByType[ActivityType.job]!,
      ));
    }
    
    if (groupedByType.containsKey(ActivityType.activity)) {
      categories.add(CategoryContests(
        categoryName: '저장한 대외활동',
        contests: groupedByType[ActivityType.activity]!,
      ));
    }
    
    if (groupedByType.containsKey(ActivityType.course)) {
      categories.add(CategoryContests(
        categoryName: '저장한 강의',
        contests: groupedByType[ActivityType.course]!,
      ));
    }
    
    return categories;
  }
}
