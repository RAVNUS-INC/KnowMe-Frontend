import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import 'package:logger/logger.dart';
// api service imports
import 'package:knowme_frontend/features/posts/services/employee_api_service.dart';
import 'package:knowme_frontend/features/posts/services/intern_api_service.dart';
import 'package:knowme_frontend/features/posts/services/external_api_service.dart';

/// 게시물 데이터 접근을 위한 Repository 클래스 - Model 계층 담당
class PostRepository {

  final EmployeeApiService _employeeApiService = EmployeeApiService();
  final InternApiService _internApiService = InternApiService();
  final ExternalApiService _externalApiService = ExternalApiService();
  
  final Logger _logger = Logger();
  
  // 채용 정보 필터링해서 가져오기
  Future<List<Contest>> getJobListings({
    String? job,
    String? experience,
    String? location,
    String? education,
    List<String>? educationList,
  }) async {
    try {
      // 경력 문자열을 숫자로 변환
      int? experienceYears = _parseExperienceToInt(experience);

      // 다중 선택 학력을 단일 문자열로 변환
      String? finalEducation = education;
      if (finalEducation == null && educationList != null && educationList.isNotEmpty) {
        finalEducation = educationList.first;
      }

      _logger.d('채용 공고 API 호출 - job: $job, experience: $experienceYears, location: $location, education: $finalEducation');

      // 실제 API 호출
      final response = await _employeeApiService.getEmployeePosts(
        jobTitle: job,
        experience: experienceYears,
        education: finalEducation,
        location: location,
      );

      if (response.isSuccess && response.data != null) {
        // EmployeePost를 Contest로 변환
        final contests = response.data!
            .map((employeePost) => employeePost.toContest())
            .toList();

        _logger.d('채용 공고 ${contests.length}개 조회 성공');
        return contests;
      } else {
        _logger.e('채용 공고 API 호출 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('채용 공고 조회 중 예외 발생: $e');
      return [];
    }
  }

  // 인턴 정보 필터링해서 가져오기
  Future<List<Contest>> getInternListings({
    String? job,
    String? period,
    String? location,
    String? education,
    List<String>? educationList,
  }) async {
    try {
      // 다중 선택 학력을 단일 문자열로 변환
      String? finalEducation = education;
      if (finalEducation == null && educationList != null && educationList.isNotEmpty) {
        finalEducation = educationList.first;
      }

      _logger.d('인턴 공고 API 호출 - job: $job, period: $period, location: $location, education: $finalEducation');

      // 실제 API 호출
      final response = await _internApiService.getInternPosts(
        jobTitle: job,
        period: period,
        education: finalEducation,
        location: location,
      );

      if (response.isSuccess && response.data != null) {
        // InternPost를 Contest로 변환
        final contests = response.data!
            .map((internPost) => internPost.toContest())
            .toList();

        _logger.d('인턴 공고 ${contests.length}개 조회 성공');
        return contests;
      } else {
        _logger.e('인턴 공고 API 호출 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('인턴 공고 조회 중 예외 발생: $e');
      return [];
    }
  }

  /// 경력 문자열을 숫자로 변환하는 헬퍼 메서드
  int? _parseExperienceToInt(String? experience) {
    if (experience == null || experience.isEmpty) return null;

    if (experience.contains('신입')) {
      return 0;
    }
    else if (experience.contains('5년')) {
      return 5;
    } else if (experience.contains('10년')) {
      return 10;
    } else if (experience.contains('15년')) {
      return 15;
    } else if (experience.contains('20년')) {
      return 20;
    }

    final RegExp numberRegex = RegExp(r'\d+');
    final match = numberRegex.firstMatch(experience);
    if (match != null) {
      return int.tryParse(match.group(0) ?? '');
    }

    return null;
  }

  // 대외활동 정보 필터링해서 가져오기 (API 사용)
  Future<List<Contest>> getExternalListings({
    String? field,
    String? period,
    String? location,
    String? host,
    String? organization,  // 하위 호환성을 위해 추가
  }) async {
    try {
      // 주최기관 매개변수: host 우선 사용, 없으면 organization 사용
      final String? finalHost = host ?? organization;

      _logger.d('대외활동 공고 API 호출 - field: $field, period: $period, location: $location, host: $finalHost');

      // 실제 API 호출
      final response = await _externalApiService.getExternalPosts(
        activityField: field,           // 분야
        activityDuration: _parsePeriodToInt(period),  // 기간
        location: location,     // 지역
        hostingOrganization: finalHost,  // 주최기관
      );

      if (response.isSuccess && response.data != null) {
        // ExternalPost를 Contest로 변환
        final contests = response.data!
            .map((externalPost) => externalPost.toContest())
            .toList();

        _logger.d('대외활동 공고 ${contests.length}개 조회 성공');
        return contests;
      } else {
        _logger.e('대외활동 공고 API 호출 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('대외활동 공고 조회 중 예외 발생: $e');
      return [];
    }
  }

  /// 기간 문자열을 숫자로 변환하는 헬퍼 메서드
  int? _parsePeriodToInt(String? period) {
    if (period == null || period.isEmpty) return null;

    if (period.contains('1개월')) {
      return 1;
    }
    else if (period.contains('3개월')) {
      return 3;
    }
    else if (period.contains('6개월')) {
      return 6;
    }
    else if (period.contains('12개월') || period.contains('1년')) {
      return 12;
    }

    final RegExp numberRegex = RegExp(r'\d+');
    final match = numberRegex.firstMatch(period);
    if (match != null) {
      return int.tryParse(match.group(0) ?? '');
    }

    return null;
  }

  // 교육/강연 정보 필터링해서 가져오기
  List<Contest> getEducationEvents({
    String? field,
    String? period,
    String? location,
    String? onOffline,
  }) {
    // 실제 구현에서는 데이터베이스나 API에서 데이터를 가져오고 필터링
    return _getEducationEventsFromDataSource()
        .map((event) =>
            _applyEducationFilters(event, field, period, location, onOffline))
        .toList();
  }

  // 공모전 정보 필터링해서 가져오기
  List<Contest> getFilteredContests({
    String? field,
    String? target,
    String? organizer,
    String? benefit,
  }) {
    // 실제 구현에서는 데이터베이스나 API에서 데이터를 가져오고 필터링
    return _getContestsFromDataSource()
        .map((contest) =>
            _applyContestFilters(contest, field, target, organizer, benefit))
        .toList();
  }


  // 데이터 소스에서 교육/강연 정보 가져오기
  List<Contest> _getEducationEventsFromDataSource() {
    return [
      Contest(
        id: '7',
        title: '실전! AWS 클라우드 엔지니어링 부트캠프 (8주)',
        organization: '클라우드에듀',
        imageUrl: 'assets/images/edu_aws_bootcamp.jpg',
        dateRange: '2024.08.15 ~ 2024.10.15',
        location: '서울 강남 (오프라인)',
        field: 'IT/클라우드',
        additionalInfo: '오프라인',
        benefit: '수료증 발급, 취업 컨설팅',
        target: '클라우드 엔지니어 지망생',
      ),
      Contest(
        id: '8',
        title: '데이터 시각화 마스터클래스 (Tableau 활용)',
        organization: '데이터인사이트 아카데미',
        imageUrl: 'assets/images/edu_data_viz.png',
        dateRange: '2024.09.01 ~ 2024.09.30 (매주 토)',
        location: '온라인 (Zoom)',
        field: '데이터 분석/시각화',
        additionalInfo: '온라인',
        benefit: '강의자료 및 실습 데이터 제공',
        target: '데이터 분석가, 마케터, 기획자',
      ),
      Contest(
        id: '14',
        title: '챗GPT 활용 프롬프트 엔지니어링 워크샵',
        organization: 'AI 러닝센터',
        imageUrl: 'assets/images/edu_prompt_engineering.png',
        dateRange: '2024.07.27 (1일 특강)',
        location: '서울 종로 (오프라인)',
        field: 'AI/챗GPT',
        additionalInfo: '오프라인',
        benefit: '실습 위주, Q&A 세션',
        target: 'AI 기술 활용에 관심 있는 누구나',
      ),
    ];
  }

  // 교육/강연에 필터 적용
  Contest _applyEducationFilters(Contest event, String? field, String? period,
      String? location, String? onOffline) {
    return Contest(
      id: event.id,
      title: event.title,
      organization: event.organization,
      imageUrl: event.imageUrl,
      dateRange: period ?? event.dateRange,
      location: location ?? event.location,
      field: field ?? event.field,
      additionalInfo: onOffline ?? event.additionalInfo,
      benefit: event.benefit,
      target: event.target,
    );
  }

  // 데이터 소스에서 공모전 정보 가져오기
  List<Contest> _getContestsFromDataSource() {
    return [
      Contest(
        id: '9',
        title: '제5회 전국 대학생 앱 개발 챌린지',
        organization: '대한민국 IT 협회',
        imageUrl: 'assets/images/contest_app_dev.png',
        dateRange: '2024.07.01 ~ 2024.09.30',
        location: '온라인 제출 후 본선 오프라인 (서울)',
        field: 'IT/앱개발',
        additionalInfo: '총 상금 3,000만원',
        target: '전국 대학생 및 대학원생 (팀 참가 가능)',
        benefit: '대상 수상팀 장관상 수여',
      ),
      Contest(
        id: '10',
        title: '지속가능한 도시 아이디어 공모전',
        organization: '스마트시티 연구소',
        imageUrl: 'assets/images/contest_sustainable_city.jpg',
        dateRange: '2024.08.15 ~ 2024.11.15',
        location: '온라인 접수',
        field: '사회/도시계획',
        additionalInfo: '우수 아이디어 사업화 지원 검토',
        target: '일반인, 학생, 기업 등 누구나',
        benefit: '총 상금 1,000만원 및 전문가 컨설팅',
      ),
      Contest(
        id: '15',
        title: '단편영화 시나리오 공모전 "나의 이야기"',
        organization: '필름메이커스 포럼',
        imageUrl: 'assets/images/contest_scenario.png',
        dateRange: '2024.07.10 ~ 2024.08.31',
        location: '온라인 접수',
        field: '문화/영화',
        additionalInfo: '20페이지 내외 단편 시나리오',
        target: '신인 및 기성 작가 모두 가능',
        benefit: '대상작 제작 지원금 500만원',
      ),
    ];
  }

  // 공모전에 필터 적용
  Contest _applyContestFilters(Contest contest, String? field, String? target,
      String? organizer, String? benefit) {
    return Contest(
      id: contest.id,
      title: contest.title,
      organization: organizer ?? contest.organization,
      imageUrl: contest.imageUrl,
      dateRange: contest.dateRange,
      location: contest.location,
      field: field ?? contest.field,
      additionalInfo: contest.additionalInfo,
      target: target ?? contest.target,
      benefit: benefit ?? contest.benefit,
    );
  }
}
