import 'package:knowme_frontend/features/posts/models/contest_model.dart';

class RecommendationRepository {
  List<CategoryContests> getJobCategoryContests() {
    return [
      CategoryContests(
        categoryName: '이한양 님을 위한 채용 공고',
        contests: [
          Contest(
            id: 'job1',
            title: '[코드웨이브] 신입 채용공고 - 프론트엔드 개발자',
            benefit: '프론트엔드 개발자',
            target: '신입',
            company: '코드웨이브',
            imageUrl: 'https://placehold.co/343x164',
            type: ActivityType.job,
            organization: '코드웨이브',
            location: '서울',
            field: 'IT/개발',
            dateRange: '상시채용',
          ),
          Contest(
            id: 'job2',
            title: '[인사이트랩] 프론트엔드 개발자 신규 채용',
            benefit: '프론트엔드 개발자',
            target: '신입',
            company: '인사이트랩',
            imageUrl: 'https://placehold.co/343x164',
            type: ActivityType.job,
            organization: '인사이트랩',
            location: '서울',
            field: 'IT/개발',
            dateRange: '상시채용',
          ),
          Contest(
            id: 'job3',
            title: '[모빌리카] 모빌리카 프론트엔드 개발자 모집',
            benefit: '프론트엔드 개발자',
            target: '경력 무관',
            company: '모빌리카',
            imageUrl: 'https://placehold.co/343x164',
            type: ActivityType.job,
            organization: '모빌리카',
            location: '서울',
            field: 'IT/개발',
            dateRange: '상시채용',
          ),
        ],
      ),
    ];
  }

  List<CategoryContests> getActivityCategoryContests() {
    return [
      CategoryContests(
        categoryName: '맞춤 대외활동 추천',
        contests: [
          Contest(
            id: 'act1',
            title: '인덱서블 프론트엔드 유니버스',
            benefit: '웹 개발 프로젝트',
            target: '3개월',
            company: '인덱서블',
            imageUrl: 'https://placehold.co/343x164',
            type: ActivityType.activity,
            organization: '인덱서블',
            location: '온라인',
            field: '개발/프로젝트',
            dateRange: '2023.12.01~2024.02.28',
          ),
          Contest(
            id: 'act2',
            title: '토스 NEXT 개발자 챌린지',
            benefit: '개발 챌린지',
            target: '1개월',
            company: '토스',
            imageUrl: 'https://placehold.co/343x164',
            type: ActivityType.activity,
            organization: '토스',
            location: '온/오프라인',
            field: '개발/챌린지',
            dateRange: '2023.11.15~2023.12.15',
          ),
        ],
      ),
    ];
  }

  List<CategoryContests> getCourseCategoryContests() {
    return [
      CategoryContests(
        categoryName: '취업 준비 필수 강의',
        contests: [
          Contest(
            id: 'course1',
            title: '디코랩스 직무별 포트폴리오 실전반',
            benefit: '포트폴리오 구성/실무 피드백',
            target: '1개월',
            company: '디코랩스',
            imageUrl: 'https://placehold.co/343x164',
            type: ActivityType.course,
            organization: '디코랩스',
            location: '온라인',
            field: '교육/강의',
            dateRange: '상시수강',
          ),
          Contest(
            id: 'course2',
            title: '노베이지랩 커리어 리부트: 이력서/면접 집중반',
            benefit: '이력서 클리닉/모의면접',
            target: '1개월',
            company: '노베이지랩',
            imageUrl: 'https://placehold.co/343x164',
            type: ActivityType.course,
            organization: '노베이지랩',
            location: '온라인',
            field: '교육/강의',
            dateRange: '상시수강',
          ),
        ],
      ),
    ];
  }
  
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
}
