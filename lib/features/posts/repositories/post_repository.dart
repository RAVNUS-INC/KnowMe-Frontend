import 'package:knowme_frontend/core/constants/post_api_constants.dart';
import 'package:knowme_frontend/features/posts/models/postsPostid_model.dart';
import 'package:knowme_frontend/shared/services/api_client.dart';
import 'package:logger/logger.dart';

/// 게시물 데이터 접근을 위한 Repository 클래스 - API로부터 데이터를 받아옵니다.
class PostRepository {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();

  // API를 통한 전체 게시물 조회
  Future<List<PostModel>> fetchAllPosts() async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        PostApiEndpoints.postsAll,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _logger.i('전체 게시물 조회 성공');

        // Map<String, dynamic> 타입으로 변환 후 fromJson 적용
        List<PostModel> posts = [];
        for (var item in response.data!) {
          if (item is Map<String, dynamic>) {
            posts.add(_createPostModelFromJson(item));
          }
        }

        return posts;
      } else {
        _logger.e('전체 게시물 조회 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('전체 게시물 조회 중 오류 발생: $e');
      return [];
    }
  }

  // API를 통한 채용 공고 조회 (페이징)
  Future<List<PostModel>> fetchEmploymentPosts({
    int page = 1,
    int size = 10,
    String? job,
    String? experience,
    String? location,
    String? education,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
      };

      if (job != null && job.isNotEmpty) queryParams['job'] = job;
      if (experience != null && experience.isNotEmpty) queryParams['experience'] = experience;
      if (location != null && location.isNotEmpty) queryParams['location'] = location;
      if (education != null && education.isNotEmpty) queryParams['education'] = education;

      final response = await _apiClient.get<List<dynamic>>(
        PostApiEndpoints.postsEmployee,
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _logger.i('채용 공고 조회 성공');

        // Map<String, dynamic> 타입으로 변환 후 fromJson 적용
        List<PostModel> posts = [];
        for (var item in response.data!) {
          if (item is Map<String, dynamic>) {
            posts.add(_createPostModelFromJson(item));
          }
        }

        return posts;
      } else {
        _logger.e('채용 공고 조회 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('채용 공고 조회 중 오류 발생: $e');
      return [];
    }
  }

  // API를 통한 인턴 공고 조회 (페이징)
  Future<List<PostModel>> fetchInternPosts({
    int page = 1,
    int size = 10,
    String? job,
    String? period,
    String? location,
    String? education,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
      };

      if (job != null && job.isNotEmpty) queryParams['job'] = job;
      if (period != null && period.isNotEmpty) queryParams['period'] = period;
      if (location != null && location.isNotEmpty) queryParams['location'] = location;
      if (education != null && education.isNotEmpty) queryParams['education'] = education;

      final response = await _apiClient.get<List<dynamic>>(
        PostApiEndpoints.postsIntern,
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _logger.i('인턴 공고 조회 성공');

        // Map<String, dynamic> 타입으로 변환 후 fromJson 적용
        List<PostModel> posts = [];
        for (var item in response.data!) {
          if (item is Map<String, dynamic>) {
            posts.add(_createPostModelFromJson(item));
          }
        }

        return posts;
      } else {
        _logger.e('인턴 공고 조회 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('인턴 공고 조회 중 오류 발생: $e');
      return [];
    }
  }

  // API를 통한 대외활동 공고 조회 (페이징)
  Future<List<PostModel>> fetchExternalActivityPosts({
    int page = 1,
    int size = 10,
    String? field,
    String? organization,
    String? location,
    String? host,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
      };

      if (field != null && field.isNotEmpty) queryParams['field'] = field;
      if (organization != null && organization.isNotEmpty) queryParams['organization'] = organization;
      if (location != null && location.isNotEmpty) queryParams['location'] = location;
      if (host != null && host.isNotEmpty) queryParams['host'] = host;

      final response = await _apiClient.get<List<dynamic>>(
        PostApiEndpoints.postsExternal,
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _logger.i('대외활동 공고 조회 성공');

        // Map<String, dynamic> 타입으로 변환 후 fromJson 적용
        List<PostModel> posts = [];
        for (var item in response.data!) {
          if (item is Map<String, dynamic>) {
            posts.add(_createPostModelFromJson(item));
          }
        }

        return posts;
      } else {
        _logger.e('대외활동 공고 조회 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('대외활동 공고 조회 중 오류 발생: $e');
      return [];
    }
  }

  // API를 통한 교육/강연 공고 조회 (페이징)
  Future<List<PostModel>> fetchLecturePosts({
    int page = 1,
    int size = 10,
    String? field,
    String? period,
    String? location,
    String? onOffline,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
      };

      if (field != null && field.isNotEmpty) queryParams['field'] = field;
      if (period != null && period.isNotEmpty) queryParams['period'] = period;
      if (location != null && location.isNotEmpty) queryParams['location'] = location;
      if (onOffline != null && onOffline.isNotEmpty) queryParams['onOffline'] = onOffline;

      final response = await _apiClient.get<List<dynamic>>(
        PostApiEndpoints.postsLecture,
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _logger.i('교육/강연 공고 조회 성공');

        // Map<String, dynamic> 타입으로 변환 후 fromJson 적용
        List<PostModel> posts = [];
        for (var item in response.data!) {
          if (item is Map<String, dynamic>) {
            posts.add(_createPostModelFromJson(item));
          }
        }

        return posts;
      } else {
        _logger.e('교육/강연 공고 조회 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('교육/강연 공고 조회 중 오류 발생: $e');
      return [];
    }
  }

  // API를 통한 공모전 공고 조회 (페이징)
  Future<List<PostModel>> fetchContestPosts({
    int page = 1,
    int size = 10,
    String? field,
    String? target,
    String? organizer,
    String? benefit,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
      };

      if (field != null && field.isNotEmpty) queryParams['field'] = field;
      if (target != null && target.isNotEmpty) queryParams['target'] = target;
      if (organizer != null && organizer.isNotEmpty) queryParams['organizer'] = organizer;
      if (benefit != null && benefit.isNotEmpty) queryParams['benefit'] = benefit;

      final response = await _apiClient.get<List<dynamic>>(
        PostApiEndpoints.postsContest,
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _logger.i('공모전 공고 조회 성공');

        // Map<String, dynamic> 타입으로 변환 후 fromJson 적용
        List<PostModel> posts = [];
        for (var item in response.data!) {
          if (item is Map<String, dynamic>) {
            posts.add(_createPostModelFromJson(item));
          }
        }

        return posts;
      } else {
        _logger.e('공모전 공고 조회 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('공모전 공고 조회 중 오류 발생: $e');
      return [];
    }
  }

  // 검색어를 통한 게시물 검색
  Future<List<PostModel>> searchPosts(String query) async {
    try {
      final queryParams = {
        'query': query,
      };

      final response = await _apiClient.get<List<dynamic>>(
        PostApiEndpoints.postsAll,  // 검색 엔드포인트가 명확하지 않아 임시로 전체 엔드포인트 사용
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _logger.i('게시물 검색 성공: $query');

        // Map<String, dynamic> 타입으로 변환 후 fromJson 적용
        List<PostModel> posts = [];
        for (var item in response.data!) {
          if (item is Map<String, dynamic>) {
            posts.add(_createPostModelFromJson(item));
          }
        }

        return posts;
      } else {
        _logger.e('게시물 검색 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('게시물 검색 중 오류 발생: $e');
      return [];
    }
  }

  // JSON에서 PostModel 생성하는 헬퍼 메소드
  PostModel _createPostModelFromJson(Map<String, dynamic> json) {
    // nullable 필드에 대한 안전한 접근
    List<String>? requirements;
    if (json['requirements'] != null) {
      requirements = List<String>.from(json['requirements']);
    }

    List<String>? benefits;
    if (json['benefits'] != null) {
      benefits = List<String>.from(json['benefits']);
    }

    List<Attachment>? attachments;
    if (json['attachments'] != null) {
      attachments = (json['attachments'] as List)
          .map((item) => Attachment(
              fileName: item['fileName'] as String,
              url: item['url'] as String,
            ))
          .toList();
    }

    // 날짜 관련 필드 처리
    DateTime? createdAt;
    if (json['created_at'] != null) {
      try {
        createdAt = DateTime.parse(json['created_at'] as String);
      } catch (_) {}
    }

    DateTime? updatedAt;
    if (json['updated_at'] != null) {
      try {
        updatedAt = DateTime.parse(json['updated_at'] as String);
      } catch (_) {}
    }

    // 애플리케이션 기간 처리
    ApplicationPeriod? applicationPeriod;
    String? startDate;
    String? endDate;

    if (json['applicationPeriod'] != null) {
      final appPeriod = json['applicationPeriod'] as Map<String, dynamic>;

      startDate = appPeriod['start_date'] as String?;
      endDate = appPeriod['end_date'] as String?;

      if (startDate != null && endDate != null) {
        try {
          applicationPeriod = ApplicationPeriod(
            startDate: DateTime.parse(startDate),
            endDate: DateTime.parse(endDate),
          );
        } catch (_) {}
      }
    }

    return PostModel(
      post_id: json['post_id'] as int?,
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? '',
      employmentType: json['employment_type'] as String?,
      description: json['description'] as String? ?? '',
      requirements: requirements,
      benefits: benefits,
      attachments: attachments,
      createdAt: createdAt,
      updatedAt: updatedAt,
      applicationPeriod: applicationPeriod,
      jobTitle: json['jobTitle'] as String?,
      experience: json['experience'] as int?,
      education: json['education'] as String?,
      activityField: json['activityField'] as String?,
      activityDuration: json['activityDuration'] as int?,
      hostingOrganization: json['hostingOrganization'] as String?,
      onlineOrOffline: json['onlineOrOffline'] as String?,
      targetAudience: json['targetAudience'] as String?,
      contestBenefits: json['contestBenefits'] as String?,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
