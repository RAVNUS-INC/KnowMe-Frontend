import 'package:knowme_frontend/features/posts/models/contests_model.dart';

class SavedRepository {
  List<Contest> getSavedContests() {
    // 사용자가 저장한 활동 목록
    return [
      Contest(
        id: 'saved1',
        title: '네이버 부스트캠프 웹·모바일 7기',
        benefit: '개발 교육',
        target: '6개월',
        company: '네이버',
        imageUrl: 'https://placehold.co/343x164',
        type: ActivityType.activity,
        isBookmarked: true,
        organization: '네이버',
        location: '온라인',
        field: '교육/개발',
        dateRange: '2023.12.01~2024.05.31',
      ),
      Contest(
        id: 'saved2',
        title: '[카카오] 프론트엔드 개발자 채용',
        benefit: '프론트엔드 개발자',
        target: '신입/경력',
        company: '카카오',
        imageUrl: 'https://placehold.co/343x164',
        type: ActivityType.job,
        isBookmarked: true,
        organization: '카카오',
        location: '경기도 성남시',
        field: 'IT/개발',
        dateRange: '상시채용',
      ),
    ];
  }
  
  // 카테고리별로 저장된 활동을 가져오는 메서드 추가
  List<CategoryContests> getSavedCategoryContests() {
    // 저장된 활동들을 타입별로 그룹화하여 카테고리 형태로 반환
    final savedItems = getSavedContests();
    
    // 활동 타입별로 그룹화
    final Map<ActivityType, List<Contest>> groupedByType = {};
    
    for (var contest in savedItems) {
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
