import 'package:knowme_frontend/feature/posts/models/contest_model.dart';

class PostRepository {
  // 채용 관련 더미 데이터
  List<Contest> getJobListings({
    String? job,
    String? experience,
    String? location,
    String? education,
  }) {
    final jobListings = [
      Contest(
        id: 'job1',
        title: '코드웨이브 신입 채용공고 - 프론트엔드 개발자',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '업계 상위 연봉',
        target: '신입',
        field: '개발',
        organizer: '코드웨이브',
      ),
      Contest(
        id: 'job2',
        title: '넥스트링크 iOS 개발자 채용',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '스톡옵션',
        target: '3~5년',
        field: '개발',
        organizer: '넥스트링크',
      ),
      Contest(
        id: 'job3',
        title: '브레인코드 백엔드 엔지니어 모집',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '유연근무',
        target: '1~3년',
        field: '개발',
        organizer: '브레인코드',
      ),
      Contest(
        id: 'job4',
        title: '디자인허브 UI/UX 디자이너 채용',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '재택근무',
        target: '신입',
        field: '디자인',
        organizer: '디자인허브',
      ),
    ];

    return jobListings.where((listing) {
      bool matchesJob = job == null || listing.field == job;
      bool matchesExperience = experience == null || listing.target == experience;
      bool matchesLocation = location == null || true; // 위치는 더미 데이터에 없음
      bool matchesEducation = education == null || true; // 학력은 더미 데이터에 없음

      return matchesJob && matchesExperience && matchesLocation && matchesEducation;
    }).toList();
  }

  // 인턴 관련 더미 데이터
  List<Contest> getInternships({
    String? job,
    String? period,
    String? location,
    String? education,
  }) {
    final internships = [
      Contest(
        id: 'intern1',
        title: '네오테크 여름방학 개발 인턴',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '채용 연계 가능',
        target: '대학생',
        field: '개발',
        organizer: '네오테크',
      ),
      Contest(
        id: 'intern2',
        title: '그린디자인 UI/UX 인턴십',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '실무 경험',
        target: '대학생',
        field: '디자인',
        organizer: '그린디자인',
      ),
      Contest(
        id: 'intern3',
        title: '비즈니스플러스 마케팅 인턴',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '우수 인턴 정규직 전환',
        target: '대학생',
        field: '마케팅',
        organizer: '비즈니스플러스',
      ),
    ];

    return internships.where((internship) {
      bool matchesJob = job == null || internship.field == job;
      bool matchesPeriod = period == null || true; // 기간은 더미 데이터에 없음
      bool matchesLocation = location == null || true; // 위치는 더미 데이터에 없음
      bool matchesEducation = education == null || internship.target == education;

      return matchesJob && matchesPeriod && matchesLocation && matchesEducation;
    }).toList();
  }

  // 대외활동 관련 더미 데이터
  List<Contest> getActivities({
    String? field,
    String? organization,
    String? location,
    String? host,
  }) {
    final activities = [
      Contest(
        id: 'activity1',
        title: '미래인재 리더십 캠프',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '리더십 인증서',
        target: '대학생',
        field: '리더십',
        organizer: '미래재단',
      ),
      Contest(
        id: 'activity2',
        title: '대학생 마케팅 연합동아리',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '기업 연계 프로젝트',
        target: '대학생',
        field: '마케팅',
        organizer: '마케팅협회',
      ),
      Contest(
        id: 'activity3',
        title: '청년 봉사단 모집',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '봉사활동 인증',
        target: '청년',
        field: '사회공헌',
        organizer: '나눔재단',
      ),
    ];

    return activities.where((activity) {
      bool matchesField = field == null || activity.field == field;
      bool matchesOrganization = organization == null || true; // 기관은 더미 데이터에 없음
      bool matchesLocation = location == null || true; // 위치는 더미 데이터에 없음
      bool matchesHost = host == null || activity.organizer == host;

      return matchesField && matchesOrganization && matchesLocation && matchesHost;
    }).toList();
  }

  // 교육/강연 관련 더미 데이터
  List<Contest> getEducationEvents({
    String? field,
    String? period,
    String? location,
    String? onOffline,
  }) {
    final educationEvents = [
      Contest(
        id: 'edu1',
        title: '웹 개발 부트캠프',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '수료증',
        target: '제한없음',
        field: '개발',
        organizer: '코딩에듀',
      ),
      Contest(
        id: 'edu2',
        title: '디지털 마케팅 마스터 클래스',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '실무 프로젝트',
        target: '제한없음',
        field: '마케팅',
        organizer: '디지털아카데미',
      ),
      Contest(
        id: 'edu3',
        title: 'UX 디자인 워크샵',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '포트폴리오 제작',
        target: '디자이너',
        field: '디자인',
        organizer: 'UX스쿨',
      ),
    ];

    return educationEvents.where((event) {
      bool matchesField = field == null || event.field == field;
      bool matchesPeriod = period == null || true; // 기간은 더미 데이터에 없음
      bool matchesLocation = location == null || true; // 위치는 더미 데이터에 없음
      bool matchesOnOffline = onOffline == null || true; // 온오프라인은 더미 데이터에 없음

      return matchesField && matchesPeriod && matchesLocation && matchesOnOffline;
    }).toList();
  }

