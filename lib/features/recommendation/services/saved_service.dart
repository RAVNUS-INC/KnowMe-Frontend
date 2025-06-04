import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import '../repositories/saved_repository.dart';

class SavedService {
  final SavedRepository _repository = SavedRepository();

  Future<List<Contest>> getSavedContests() async {
    // API 호출을 시뮬레이션하기 위한 지연
    await Future.delayed(const Duration(seconds: 1));

    // 저장된 활동 반환
    return _repository.getSavedContests();
  }

  Future<List<ContestGroup>> getSavedContestGroups() async {
    // API 호출을 시뮬레이션하기 위한 지연
    await Future.delayed(const Duration(seconds: 1));

    // 저장된 활동을 카테고리별로 그룹화하여 가져오기
    final categoryContests = _repository.getSavedCategoryContests();
    
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
  }

  Future<bool> removeBookmark(String contestId) async {
    // API 호출을 시뮬레이션하기 위한 지연
    await Future.delayed(const Duration(milliseconds: 300));

    // 실제로는 서버에 북마크 제거 API를 호출해야 합니다.
    // 성공적으로 처리되었다고 가정하고 true를 반환
    return true;
  }
}
