import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/login_model.dart';
import '../models/signup_model.dart';

class LoginController extends GetxController {
  final LoginModel model;

  // TextEditingController를 컨트롤러에서 생성 및 관리
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Rx 변수로 상태 관리
  final RxBool obscureText = true.obs;
  final RxBool rememberAccount = false.obs;
  final RxBool isLoading = false.obs;

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

  Future<void> handleLogin() async {
    final userId = idController.text.trim();
    final password = passwordController.text.trim();

    // 입력값 검증
    if (userId.isEmpty || password.isEmpty) {
      Get.snackbar(
        '로그인 실패',
        '아이디와 비밀번호를 모두 입력해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 로딩 상태 시작
    isLoading.value = true;

    try {
      // API 호출 시뮬레이션 (실제로는 서버 통신)
      await Future.delayed(const Duration(milliseconds: 800));

      // 테스트 계정 검증
      bool isValidLogin = _validateTestUser(userId, password);

      if (isValidLogin) {
        // 로그인 성공
        Get.snackbar(
          '로그인 성공',
          '환영합니다, ${SignupModel.testUserId}님!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // 홈 화면으로 이동
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAllNamed('/home');
        });
      } else {
        // 로그인 실패
        Get.snackbar(
          '로그인 실패',
          '아이디 또는 비밀번호가 올바르지 않습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      Get.snackbar(
        '오류',
        '로그인 중 오류가 발생했습니다. 다시 시도해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // 로딩 상태 종료
      isLoading.value = false;
    }
  }

  // 테스트 사용자 검증 메서드
  bool _validateTestUser(String userId, String password) {
    // SignupModel의 테스트 데이터와 비교
    return userId.toLowerCase() == SignupModel.testUserId.toLowerCase() &&
        password == SignupModel.testPassword;
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
      '$provider 로그인은 현재 개발 중입니다.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}