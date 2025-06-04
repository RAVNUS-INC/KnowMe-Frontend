import '../../../shared/services/api_client.dart';
import '../models/education_post_dtos.dart';
import 'package:logger/logger.dart';

/// 교육/강연 공고 API 서비스
class EducationApiService {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();

  /// 교육/강연 공고 목록 조회
  ///
  /// [activityField]: 분야 (선택사항)
  /// [activityDuration]: 기간 (선택사항)
  /// [location]: 지역 (선택사항)
  /// [onlineOrOffline]: 온/오프라인 (선택사항)
  Future<ApiResponse<List<EducationPost>>> getEducationPosts({
    String? activityField,
    int? activityDuration,
    String? location,
    String? onlineOrOffline,
  }) async {
    try {
      // 쿼리 파라미터 구성
      Map<String, String> queryParams = {};

      if (activityField != null && activityField.isNotEmpty) {
        queryParams['activityField'] = activityField;
      }

      if (activityDuration != null) {
        queryParams['activityDuration'] = activityDuration.toString();
      }

      if (location != null && location.isNotEmpty) {
        queryParams['location'] = location;
      }

      if (onlineOrOffline != null && onlineOrOffline.isNotEmpty) {
        queryParams['onlineOrOffline'] = onlineOrOffline;
      }

      _logger.d('교육/강연 공고 API 호출 - 쿼리 파라미터: $queryParams');

      // API 호출
      final response = await _apiClient.get<List<dynamic>>(
        '/api/posts/lecture',
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        try {
          // JSON 데이터를 EducationPost 리스트로 변환
          final List<EducationPost> posts = (response.data as List)
              .map((json) => EducationPost.fromJson(json as Map<String, dynamic>))
              .toList();

          _logger.d('교육/강연 공고 조회 성공: ${posts.length}개');

          return ApiResponse.success(posts);
        } catch (e) {
          _logger.e('교육/강연 공고 데이터 파싱 오류: $e');
          return ApiResponse.error(
            message: '데이터 처리 중 오류가 발생했습니다.',
            statusCode: 500,
          );
        }
      } else {
        _logger.e('교육/강연 공고 API 호출 실패: ${response.message}');
        return ApiResponse.error(
          message: response.message ?? '교육/강연 공고를 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('교육/강연 공고 API 호출 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }

  /// 특정 교육/강연 공고 상세 조회 (향후 확장용)
  Future<ApiResponse<EducationPost>> getEducationPostDetail(int postId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/posts/lecture/$postId',
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final post = EducationPost.fromJson(response.data!);
        return ApiResponse.success(post);
      } else {
        return ApiResponse.error(
          message: response.message ?? '교육/강연 공고 상세 정보를 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('교육/강연 공고 상세 조회 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }
}
