import '../../../shared/services/api_client.dart';
import '../models/employee_post_dtos.dart';
import 'package:logger/logger.dart';

/// 채용 공고 API 서비스
class EmployeeApiService {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();

  /// 채용 공고 목록 조회
  ///
  /// [jobTitle]: 직무명 (선택사항)
  /// [experience]: 경력 년수 (선택사항)
  /// [education]: 학력 (선택사항)
  /// [location]: 지역 (선택사항)
  Future<ApiResponse<List<EmployeePost>>> getEmployeePosts({
    String? jobTitle,
    int? experience,
    String? education,
    String? location,
  }) async {
    try {
      // 쿼리 파라미터 구성
      Map<String, String> queryParams = {};

      if (jobTitle != null && jobTitle.isNotEmpty) {
        queryParams['jobTitle'] = jobTitle;
      }

      if (experience != null) {
        queryParams['experience'] = experience.toString();
      }

      if (education != null && education.isNotEmpty) {
        queryParams['education'] = education;
      }

      if (location != null && location.isNotEmpty) {
        queryParams['location'] = location;
      }

      _logger.d('채용 공고 API 호출 - 쿼리 파라미터: $queryParams');

      // API 호출
      final response = await _apiClient.get<List<dynamic>>(
        '/api/posts/employee',
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        try {
          // JSON 데이터를 EmployeePost 리스트로 변환
          final List<EmployeePost> posts = (response.data as List)
              .map((json) => EmployeePost.fromJson(json as Map<String, dynamic>))
              .toList();

          _logger.d('채용 공고 조회 성공: ${posts.length}개');

          return ApiResponse.success(posts);
        } catch (e) {
          _logger.e('채용 공고 데이터 파싱 오류: $e');
          return ApiResponse.error(
            message: '데이터 처리 중 오류가 발생했습니다.',
            statusCode: 500,
          );
        }
      } else {
        _logger.e('채용 공고 API 호출 실패: ${response.message}');
        return ApiResponse.error(
          message: response.message ?? '채용 공고를 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('채용 공고 API 호출 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }

  /// 특정 채용 공고 상세 조회 (향후 확장용)
  Future<ApiResponse<EmployeePost>> getEmployeePostDetail(int postId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/posts/employee/$postId',
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final post = EmployeePost.fromJson(response.data!);
        return ApiResponse.success(post);
      } else {
        return ApiResponse.error(
          message: response.message ?? '채용 공고 상세 정보를 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('채용 공고 상세 조회 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }
}