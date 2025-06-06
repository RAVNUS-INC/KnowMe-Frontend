import '../../../shared/services/api_client.dart';
import '../models/post_saved_posts_dtos.dart';
import 'package:logger/logger.dart';

/// 활동 저장 API 서비스
class PostSavedPostsApiService {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();

  /// 활동 저장 요청
  Future<ApiResponse<SavePostResponse>> savePost(SavePostRequest request) async {
    try {
      _logger.d('📌 활동 저장 POST 요청 시작: ${request.toString()}');
      
      // 현재 사용자 ID 가져오기 (/api/user/me API 사용)
      final userResponse = await _apiClient.get<Map<String, dynamic>>(
        '/api/user/me',
        requireAuth: true,
      );

      if (!userResponse.isSuccess || userResponse.data == null) {
        _logger.e('❌ 활동 저장 실패: 사용자 정보를 가져올 수 없습니다. ${userResponse.message}');
        return ApiResponse.error(
          message: '사용자 인증 정보를 찾을 수 없습니다.',
          statusCode: userResponse.statusCode ?? 401,
        );
      }

      // 사용자 ID 추출
      final userId = userResponse.data!['id'] as int;
      _logger.d('📌 현재 사용자 ID: $userId');

      // 동적 URL 생성 - 실제 값으로 대체
      final url = '/api/savedpost/$userId/${request.postId}';
      
      _logger.d('📌 활동 저장 URL: $url');
      
      final response = await _apiClient.post<Map<String, dynamic>>(
        url,
        body: request.toJson(),
        requireAuth: true,
      );

      // 201 Created 상태 코드도 성공으로 처리
      if ((response.isSuccess || response.statusCode == 201) && response.data != null) {
        try {
          final savedPostDTO = SavePostResponse.fromJson(response.data!);
          _logger.d('✅ 활동 저장 성공: ID ${savedPostDTO.id}, 포스트 ID: ${savedPostDTO.post.postId}');
          return ApiResponse.success(savedPostDTO);
        } catch (e) {
          _logger.e('❌ 활동 저장 응답 파싱 오류: $e');
          
          // 파싱 오류가 발생했지만 응답은 성공했을 경우, 간단한 응답 객체 생성
          if (response.statusCode == 201) {
            _logger.d('✅ 생성 성공했으나 파싱 실패, 간단한 응답 객체 생성');
            // response.data에서 필요한 정보 직접 추출 시도
            int savedId = 0;
            try {
              savedId = response.data!['id'] as int? ?? 0;
            } catch (_) {}
            
            // 이제 empty() 팩토리 메서드 사용 가능
           //  final emptyPostDetail = PostDto.empty();
            
            return ApiResponse.success(
              SavePostResponse(
                id: savedId,
                userId: userId,  // userResponse에서 얻은 userId 사용
                post: PostDto(
                  postId: request.postId,
                ),
              ),
            );
          }
          
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

      final response = await _apiClient.delete(
        '/api/savedpost/$savedPostId',
        requireAuth: true,
      );

      // 나머지 코드는 동일하게 유지
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
