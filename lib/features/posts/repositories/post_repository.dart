import '../models/contest_model.dart';

/// 게시물 데이터 접근을 위한 리포지토리 클래스
class PostRepository {
  // 채용 정보 필터링해서 가져오기
  List<Contest> getJobListings({
    String? job,
    String? experience,
    String? location,
    String? education,
    List<String>? educationList, // 채용 탭 전용 학력 목록
  }) {
    // 기본 데이터 목록
    final allJobs = [
      Contest(
        id: 1,
        title: '프론트엔드 개발자 (React, 3년 이상)',
        organization: '주식회사 멋쟁이들',
        imageUrl: 'assets/images/company_a_logo.png', // 예시 이미지 경로
        dateRange: '상시채용',
        location: '서울 강남구',
        field: '프론트엔드 개발',
        benefit: '스톡옵션, 유연근무제',
        target: '경력 3년 이상',
      ),
      Contest(
        id: 2,
        title: '신입 마케팅 콘텐츠 에디터',
        organization: '알잘딱깔센 마케팅',
        imageUrl: 'assets/images/company_b_banner.jpg',
        dateRange: '2024.08.01 ~ 2024.08.31',
        location: '경기 성남시 분당구',
        field: '콘텐츠 마케팅',
        benefit: '성과급, 교육 지원',
        target: '학력무관, 신입 가능',
      ),
      Contest(
        id: 11,
        title: '백엔드 개발자 (Java/Spring)',
        organization: '튼튼 IT 솔루션',
        imageUrl: 'assets/images/company_c_logo.png',
        dateRange: '채용시 마감',
        location: '부산 해운대구',
        field: '백엔드 개발',
        benefit: '주택자금 대출, 복지포인트',
        target: '경력 2년 이상 Spring 경험자',
      ),
    ];
    
    // 필터링 적용
    return allJobs.where((jobItem) {
      // null safety 처리를 위한 null 체크
      final String fieldValue = jobItem.field ?? '';
      final String locationValue = jobItem.location ?? '';
      final String targetValue = jobItem.target ?? '';
      
      // 직무 필터링 - null 체크 추가
      bool matchesJob = job == null || job.isEmpty || fieldValue.contains(job);
      
      // 지역 필터링 - null 체크 추가
      bool matchesLocation = location == null || location.isEmpty || locationValue.contains(location);
      
      // 학력 필터링 - 단일 선택 또는 다중 선택 지원
      bool matchesEducation = true;
      if (education != null && education.isNotEmpty) {
        matchesEducation = targetValue.contains(education);
      } else if (educationList != null && educationList.isNotEmpty) {
        matchesEducation = educationList.any((edu) => targetValue.contains(edu));
      }
      
      // 경력 필터링 - null 체크 추가
      bool matchesExperience = experience == null || experience.isEmpty || targetValue.contains(experience);
      
      return matchesJob && matchesLocation && matchesEducation && matchesExperience;
    }).toList();
  }

  // 인턴 정보 필터링해서 가져오기
  List<Contest> getInternships({
    String? job,
    String? period,
    String? location,
    String? education,
    List<String>? educationList, // 인턴 탭 전용 학력 목록
  }) {
    // 기본 데이터
    final allInterns = [
      Contest(
        id: 3,
        title: '2024 하계 UX/UI 디자인 인턴',
        organization: '디자인팩토리',
        imageUrl: 'assets/images/intern_ux_banner.png',
        dateRange: '2024.07.01 ~ 2024.08.31', // period 필터링에 사용될 수 있음
        location: '서울 마포구',
        field: 'UX/UI 디자인',
        benefit: '정규직 전환 가능, 인턴 수료증',
        target: '대학교 재학생/졸업예정자',
      ),
      Contest(
        id: 4,
        title: '글로벌 사업개발팀 인턴 (영어 능통자)',
        organization: '월드와이드 컴퍼니',
        imageUrl: 'assets/images/intern_global_logo.jpg',
        dateRange: '2024.09.01 ~ 2024.12.31',
        location: '인천 송도',
        field: '사업개발',
        benefit: '실무 경험, 외국어 사용 환경',
        target: '영어 능통자, 관련 전공 우대',
      ),
      Contest(
        id: 12,
        title: 'AI 데이터 분석 인턴십 프로그램',
        organization: '데이터사이언스랩',
        imageUrl: 'assets/images/intern_ai_poster.png',
        dateRange: '2024.07.15 ~ 2024.10.15',
        location: '대전 유성구',
        field: '데이터 분석',
        benefit: '전문가 멘토링, 프로젝트 참여',
        target: '통계학, 컴퓨터공학 전공자',
      ),
    ];
    
    // 필터링 적용
    return allInterns.where((intern) {
      // null safety 처리를 위한 null 체크
      final String fieldValue = intern.field ?? '';
      final String locationValue = intern.location ?? '';
      final String targetValue = intern.target ?? '';
      final String dateRangeValue = intern.dateRange ?? '';
      
      // 직무 필터링
      bool matchesJob = job == null || job.isEmpty || fieldValue.contains(job);
      
      // 지역 필터링
      bool matchesLocation = location == null || location.isEmpty || locationValue.contains(location);
      
      // 학력 필터링
      bool matchesEducation = true;
      if (education != null && education.isNotEmpty) {
        matchesEducation = targetValue.contains(education);
      } else if (educationList != null && educationList.isNotEmpty) {
        matchesEducation = educationList.any((edu) => targetValue.contains(edu));
      }
      
      // 기간 필터링
      bool matchesPeriod = period == null || period.isEmpty || dateRangeValue.contains(period);
      
      return matchesJob && matchesLocation && matchesEducation && matchesPeriod;
    }).toList();
  }

