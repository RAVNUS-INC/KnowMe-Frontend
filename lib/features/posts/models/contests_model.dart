enum ActivityType {
  job, // 채용
  internship, // 인턴십
  activity, // 대외 활동
  course, // 교육/강연
  contest, // 공모전
}

class Contest {
  final String id;
  final String title;
  final String benefit;
  final String target;
  final String imageUrl;
  final String organization;
  final String location;
  final String field;
  final String dateRange;
  final String? additionalInfo; // 추가 정보만 nullable

  final ActivityType type; // 이것도 추가됨
  bool isBookmarked; // 얘도 추가
  final String? company; // 추가된 필드

  Contest({
    required this.id,
    required this.title,
    required this.benefit,
    required this.target,
    required this.imageUrl,
    required this.organization,
    required this.location,
    required this.field,
    required this.dateRange,
    this.additionalInfo,
    // 추가
    this.type = ActivityType.contest,
    this.isBookmarked = false,
    this.company,
  });
}

// RecommendationGroup 클래스와 동일한 기능을 수행하는 클래스
class ContestGroup {
  final String groupName;
  final List<Contest> contests;

  ContestGroup({
    required this.groupName,
    required this.contests,
  });
}

// CategoryActivities와 동일한 기능을 수행하는 클래스
class CategoryContests {
  final String categoryName;
  final List<Contest> contests;

  CategoryContests({
    required this.categoryName,
    required this.contests,
  });
}
