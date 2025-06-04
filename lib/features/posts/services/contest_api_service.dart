import '../../../shared/services/api_client.dart';
import '../models/post_tabs/contest_post_dtos.dart';
import 'package:logger/logger.dart';

/// 공모전 공고 API 서비스
class ContestApiService {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();

  /// 공모전 공고 목록 조회
  ///
  /// [activityField]: 분야 (선택사항)
  /// [targetAudience]: 대상 (선택사항)
  /// [hostingOrganization]: 주최기관 (선택사항)
  /// [contestBenefits]: 혜택 (선택사항)
  Future<ApiResponse<List<ContestPost>>> getContestPosts({
    String? activityField,
    String? targetAudience,
    String? hostingOrganization,
    String? contestBenefits,
  }) async {
    try {
      // 쿼리 파라미터 구성
      Map<String, String> queryParams = {};

      if (activityField != null && activityField.isNotEmpty) {
        queryParams['activityField'] = activityField;
      }

      if (targetAudience != null && targetAudience.isNotEmpty) {
        queryParams['targetAudience'] = targetAudience;
      }

      if (hostingOrganization != null && hostingOrganization.isNotEmpty) {
        queryParams['hostingOrganization'] = hostingOrganization;
      }

      if (contestBenefits != null && contestBenefits.isNotEmpty) {
        queryParams['contestBenefits'] = contestBenefits;
      }

      _logger.d('공모전 공고 API 호출 - 쿼리 파라미터: $queryParams');

      // API 호출
      final response = await _apiClient.get<List<dynamic>>(
        '/api/posts/contest',
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        try {
          // JSON 데이터를 ContestPost 리스트로 변환
          final List<ContestPost> posts = (response.data as List)
              .map((json) => ContestPost.fromJson(json as Map<String, dynamic>))
              .toList();

          _logger.d('공모전 공고 조회 성공: ${posts.length}개');

          return ApiResponse.success(posts);
        } catch (e) {
          _logger.e('공모전 공고 데이터 파싱 오류: $e');
          return ApiResponse.error(
            message: '데이터 처리 중 오류가 발생했습니다.',
            statusCode: 500,
          );
        }
      } else {
        _logger.e('공모전 공고 API 호출 실패: ${response.message}');
        return ApiResponse.error(
          message: response.message ?? '공모전 공고를 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('공모전 공고 API 호출 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }

  /// 특정 공모전 공고 상세 조회
  Future<ApiResponse<ContestPost>> getContestPostDetail(int postId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/posts/contest/$postId',
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final post = ContestPost.fromJson(response.data!);
        return ApiResponse.success(post);
      } else {
        return ApiResponse.error(
          message: response.message ?? '공모전 공고 상세 정보를 불러올 수 없습니다.',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      _logger.e('공모전 공고 상세 조회 예외: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다.',
        statusCode: 0,
      );
    }
  }
}
