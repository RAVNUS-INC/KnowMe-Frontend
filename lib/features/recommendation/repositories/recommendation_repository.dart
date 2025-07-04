import 'package:knowme_frontend/features/posts/models/contests_model.dart';

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
            imageUrl: 'assets/company_images/KakaoTalk_20250605_201020287_07.png',
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
            imageUrl: 'assets/company_images/KakaoTalk_20250605_201219591.png',
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
            imageUrl: 'assets/company_images/KakaoTalk_20250605_201219591_01.png',
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
            imageUrl: 'assets/company_images/KakaoTalk_20250605_201219591_03.png',
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
            imageUrl: 'assets/company_images/KakaoTalk_20250605_201219591_04.png',
            type: ActivityType.activity,
            organization: '토스',
            location: '온/오프라인',
            field: '개발/챌린지',
            dateRange: '2023.11.15~2023.12.15',
          ),
          // 추가된 세 번째 더미 데이터
          Contest(
            id: 'act3',
            title: '팀오렌지 디자인 해커톤',
            benefit: 'UI/UX 디자인 프로젝트',
            target: '2개월',
            company: '팀오렌지',
            imageUrl: 'assets/company_images/KakaoTalk_20250605_201219591_05.png',
            type: ActivityType.activity,
            organization: '팀오렌지',
            location: '오프라인',
            field: '디자인/해커톤',
            dateRange: '2023.10.01~2023.11.30',
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
            imageUrl: 'assets/company_images/KakaoTalk_20250605_201219591_06.png',
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
            imageUrl: 'assets/company_images/KakaoTalk_20250605_201219591_07.png',
            type: ActivityType.course,
            organization: '노베이지랩',
            location: '온라인',
            field: '교육/강의',
            dateRange: '상시수강',
          ),
          // 추가된 세 번째 더미 데이터
          Contest(
            id: 'course3',
            title: '넥스트랩 취업 멘토링 캠프',
            benefit: '1:1 멘토링/포트폴리오 검토',
            target: '2개월',
            company: '넥스트랩',
            imageUrl: 'assets/company_images/KakaoTalk_20250605_201219591_08.png',
            type: ActivityType.course,
            organization: '넥스트랩',
            location: '오프라인',
            field: '교육/강의',
            dateRange: '2023.09.15~2023.11.15',
          ),
        ],
      ),
    ];
  }
}
