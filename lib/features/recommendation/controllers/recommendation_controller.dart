import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/posts/models/contests_model.dart';
import '../services/recommendation_service.dart';
import '../services/saved_service.dart';
import 'package:flutter/foundation.dart';

class RecommendationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final RecommendationService _recommendationService = RecommendationService();
  final SavedService _savedService = SavedService();


  List<ContestGroup> recommendedContests = [];
  List<Contest> savedContests = [];
  bool isLoading = false;
  bool isLoadingSaved = false; // 저장된 활동 로딩 상태 추가
  String errorMessage = ''; // 에러 메시지 추가

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
    // 저장한 활동 탭으로 이동할 때 데이터 새로고침
    if (index == 1) {
      fetchSavedContests();
    }
    update();
  }

  Future<void> fetchRecommendedContests() async {
    isLoading = true;
    update();

    try {
      recommendedContests = await _recommendationService.getRecommendedContests();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching recommended contests: $e');
      }
      // Get.snackbar를 사용하여 사용자에게 오류 알림
      Get.snackbar(
        '데이터 로드 오류',
        '추천 활동을 불러오는 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchSavedContests() async {
    isLoadingSaved = true;
    errorMessage = '';
    update();

    try {
      // 1) 서버에서 “내가 저장해 둔(북마크된)” Contest 리스트를 가져온다
      savedContests = await _savedService.getSavedContests();

      // 2) 이 리스트에 담긴 모든 Contest 객체는 “이미 북마크된 상태”이므로
      //    isBookmarked 를 true 로 설정해 준다
      for (var c in savedContests) {
        c.isBookmarked = true;
      }

      // 3) 저장된 활동이 없는 경우 메시지 설정
      if (savedContests.isEmpty) {
        errorMessage = '저장한 활동이 없습니다.';
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching saved contests: $e');
      }
      errorMessage = '저장한 활동을 불러오는 중 오류가 발생했습니다.';
      Get.snackbar(
        '데이터 로드 오류',
        '저장한 활동을 불러오는 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoadingSaved = false;
      update();
    }
  }

  Future<void> toggleBookmark(Contest contest) async {
    try {
      final result = await _recommendationService.toggleBookmark(contest.id);
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
      if (kDebugMode) {
        debugPrint('Error toggling bookmark: $e');
      }
      // 북마크 오류 알림
      Get.snackbar(
        '북마크 오류',
        '북마크 상태를 변경하는 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      fetchRecommendedContests(),
      fetchSavedContests(),
    ]);
  }
}
