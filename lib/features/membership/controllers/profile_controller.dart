import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../views/profile_screen.dart';

class ProfileController extends GetxController {
  final userProfile = dummyProfile.obs;

  // 멤버십 플랜 선택 상태 (default: 0번째)
  var selectedPlan = 0.obs;

  void selectPlan(int index) {
    selectedPlan.value = index;
  }

  void goToActivity() {
    Get.toNamed('/activity');
  }

  void goToMembership(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MembershipScreen()),
    );
  }

  // 로그아웃, 계정탈퇴 등 추가
  void logout() {}
  void withdrawAccount() {}
}


// 구독 옵션 카드
class MembershipController extends GetxController {
  // 선택된 플랜(기본: 첫 번째)
  final selectedIndex = 0.obs;

  void selectPlan(int idx) {
    selectedIndex.value = idx;
  }

  void subscribe() {
    // 실제 결제 혹은 구독 처리 로직 (예시)
    // membershipPlans[selectedIndex.value]로 어떤 플랜 선택됐는지 알 수 있음
  }
}