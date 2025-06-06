import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import '../repositories/saved_repository.dart';
import 'package:logger/logger.dart';

class SavedService {
  final SavedRepository _repository = SavedRepository();
  final Logger _logger = Logger();

  Future<List<Contest>> getSavedContests() async {
    try {
      // API에서 저장된 활동 목록을 가져오기
      return await _repository.getSavedContestsFromApi();
    } catch (e) {
      _logger.e('저장된 활동 로드 중 오류: $e');
      return [];
    }
  }

  Future<List<ContestGroup>> getSavedContestGroups() async {
    try {
      // API에서 저장된 활동을 카테고리별로 가져오기
      final categoryContests = await _repository.getSavedCategoryContestsFromApi();
      
      List<ContestGroup> savedGroups = [];

      // 카테고리별 활동을 ContestGroup으로 변환
      for (var category in categoryContests) {
        savedGroups.add(
          ContestGroup(
            groupName: category.categoryName,
            contests: category.contests,
          ),
        );
      }

      return savedGroups;
    } catch (e) {
      _logger.e('저장된 활동 그룹 로드 중 오류: $e');
      return [];
    }
  }

  Future<bool> removeBookmark(String contestId) async {
    // API 호출을 시뮬레이션하기 위한 지연
    await Future.delayed(const Duration(milliseconds: 300));

    // 실제로는 서버에 북마크 제거 API를 호출해야 합니다.
    // 성공적으로 처리되었다고 가정하고 true를 반환
    return true;
  }
}
