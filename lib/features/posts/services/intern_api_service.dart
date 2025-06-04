import '../../../shared/services/api_client.dart';
import '../models/intern_post_dtos.dart';
import 'package:logger/logger.dart';

/// 인턴 공고 API 서비스
class InternApiService {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();

  /// 인턴 공고 목록 조회
  ///
  /// [jobTitle]: 직무명 (선택사항)
  /// [period]: 기간
  /// [location]: 지역 (선택사항)
  /// [education]: 학력 (선택사항)
  Future<ApiResponse<List<InternPost>>> getInternPosts({
    String? jobTitle,
    String? period,
    String? education,
    String? location,
  }) async {
    try {
      // 쿼리 파라미터 구성
      Map<String, String> queryParams = {};

      if (jobTitle != null && jobTitle.isNotEmpty) {
        queryParams['jobTitle'] = jobTitle;
      }

      if (period != null && period.isNotEmpty) {
        queryParams['period'] = period;
      }

      if (location != null && location.isNotEmpty) {
        queryParams['location'] = location;
      }

      if (education != null && education.isNotEmpty) {
        queryParams['education'] = education;
      }

      _logger.d('인턴 공고 API 호출 - 쿼리 파라미터: $queryParams');

      // API 호출
      final response = await _apiClient.get<List<dynamic>>(
        '/api/posts/intern',
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        try {
          // JSON 데이터를 InternPost 리스트로 변환
          final List<InternPost> posts = (response.data as List)
              .map((json) => InternPost.fromJson(json as Map<String, dynamic>))
              .toList();

          _logger.d('인턴 공고 조회 성공: ${posts.length}개');

          return ApiResponse.success(posts);
        } catch (e) {
          _logger.e('인턴 공고 데이터 파싱 오류: $e');
          return ApiResponse.error(
            message: '데이터 처리 중 오류가 발생했습니다.',
            statusCode: 500,
          );
        }
      } else {
        _logger.e('인턴 공고 API 호출 실패: ${response.message}');
        return ApiResponse.error(
          message: response.message ?? '인턴 공고를 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('인턴 공고 API 호출 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }

  /// 특정 인턴 공고 상세 조회 (향후 확장용)
  Future<ApiResponse<InternPost>> getInternPostDetail(int postId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/posts/intern/$postId',
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final post = InternPost.fromJson(response.data!);
        return ApiResponse.success(post);
      } else {
        return ApiResponse.error(
          message: response.message ?? '인턴 공고 상세 정보를 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('인턴 공고 상세 조회 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }
}
