import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindIdPasswdController extends GetxController {
  // Rx variables
  final RxInt idFindMethod = 0.obs; // 0: Email, 1: Phone
  final RxBool canSubmitFindId = false.obs;
  final RxBool canSubmitFindPw = false.obs;

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Add listeners to update button state
    emailController.addListener(_updateIdSubmitButton);
    phoneController.addListener(_updateIdSubmitButton);
    userIdController.addListener(_updatePwSubmitButton);
  }

  @override
  void onClose() {
    // Dispose text controllers
    emailController.dispose();
    phoneController.dispose();
    userIdController.dispose();
    super.onClose();
  }

  // Change ID find method
  void changeIdFindMethod(int value) {
    idFindMethod.value = value;
    _updateIdSubmitButton();
  }

  // Update ID submit button state
  void _updateIdSubmitButton() {
    if (idFindMethod.value == 0) {
      // Email validation
      canSubmitFindId.value =
          emailController.text.isNotEmpty && emailController.text.contains('@');
    } else {
      // Phone validation
      canSubmitFindId.value =
          phoneController.text.isNotEmpty && phoneController.text.length >= 10;
    }
  }

  // Update password submit button state
  void _updatePwSubmitButton() {
    canSubmitFindPw.value = userIdController.text.isNotEmpty;
  }

  // Handle find ID submission
  void submitFindId() {
    if (canSubmitFindId.value) {
      // API call to find user ID (실제 구현에서는 여기에 API 호출 코드)

      // Show success message
      Get.snackbar(
        '아이디 찾기 성공',
        '등록된 이메일로 아이디가 전송되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // 로그인 페이지로 명시적으로 이동
      Future.delayed(const Duration(milliseconds: 1500), () {
        Get.offAllNamed('/login');
      });
    }
  }

  // Handle find password submission
  void submitFindPassword() {
    if (canSubmitFindPw.value) {
      // API call to reset password (실제 구현에서는 여기에 API 호출 코드)

      // Show success message
      Get.snackbar(
        '비밀번호 재설정',
        '등록된 이메일로 비밀번호 재설정 링크가 전송되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // 로그인 페이지로 명시적으로 이동
      Future.delayed(const Duration(milliseconds: 1000), () {
        Get.offAllNamed('/login');
      });
    }
  }
}
