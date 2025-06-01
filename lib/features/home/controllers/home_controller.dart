import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';

class HomeController extends GetxController {
  // 🔹 현재 카드 인덱스 (슬라이더)
  final RxInt currentPage = 0.obs;

  // 🔹 PageController
  final PageController pageController = PageController(viewportFraction: 0.85);

  // 🔹 아이콘 목록
  final List<Map<String, String>> iconItems = const [
    {'image': '채용.png', 'label': '채용'},
    {'image': '인턴.png', 'label': '인턴'},
    {'image': '대외활동.png', 'label': '대외활동'},
    {'image': '교육 강연.png', 'label': '교육/강연'},
    {'image': '공모전.png', 'label': '공모전'},
  ];
  Widget buildPage(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 300,
        height: 167,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Card ${index + 1}',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      final page = pageController.page?.round() ?? 0;
      if (currentPage.value != page) {
        currentPage.value = page;
      }
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // 🔸 슬라이더 아이템 생성
  Widget buildSliderCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 300,
        height: 167,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Card ${index + 1}',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ),
    );
  }

  // 🔸 AI 분석으로 이동
  void goToAiAnalysis() {
    Get.toNamed(AppRoutes.aiAnalysis); // ✅ binding 적용됨
  }
}
