import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/membership_screen.dart';

class MembershipController extends GetxController {
  // 선택된 플랜(기본: 첫 번째)
  final selectedIndex = 0.obs;

  // 멤버십 플랜 선택 상태 (default: 0번째)
  var selectedPlan = 0.obs;

  void selectPlan(int idx) {
    selectedIndex.value = idx;
  }

  void goToMembership(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MembershipScreen()),
    );
  }

  void subscribe() {
    // 실제 결제/구독 처리
    // membershipPlans[selectedIndex.value] 접근
  }
}