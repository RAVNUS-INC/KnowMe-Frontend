import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import 'package:logger/logger.dart';
// api service imports
import 'package:knowme_frontend/features/posts/services/employee_api_service.dart';
import 'package:knowme_frontend/features/posts/services/intern_api_service.dart';
import 'package:knowme_frontend/features/posts/services/external_api_service.dart';
import 'package:knowme_frontend/features/posts/services/education_api_service.dart';
import 'package:knowme_frontend/features/posts/services/contest_api_service.dart';

/// 게시물 데이터 접근을 위한 Repository 클래스 - Model 계층 담당
class PostRepository {

  final EmployeeApiService _employeeApiService = EmployeeApiService();
  final InternApiService _internApiService = InternApiService();
  final ExternalApiService _externalApiService = ExternalApiService();
  final EducationApiService _educationApiService = EducationApiService();
  final ContestApiService _contestApiService = ContestApiService();
  
  final Logger _logger = Logger();
  
  /// 탭 인덱스에 따른 컨텐츠 목록을 가져오는 메서드 (userId 포함)
  Future<List<Contest>> getContests({required int tabIndex, required String userId}) async {
    _logger.d('getContests 호출: tabIndex=$tabIndex, userId=$userId');
    
    try {
      switch (tabIndex) {
        case 0: // 채용
          return await getJobListings();
        case 1: // 인턴
          return await getInternListings();
        case 2: // 대외활동
          return await getExternalListings();
        case 3: // 교육/강연
          return await getEducationListings();
        case 4: // 공모전
          return await getFilteredContests();
        default:
          _logger.w('지원하지 않는 탭 인덱스: $tabIndex');
          return [];
      }
    } catch (e) {
      _logger.e('컨텐츠 로드 실패: $e');
      return [];
    }
  }
  
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

  // 교육/강연 정보 필터링해서 가져오기 (API 사용)
  Future<List<Contest>> getEducationListings({
    String? field,
    String? period,
    String? location,
    String? onOffline,
  }) async {
    try {
      _logger.d('교육/강연 공고 API 호출 - field: $field, period: $period, location: $location, onOffline: $onOffline');

      // 실제 API 호출
      final response = await _educationApiService.getEducationPosts(
        activityField: field,           // 분야
        activityDuration: _parsePeriodToInt(period),  // 기간
        location: location,             // 지역
        onlineOrOffline: onOffline,     // 온/오프라인
      );

      if (response.isSuccess && response.data != null) {
        // EducationPost를 Contest로 변환
        final contests = response.data!
            .map((educationPost) => educationPost.toContest())
            .toList();

        _logger.d('교육/강연 공고 ${contests.length}개 조회 성공');
        return contests;
      } else {
        _logger.e('교육/강연 공고 API 호출 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('교육/강연 공고 조회 중 예외 발생: $e');
      return [];
    }
  }

  // 공모전 정보 필터링해서 가져오기 (API 사용)
  Future<List<Contest>> getFilteredContests({
    String? field,
    String? target,
    String? organizer,
    String? benefit,
  }) async {
    try {
      _logger.d('공모전 공고 API 호출 - field: $field, target: $target, organizer: $organizer, benefit: $benefit');

      // 실제 API 호출
      final response = await _contestApiService.getContestPosts(
        activityField: field,           // 분야
        targetAudience: target,         // 대상
        hostingOrganization: organizer, // 주최기관
        contestBenefits: benefit,       // 혜택
      );

      if (response.isSuccess && response.data != null) {
        // ContestPost를 Contest로 변환
        final contests = response.data!
            .map((contestPost) => contestPost.toContest())
            .toList();

        _logger.d('공모전 공고 ${contests.length}개 조회 성공');
        return contests;
      } else {
        _logger.e('공모전 공고 API 호출 실패: ${response.message}');
        // API 호출에 실패했을 때 빈 배열 대신 백업 데이터 제공
        return [];
      }
    } catch (e) {
      _logger.e('공모전 공고 조회 중 예외 발생: $e');
      // 예외 발생 시 백업 데이터 제공
      return [];
    }
  }
}
