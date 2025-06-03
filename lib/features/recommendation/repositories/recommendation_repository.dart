import 'package:knowme_frontend/core/constants/post_api_constants.dart';
import 'package:knowme_frontend/features/posts/models/postsPostid_model.dart';
import 'package:knowme_frontend/shared/services/api_client.dart';
import 'package:logger/logger.dart';

/// 추천 및 저장된 게시물 관련 Repository
class RecommendationRepository {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();

  /// 사용자가 저장한 게시물 목록 조회
  Future<List<PostModel>> getSavedPosts() async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        PostApiEndpoints.savedPosts,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _logger.i('저장된 게시물 조회 성공');
        
        // Map<String, dynamic> 타입으로 변환 후 PostModel 생성
        List<PostModel> posts = [];
        for (var item in response.data!) {
          if (item is Map<String, dynamic>) {
            posts.add(_createPostModelFromJson(item));
          }
        }
        
        return posts;
      } else {
        _logger.e('저장된 게시물 조회 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('저장된 게시물 조회 중 오류 발생: $e');
      return [];
    }
  }

  /// 사용자를 위한 추천 게시물 목록 조회
  Future<List<PostModel>> getRecommendedPosts() async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        PostApiEndpoints.recommendedPosts,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _logger.i('추천 게시물 조회 성공');
        
        // Map<String, dynamic> 타입으로 변환 후 PostModel 생성
        List<PostModel> posts = [];
        for (var item in response.data!) {
          if (item is Map<String, dynamic>) {
            posts.add(_createPostModelFromJson(item));
          }
        }
        
        return posts;
      } else {
        _logger.e('추천 게시물 조회 실패: ${response.message}');
        return [];
      }
    } catch (e) {
      _logger.e('추천 게시물 조회 중 오류 발생: $e');
      return [];
    }
  }

  /// 게시물 북마크 토글
  Future<bool> togglePostBookmark(int postId, bool isBookmarked) async {
    try {
      final endpoint = isBookmarked
          ? PostApiEndpoints.savedPostSave
              .replaceFirst('{user_id}', '1') // 임시로 userId 1로 설정
              .replaceFirst('{post_id}', postId.toString())
          : PostApiEndpoints.savedPostDelete
              .replaceFirst('{savedpost_id}', '1_$postId'); // 임시로 userId 1로 설정

      final response = isBookmarked
          ? await _apiClient.post(endpoint, requireAuth: true)
          : await _apiClient.delete(endpoint, requireAuth: true);

      if (response.isSuccess) {
        _logger.i('북마크 ${isBookmarked ? '추가' : '제거'} 성공: postId=$postId');
        return true;
      } else {
        _logger.e('북마크 토글 실패: ${response.message}');
        return false;
      }
    } catch (e) {
      _logger.e('북마크 토글 중 오류 발생: $e');
      return false;
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
      isSaved: true, // 저장된 게시물이므로 true로 설정
    );
  }
}
