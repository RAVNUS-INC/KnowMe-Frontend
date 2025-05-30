import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/posts/models/contest_model.dart';
import '../services/recommendation_service.dart';
import '../repositories/recommendation_repositories.dart';

class RecommendationController extends GetxController with GetSingleTickerProviderStateMixin {
  final RecommendationService _service = RecommendationService();
  final RecommendationRepository _repository = RecommendationRepository();

  List<ContestGroup> recommendedContests = [];
  List<Contest> savedContests = [];
  bool isLoading = false;

  // 탭 관련 변수
  late TabController tabController;
  List<String> tabTitles = ['추천 활동', '저장한 활동'];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchRecommendedContests();
    fetchSavedContests();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    tabController.animateTo(index);
    update();
  }

  Future<void> fetchRecommendedContests() async {
    isLoading = true;
    update();

    try {
      recommendedContests = await _service.getRecommendedContests();
    } catch (e) {
      print('Error fetching recommended contests: $e');
      // 오류 처리 (예: 스낵바 표시)
    } finally {
      isLoading = false;
      update();
    }
  }
  
  Future<void> fetchSavedContests() async {
    try {
      savedContests = await _service.getSavedContests();
      update();
    } catch (e) {
      print('Error fetching saved contests: $e');
      // 오류 처리
    }
  }
  
  Future<void> toggleBookmark(Contest contest) async {
    try {
      final result = await _service.toggleBookmark(contest.id);
      if (result) {
        // 북마크 상태 토글
        contest.isBookmarked = !contest.isBookmarked;
        
        // 저장된 활동 목록 업데이트
        if (contest.isBookmarked) {
          if (!savedContests.any((a) => a.id == contest.id)) {
            savedContests.add(contest);
          }
        } else {
          savedContests.removeWhere((a) => a.id == contest.id);
        }
        
        update();
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
      // 오류 처리
    }
  }
  
  Future<void> refreshData() async {
    await Future.wait([
      fetchRecommendedContests(),
      fetchSavedContests(),
    ]);
  }
}