  // 공모전 관련 더미 데이터
  List<Contest> getFilteredContests({
    String? field,
    String? target,
    String? organizer,
    String? benefit,
  }) {
    final contests = [
      Contest(
        id: 'contest1',
        title: '코디언 AI 서비스 기획 공모전',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '인턴 채용 연계',
        target: '대학생',
        field: 'IT',
        organizer: '코디언',
      ),
      Contest(
        id: 'contest2',
        title: '제12회 한국환경연구원 탄소중립 아이디어 공모전',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '환경부 장관상/상금',
        target: '제한없음',
        field: '환경',
        organizer: '한국환경연구원',
      ),
      Contest(
        id: 'contest3',
        title: '라인앤노트 마케팅 카피 공모전',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '상금/수상작 상용화',
        target: '제한없음',
        field: '마케팅',
        organizer: '라인앤노트',
      ),
      Contest(
        id: 'contest4',
        title: '브레인코드 IT 문제해결 공모전',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '상금/입사 가산점',
        target: '대학생/일반인',
        field: 'IT',
        organizer: '브레인코드',
      ),
      Contest(
        id: 'contest5',
        title: '넥스트픽 IR 피칭 경진대회',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '상금/투자 연계 기회',
        target: '대학생/일반인',
        field: '창업',
        organizer: '넥스트픽',
      ),
      Contest(
        id: 'contest6',
        title: '서울특별시 도시재생 디자인 공모전',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '상금/수상작 상용화',
        target: '제한없음',
        field: '디자인',
        organizer: '서울특별시',
      ),
      Contest(
        id: 'contest7',
        title: '페인트리 UI/UX 리디자인 챌린지',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '상금/입사 가산점',
        target: '대학생/일반인',
        field: '디자인',
        organizer: '페인트리',
      ),
      Contest(
        id: 'contest8',
        title: '스터디코리아 대학생 영어 에세이 공모전',
        imageUrl: 'https://placehold.co/164x164',
        benefit: '해외연수',
        target: '대학생',
        field: '어학',
        organizer: '스터디코리아',
      ),
    ];

    return contests.where((contest) {
      bool matchesField = field == null || contest.field == field;
      bool matchesTarget = target == null || contest.target.contains(target);
      bool matchesOrganizer = organizer == null || contest.organizer == organizer;
      bool matchesBenefit = benefit == null || contest.benefit.contains(benefit);

      return matchesField && matchesTarget && matchesOrganizer && matchesBenefit;
    }).toList();
  }

  // 공모전 상세 정보 (PostDetailScreen에서 사용)
  ContestDetail getContestDetail(String id) {
    // 실제 구현에서는 DB 또는 API로부터 데이터를 가져와야 함
    // 현재는 id가 'contest1'일 때만 데이터 반환
    if (id == 'contest1') {
      return ContestDetail(
        id: 'contest1',
        title: '코디언 AI 서비스 기획 공모전',
        imageUrl: 'https://placehold.co/164x164',
        companyName: '코디언',
        description: '코디언은 AI 기반 솔루션을 개발하는 기업으로, 혁신적인 AI 서비스를 기획할 수 있는 인재를 찾고 있습니다.\n\n우리는 "AI로 만드는 더 나은 세상"이라는 비전 아래 다양한 문제를 해결하는 서비스를 개발하고 있습니다. 창의적인 아이디어로 함께하실 분을 기다립니다.',
        field: 'IT',
        target: '대학생',
        benefit: '인턴 채용 연계',
        organizer: '코디언',
        eligibility: ['대학(원) 재학생 및 휴학생', '전공 제한 없음', '개인 또는 4인 이하 팀 참가 가능'],
        requirements: [
          'AI 서비스 기획서 (10페이지 이내)',
          '서비스 가치 제안 및 비즈니스 모델',
          '주요 기능 및 UI 와이어프레임'
        ],
        preferredSkills: [
          'AI/ML에 대한 기본적인 이해',
          'UI/UX 디자인 경험',
          '서비스 기획 관련 경험'
        ],
        workingConditions: [
          '수상자 인턴십: 3개월 (2024년 7월~9월)',
          '근무지: 서울 강남구 테헤란로',
          '인턴십 기간 월 200만원 지원'
        ],
        benefits: [
          '대상(1팀): 상금 200만원 및 인턴십 기회',
          '최우수상(2팀): 상금 100만원 및 인턴십 기회',
          '우수상(3팀): 상금 50만원',
          '인턴십 우수 수료자 정규직 채용 기회'
        ],
        processDescription: '1. 접수 → 2. 서류심사 → 3. 발표심사 → 4. 시상 및 인턴십 연계',
        applicationMethod: '공식 홈페이지에서 지원서 작성 및 기획서 제출: www.codian.ai/contest',
        applicationDeadline: '2024년 6월 30일(일) 23:59까지',
      );
    } else {
      // 기본 더미 데이터 (실제 구현에서는 에러 처리 필요)
      return ContestDetail(
        id: id,
        title: '공모전 제목',
        imageUrl: 'https://placehold.co/164x164',
        companyName: '회사명',
        description: '공모전 설명',
        field: '분야',
        target: '대상',
        benefit: '혜택',
        organizer: '주최기관',
        eligibility: ['참가 자격 1', '참가 자격 2'],
        requirements: ['요구사항 1', '요구사항 2'],
        preferredSkills: ['우대사항 1', '우대사항 2'],
        workingConditions: ['근무 조건 1', '근무 조건 2'],
        benefits: ['혜택 1', '혜택 2'],
        processDescription: '프로세스 설명',
        applicationMethod: '지원 방법',
        applicationDeadline: '지원 마감일',
      );
    }
  }
}