  // 대외활동 정보 필터링해서 가져오기
  List<Contest> getActivities({
    String? field,
    String? organization, // organization 필터링에 사용
    String? location,
    String? host, // host 필터링에 사용
  }) {
    return [
      Contest(
        id: 5,
        title: '대학생 환경보호 서포터즈 "그린메이트" 10기',
        organization: host ?? organization ?? '푸른환경재단',
        imageUrl: 'assets/images/activity_greenmate.jpg',
        dateRange: '2024.07.20 ~ 2024.12.20',
        location: location ?? '전국 (온/오프라인 병행)',
        field: field ?? '환경/봉사',
        benefit: '활동비 지원, 우수활동자 표창',
        target: '환경에 관심있는 대학생 누구나',
      ),
      Contest(
        id: 6,
        title: '청소년 코딩 교육 봉사단 모집',
        organization: host ?? organization ?? '코딩천사들',
        imageUrl: 'assets/images/activity_coding_angel.png',
        dateRange: '2024.08.01 ~ 2024.11.30',
        location: location ?? '서울/경기 지역아동센터',
        field: field ?? 'IT/교육봉사',
        benefit: '봉사시간 인정, 교육자료 제공',
        target: '코딩 교육 경험자 또는 관심있는 대학생',
      ),
      Contest(
        id: 13,
        title: 'K-Culture 홍보대사 3기 모집',
        organization: host ?? organization ?? '한국문화교류원',
        imageUrl: 'assets/images/activity_kculture.png',
        dateRange: '2024.09.01 ~ 2025.02.28',
        location: location ?? '온라인 중심 (월 1회 오프라인 모임)',
        field: field ?? '문화/홍보',
        benefit: '위촉장 수여, 문화행사 참여 기회',
        target: 'SNS 활용 능숙자, 외국어 가능자 우대',
      ),
    ];
  }

  // 교육/강연 정보 필터링해서 가져오기
  List<Contest> getEducationEvents({
    String? field,
    String? period,
    String? location,
    String? onOffline,
  }) {
    return [
      Contest(
        id: 7,
        title: '실전! AWS 클라우드 엔지니어링 부트캠프 (8주)',
        organization: '클라우드에듀',
        imageUrl: 'assets/images/edu_aws_bootcamp.jpg',
        dateRange: period ?? '2024.08.15 ~ 2024.10.15',
        location: location ?? '서울 강남 (오프라인)',
        field: field ?? 'IT/클라우드',
        additionalInfo: onOffline ?? '오프라인',
        benefit: '수료증 발급, 취업 컨설팅',
        target: '클라우드 엔지니어 지망생',
      ),
      Contest(
        id: 8,
        title: '데이터 시각화 마스터클래스 (Tableau 활용)',
        organization: '데이터인사이트 아카데미',
        imageUrl: 'assets/images/edu_data_viz.png',
        dateRange: period ?? '2024.09.01 ~ 2024.09.30 (매주 토)',
        location: location ?? '온라인 (Zoom)',
        field: field ?? '데이터 분석/시각화',
        additionalInfo: onOffline ?? '온라인',
        benefit: '강의자료 및 실습 데이터 제공',
        target: '데이터 분석가, 마케터, 기획자',
      ),
      Contest(
        id: 14,
        title: '챗GPT 활용 프롬프트 엔지니어링 워크샵',
        organization: 'AI 러닝센터',
        imageUrl: 'assets/images/edu_prompt_engineering.png',
        dateRange: period ?? '2024.07.27 (1일 특강)',
        location: location ?? '서울 종로 (오프라인)',
        field: field ?? 'AI/챗GPT',
        additionalInfo: onOffline ?? '오프라인',
        benefit: '실습 위주, Q&A 세션',
        target: 'AI 기술 활용에 관심 있는 누구나',
      ),
    ];
  }

  // 공모전 정보 필터링해서 가져오기
  List<Contest> getFilteredContests({
    String? field,
    String? target,
    String? organizer,
    String? benefit,
  }) {
    return [
      Contest(
        id: 9,
        title: '제5회 전국 대학생 앱 개발 챌린지',
        organization: organizer ?? '대한민국 IT 협회',
        imageUrl: 'assets/images/contest_app_dev.png',
        dateRange: '2024.07.01 ~ 2024.09.30',
        location: '온라인 제출 후 본선 오프라인 (서울)',
        field: field ?? 'IT/앱개발',
        additionalInfo: '총 상금 3,000만원',
        target: target ?? '전국 대학생 및 대학원생 (팀 참가 가능)',
        benefit: benefit ?? '대상 수상팀 장관상 수여',
      ),
      Contest(
        id: 10,
        title: '지속가능한 도시 아이디어 공모전',
        organization: organizer ?? '스마트시티 연구소',
        imageUrl: 'assets/images/contest_sustainable_city.jpg',
        dateRange: '2024.08.15 ~ 2024.11.15',
        location: '온라인 접수',
        field: field ?? '사회/도시계획',
        additionalInfo: '우수 아이디어 사업화 지원 검토',
        target: target ?? '일반인, 학생, 기업 등 누구나',
        benefit: benefit ?? '총 상금 1,000만원 및 전문가 컨설팅',
      ),
      Contest(
        id: 15,
        title: '단편영화 시나리오 공모전 "나의 이야기"',
        organization: organizer ?? '필름메이커스 포럼',
        imageUrl: 'assets/images/contest_scenario.png',
        dateRange: '2024.07.10 ~ 2024.08.31',
        location: '온라인 접수',
        field: field ?? '문화/영화',
        additionalInfo: '20페이지 내외 단편 시나리오',
        target: target ?? '신인 및 기성 작가 모두 가능',
        benefit: benefit ?? '대상작 제작 지원금 500만원',
      ),
    ];
  }
}
