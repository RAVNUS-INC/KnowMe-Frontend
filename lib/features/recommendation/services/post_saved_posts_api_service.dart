import '../../../shared/services/api_client.dart';
import '../models/post_saved_posts_dtos.dart';
import 'package:logger/logger.dart';

/// 활동 저장 API 서비스
class PostSavedPostsApiService {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();

  /// 활동 저장 요청
  Future<ApiResponse<SavedPostDTO>> savePost(SavePostRequest request) async {
    try {
      _logger.d('📌 활동 저장 POST 요청 시작: ${request.toString()}');

      // API 엔드포인트 수정:
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/savedpost/${request.userId}/${request.postId}',
        body: request.toJson(),
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        try {
          final savedPostDTO = SavedPostDTO.fromJson(response.data!);
          _logger.d('✅ 활동 저장 성공: ID ${savedPostDTO.id}, 포스트 ID: ${savedPostDTO.post.postId}');
          return ApiResponse.success(savedPostDTO);
        } catch (e) {
          _logger.e('❌ 활동 저장 응답 파싱 오류: $e');
          return ApiResponse.error(
            message: '데이터 처리 중 오류가 발생했습니다.',
            statusCode: 500,
          );
        }
      } else {
        _logger.e('❌ 활동 저장 API 호출 실패: ${response.message}, 상태 코드: ${response.statusCode}');
        return ApiResponse.error(
          message: response.message ?? '활동을 저장하지 못했습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('❌ 활동 저장 API 호출 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }

  /// 활동 저장 취소(삭제) 요청
  Future<ApiResponse<bool>> unsavePost(int savedPostId) async {
    try {
      _logger.d('📌 활동 저장 취소 DELETE 요청 시작: ID $savedPostId');

      // API 엔드포인트 수정:
      final response = await _apiClient.delete(
        '/api/savedpost/$savedPostId',
        requireAuth: true,
      );

      if (response.isSuccess) {
        _logger.d('✅ 활동 저장 취소 성공: ID $savedPostId');
        return ApiResponse.success(true);
      } else {
        _logger.e('❌ 활동 저장 취소 API 호출 실패: ${response.message}, 상태 코드: ${response.statusCode}');
        return ApiResponse.error(
          message: response.message ?? '활동 저장을 취소하지 못했습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('❌ 활동 저장 취소 API 호출 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }
}
