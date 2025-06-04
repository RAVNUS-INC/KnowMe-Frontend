import '../../../shared/services/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/post_detail_dtos.dart';
import 'package:logger/logger.dart';

/// 공고 상세 정보 API 서비스
class PostDetailApiService {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();

  /// 공고 상세 정보 조회
  ///
  /// [postId]: 공고 ID
  Future<ApiResponse<PostDetailDto>> getPostDetail(int postId) async {
    try {
      _logger.d('공고 상세 API 호출 - postId: $postId');

      // API 호출
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.getPostDetailUrl(postId),
        requireAuth: true,
        fromJson: (json) => json, // Map<String, dynamic>를 그대로 반환
      );

      if (response.isSuccess && response.data != null) {
        try {
          // JSON 데이터를 PostDetailDto로 변환
          final postDetail = PostDetailDto.fromJson(response.data!);

          _logger.d('공고 상세 조회 성공: ${postDetail.title}');

          return ApiResponse.success(postDetail);
        } catch (e) {
          _logger.e('공고 상세 데이터 파싱 오류: $e');
          return ApiResponse.error(
            message: '데이터 처리 중 오류가 발생했습니다.',
            statusCode: 500,
          );
        }
      } else {
        _logger.e('공고 상세 API 호출 실패: ${response.message}');
        return ApiResponse.error(
          message: response.message ?? '공고 상세 정보를 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('공고 상세 API 호출 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }
}