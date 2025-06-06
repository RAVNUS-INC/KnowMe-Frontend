import '../../../shared/services/api_client.dart';
import '../models/get_saved_posts_dtos.dart';
import 'package:logger/logger.dart';

/// 저장된 활동 API 서비스
class GetSavedPostsApiService {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();

  // 먼저 사용자 정보를 가져온 후 저장한 활동을 조회
  Future<ApiResponse<List<SavedPostResponse>>> getUserSavedPosts({int? userId}) async {
    try {
      // 1. 사용자 정보 API 호출을 통해 userId 가져오기
      if (userId == null) {
        final userResponse = await _apiClient.get<Map<String, dynamic>>(
          '/api/user/me',
          requireAuth: true,
        );

        if (!userResponse.isSuccess || userResponse.data == null) {
          _logger.e('사용자 정보를 가져올 수 없습니다: ${userResponse.message}');
          return ApiResponse.error(
            message: '사용자 정보를 가져올 수 없습니다.',
            statusCode: userResponse.statusCode ?? 401,
          );
        }

        // 사용자 ID 추출
        userId = userResponse.data!['id'] as int;
        _logger.d('사용자 ID 조회 성공: $userId');
      }

      // 2. 사용자의 저장된 활동 조회
      final endpoint = '/api/savedpost/user/$userId';
      _logger.d('저장된 활동 API 호출: $endpoint');

      final response = await _apiClient.get<dynamic>(
        endpoint,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        try {
          List<SavedPostResponse> savedPosts = [];
          
          // 응답이 리스트인지 객체인지 확인하고 적절히 처리
          if (response.data is List) {
            // 리스트 형태로 온 경우
            savedPosts = (response.data as List)
                .map((json) => SavedPostResponse.fromJson(json as Map<String, dynamic>))
                .toList();
          } else if (response.data is Map<String, dynamic>) {
            // 단일 객체로 온 경우 (리스트로 변환)
            savedPosts = [SavedPostResponse.fromJson(response.data as Map<String, dynamic>)];
          }

          _logger.d('저장된 활동 조회 성공: ${savedPosts.length}개');
          return ApiResponse.success(savedPosts);
        } catch (e) {
          _logger.e('저장된 활동 데이터 파싱 오류: $e');
          return ApiResponse.error(
            message: '데이터 처리 중 오류가 발생했습니다.',
            statusCode: 500,
          );
        }
      } else {
        _logger.e('저장된 활동 API 호출 실패: ${response.message}');
        return ApiResponse.error(
          message: response.message ?? '저장된 활동을 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('저장된 활동 API 호출 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }

  /// 특정 저장된 활동 상세 조회
  Future<ApiResponse<SavedPostResponse>> getSavedPostDetail(int savedPostId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/savedpost/$savedPostId',
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final savedPost = SavedPostResponse.fromJson(response.data!);
        return ApiResponse.success(savedPost);
      } else {
        return ApiResponse.error(
          message: response.message ?? '저장된 활동 상세 정보를 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('저장된 활동 상세 조회 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }
}
