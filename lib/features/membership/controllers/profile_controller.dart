import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../views/profile_screen.dart';
import 'package:knowme_frontend/features/membership/models/profile_model.dart';

class ProfileController extends GetxController {
  final userProfile = dummyProfile.obs;

  void goToActivity() {
    Get.toNamed('/activity');
  }

  // 로그아웃, 계정탈퇴 등 추가
  void logout() {}
  void withdrawAccount() {}
}