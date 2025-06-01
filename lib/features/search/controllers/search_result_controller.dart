import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/contest_model.dart';

class SearchResultController extends GetxController {
  // 🔍 검색어
  final RxString keyword = ''.obs;

  // 📦 전체 공모전 리스트
  final RxList<Contest> allContests = <Contest>[].obs;

  // 🔎 검색된 결과 리스트
  final RxList<Contest> results = <Contest>[].obs;

  // 💾 저장한 공모전 리스트
  final RxList<Contest> savedContests = <Contest>[].obs;

  // 🔤 검색창 제어용 컨트롤러
  final TextEditingController searchController = TextEditingController();

  // ✅ 입력 여부 추적용 RxBool (Obx에서 사용)
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      isSearching.value = searchController.text.trim().isNotEmpty;
    });

    // 🧪 테스트용 공모전 데이터 미리 로드
    allContests.addAll([
      Contest(
        title: '코디언 AI 서비스 기획 공모전',
        imageUrl: 'https://example.com/image1.jpg',
        reward: '인턴 채용 연계',
        eligibility: '대학생',
        tags: ['AI', '기획'],
      ),
      Contest(
        title: '브레인코드 IT 문제해결 공모전',
        imageUrl: 'https://example.com/image2.jpg',
        reward: '상금/입사 가산점',
        eligibility: '대학생/일반인',
        tags: ['IT', '문제해결'],
      ),
      Contest(
        title: '제12회 한국환경연구원 탄소중립 아이디어 공모전',
        imageUrl: 'https://example.com/image3.jpg',
        reward: '환경부 장관상/상품',
        eligibility: '제한없음',
        tags: ['환경', '아이디어'],
      ),
    ]);
    results.assignAll(allContests);
  }

  /// 🔍 키워드로 검색 실행
  void search(String query) {
    keyword.value = query;
    searchController.text = query;

    final lowerQuery = query.toLowerCase();
    results.value = allContests.where((contest) =>
    contest.title.toLowerCase().contains(lowerQuery) ||
        contest.reward.toLowerCase().contains(lowerQuery) ||
        contest.eligibility.toLowerCase().contains(lowerQuery) ||
        contest.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))
    ).toList();
  }

  /// ⭐ 저장 또는 저장 취소
  void toggleSave(Contest contest) {
    final index = savedContests.indexWhere((c) => c.title == contest.title);
    if (index != -1) {
      savedContests.removeAt(index);
    } else {
      savedContests.add(contest);
    }
    results.refresh();
  }

  /// ✅ 저장 여부 확인
  bool isSaved(Contest contest) {
    return savedContests.any((c) => c.title == contest.title);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}