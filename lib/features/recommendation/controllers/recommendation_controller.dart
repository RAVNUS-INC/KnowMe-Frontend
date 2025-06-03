import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/models/postsPostid_model.dart';
import 'package:knowme_frontend/features/recommendation/repositories/recommendation_repository.dart';
import 'package:logger/logger.dart';

class RecommendationController extends GetxController with GetSingleTickerProviderStateMixin {
  final RecommendationRepository repository;
  final _logger = Logger();
  
  // 탭 컨트롤러
  late TabController tabController;
  
  // 탭 제목 추가
  final List<String> tabTitles = ['추천 활동', '저장한 활동'];
  
  // 생성자 주입
  RecommendationController({RecommendationRepository? repository}) 
      : repository = repository ?? RecommendationRepository();

  // 상태 변수
  final RxBool _isLoading = false.obs;
  final RxList<PostModel> _savedPosts = <PostModel>[].obs;
  final RxList<PostModel> _recommendedPosts = <PostModel>[].obs;

  // 게터
  bool get isLoading => _isLoading.value;
  List<PostModel> get savedPosts => _savedPosts;
  List<PostModel> get recommendedPosts => _recommendedPosts;

  @override
  void onInit() {
    super.onInit();
    // 탭 컨트롤러 초기화
    tabController = TabController(length: tabTitles.length, vsync: this);
    loadData();
  }
  
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // 데이터 로드
  Future<void> loadData() async {
    _isLoading.value = true;
    update();
    
    try {
      final saved = await repository.getSavedPosts();
      final recommended = await repository.getRecommendedPosts();
      
      _savedPosts.assignAll(saved);
      _recommendedPosts.assignAll(recommended);
    } catch (e) {
      _logger.e('Error loading data: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // 새로고침
  Future<void> refreshData() async {
    return loadData();
  }

  // 북마크 토글
  void toggleBookmark(PostModel post) {
    if (post.post_id == null) return;
    
    try {
      // 북마크 상태 토글
      final updatedPost = post.copyWith(isSaved: !post.isSaved);
      
      // 로컬 상태 업데이트
      final index = _savedPosts.indexWhere((p) => p.post_id == post.post_id);
      if (index >= 0) {
        if (!updatedPost.isSaved) {
          // 북마크 해제된 경우 리스트에서 제거
          _savedPosts.removeAt(index);
        } else {
          // 북마크된 경우 업데이트
          _savedPosts[index] = updatedPost;
        }
      } else if (updatedPost.isSaved) {
        // 새로 북마크된 경우 리스트에 추가
        _savedPosts.add(updatedPost);
      }
      
      // 추천 목록에서도 북마크 상태 업데이트
      final recIndex = _recommendedPosts.indexWhere((p) => p.post_id == post.post_id);
      if (recIndex >= 0) {
        _recommendedPosts[recIndex] = updatedPost;
      }
      
      // 서버에 변경사항 반영 (비동기 호출)
      repository.togglePostBookmark(post.post_id!, updatedPost.isSaved);
      
      update();
    } catch (e) {
      _logger.e('Error toggling bookmark: $e');
    }
  }
}
