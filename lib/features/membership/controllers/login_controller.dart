import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/login_model.dart';

class LoginController extends GetxController {
  final LoginModel model;

  // TextEditingController를 컨트롤러에서 생성 및 관리
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Rx 변수로 상태 관리
  final RxBool obscureText = true.obs;
  final RxBool rememberAccount = false.obs;

  LoginController({
    required this.model,
  });

  @override
  void onInit() {
    super.onInit();
    // 초기값 설정 (필요한 경우)
    if (model.userId.isNotEmpty) {
      idController.text = model.userId;
    }
    if (model.password.isNotEmpty) {
      passwordController.text = model.password;
    }

    // 리스너 추가
    idController.addListener(() {
      model.userId = idController.text;
    });

    passwordController.addListener(() {
      model.password = passwordController.text;
    });

    rememberAccount.value = model.rememberAccount;
  }

  @override
  void onClose() {
    // 컨트롤러 해제
    idController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  void toggleRememberAccount(bool? value) {
    rememberAccount.value = value ?? false;
    model.rememberAccount = rememberAccount.value;
  }

/*
  Future<void> handleLogin() async {
    // 로그인 처리 로직
    try {
      // 로그인 API 호출 로직
      // 성공 시 홈 화면으로 이동
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        '로그인 실패',
        '아이디 또는 비밀번호를 확인해주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
*/
  ///개발동안만 유지하다가 실제 배포 및 제출시엔 삭제 후 위 handelLogin 이용 바람 -jangjimin9766
  Future<void> handleLogin() async {
    // 테스트용 바로 이동
    Get.offAllNamed('/home');
  }

  void handleRegister() {
    // 회원가입 화면으로 이동
    Get.toNamed('/signup/first');
  }

  void handleForgotPassword() {
    // 아이디/비밀번호 찾기 화면으로 이동
    Get.toNamed('/find-id-passwd');
  }

  void handleSocialLogin(String provider) {
    // 소셜 로그인 처리 로직
    Get.snackbar(
      '소셜 로그인',
      '$provider 로그인 시도 중...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
