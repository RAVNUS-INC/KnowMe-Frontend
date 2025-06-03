import 'dart:async';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:knowme_frontend/core/constants/post_api_constants.dart';
import 'package:knowme_frontend/features/posts/models/postsPostid_dtos.dart';
import 'package:knowme_frontend/features/posts/models/postsPostid_model.dart';
import 'package:knowme_frontend/shared/services/api_client.dart';

/// 게시물 세부정보 컨트롤러
class PostDetailController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final Logger _logger = Logger();
  
  // 상태
  Rx<PostModel?> _post = Rx<PostModel?>(null);
  RxBool _isLoading = false.obs;
  RxBool _hasError = false.obs;
  RxString _errorMessage = ''.obs;
  
  // 폴링 관련
  Timer? _pollingTimer;
  static const Duration _pollingDuration = Duration(seconds: 30);
  
  // 게터
  PostModel? get post => _post.value;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  
  // 폴링 시작
  void startPolling(int postId) {
    _logger.i('게시물 폴링 시작: postId=$postId');
    
    // 기존 타이머가 있으면 취소
    _pollingTimer?.cancel();
    
    // 즉시 첫 데이터 로드
    fetchPostDetail(postId);
    
    // 폴링 타이머 설정
    _pollingTimer = Timer.periodic(_pollingDuration, (_) {
      fetchPostDetail(postId);
    });
  }
  
  // 폴링 중지
  void stopPolling() {
    _logger.i('게시물 폴링 중지');
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }
  
  // 디스포즈 시 타이머 정리
  @override
  void onClose() {
    stopPolling();
    super.onClose();
  }

  // 게시물 상세 조회
  Future<void> fetchPostDetail(int postId) async {
    // 유효하지 않은 ID 체크
    if (postId <= 0) {
      _hasError.value = true;
      _errorMessage.value = '유효하지 않은 게시물 ID입니다';
      return;
    }
    
    try {
      _isLoading.value = true;
      _hasError.value = false;
      
      final endpoint = PostApiEndpoints.postsPostid.replaceFirst('{postid}', postId.toString());
      final response = await _apiClient.get<Map<String, dynamic>>(
        endpoint,
        requireAuth: true, // 인증 필요
      );
      
      if (response.isSuccess && response.data != null) {
        final dto = PostResponseDto.fromJson(response.data!);
        _post.value = PostModel.fromDto(dto);
        _logger.i('게시물 상세 조회 성공: ${_post.value?.title}');
      } else {
        _hasError.value = true;
        _errorMessage.value = response.message ?? '게시물을 불러오는데 실패했습니다';
        _logger.e('게시물 상세 조회 실패: $_errorMessage');
      }
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = '게시물 조회 중 오류가 발생했습니다: $e';
      _logger.e(_errorMessage.value);
    } finally {
      _isLoading.value = false;
    }
  }
  
  // 게시물 생성
  Future<bool> createPost(PostModel post) async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      
      final requestDto = post.toRequestDto();
      final response = await _apiClient.post<Map<String, dynamic>>(
        PostApiEndpoints.postsPostid.replaceFirst('/{postid}', ''),
        body: requestDto.toJson(),
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        _logger.i('게시물 생성 성공');
        return true;
      } else {
        _hasError.value = true;
        _errorMessage.value = response.message ?? '게시물 생성에 실패했습니다';
        _logger.e('게시물 생성 실패: ${_errorMessage.value}');
        return false;
      }
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = '게시��� 생성 중 오류가 발생했습니다: $e';
      _logger.e(_errorMessage.value);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  // 게시물 수정
  Future<bool> updatePost(int postId, PostModel post) async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      
      final requestDto = post.toRequestDto();
      final endpoint = PostApiEndpoints.postsPostid.replaceFirst('{postid}', postId.toString());
      final response = await _apiClient.put<Map<String, dynamic>>(
        endpoint,
        body: requestDto.toJson(),
        requireAuth: true,
      );
      
      if (response.isSuccess) {
        _logger.i('게시물 수정 성공');
        return true;
      } else {
        _hasError.value = true;
        _errorMessage.value = response.message ?? '게시물 수정에 실패했습니다';
        _logger.e('게시물 수정 실패: ${_errorMessage.value}');
        return false;
      }
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = '게시물 수정 중 오류가 발생했습니다: $e';
      _logger.e(_errorMessage.value);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  // 게시물 삭제
  Future<bool> deletePost(int postId) async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      
      final endpoint = PostApiEndpoints.postsPostid.replaceFirst('{postid}', postId.toString());
      final response = await _apiClient.delete(endpoint, requireAuth: true);
      
      if (response.isSuccess) {
        _logger.i('게시물 삭제 성공');
        return true;
      } else {
        _hasError.value = true;
        _errorMessage.value = response.message ?? '게시물 삭제에 실패했습니다';
        _logger.e('게시물 삭제 실패: ${_errorMessage.value}');
        return false;
      }
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = '게시물 삭제 중 오류가 발생했습니다: $e';
      _logger.e(_errorMessage.value);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  // 북마크 토글 - 저장/취소
  Future<bool> toggleBookmark(int postId, int userId) async {
    try {
      _isLoading.value = true;
      
      if (_post.value == null) {
        _logger.e('북마크 토글 실패: post가 null입니다');
        return false;
      }
      
      final currentPost = _post.value!;
      final endpoint = currentPost.isSaved 
          ? PostApiEndpoints.savedPostDelete.replaceFirst('{savedpost_id}', '${userId}_$postId')
          : PostApiEndpoints.savedPostSave
              .replaceFirst('{user_id}', userId.toString())
              .replaceFirst('{post_id}', postId.toString());
      
      final response = currentPost.isSaved
          ? await _apiClient.delete(endpoint, requireAuth: true)
          : await _apiClient.post(endpoint, requireAuth: true);
      
      if (response.isSuccess) {
        _post.value = currentPost.copyWith(isSaved: !currentPost.isSaved);
        _logger.i('북마크 ${_post.value!.isSaved ? '추가' : '제거'} 성공');
        return true;
      } else {
        _logger.e('북마크 토글 실패: ${response.message}');
        return false;
      }
    } catch (e) {
      _logger.e('북마크 토글 중 오류: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  // 에러 상태 초���화
  void clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }
}
