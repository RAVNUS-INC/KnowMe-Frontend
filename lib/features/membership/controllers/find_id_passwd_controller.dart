import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/signup_model.dart';

class FindIdPasswdController extends GetxController {
  // Rx variables
  final RxInt idFindMethod = 0.obs; // 0: Email, 1: Phone
  final RxBool canSubmitFindId = false.obs;
  final RxBool canSubmitFindPw = false.obs;

  // Error message variables
  final RxString idFindErrorMessage = ''.obs;
  final RxString passwordFindErrorMessage = ''.obs;
  final RxBool showIdFindError = false.obs;
  final RxBool showPasswordFindError = false.obs;

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
    // Clear error message when changing method
    showIdFindError.value = false;
    idFindErrorMessage.value = '';
    _updateIdSubmitButton();
  }

  // Update ID submit button state
  void _updateIdSubmitButton() {
    // Clear error message when user starts typing
    if (showIdFindError.value) {
      showIdFindError.value = false;
      idFindErrorMessage.value = '';
    }

    if (idFindMethod.value == 0) {
      // Email validation - check format
      final email = emailController.text.trim();
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      canSubmitFindId.value = email.isNotEmpty && emailRegex.hasMatch(email);
    } else {
      // Phone validation - check format (Korean phone number format)
      final phone =
          phoneController.text.trim().replaceAll('-', '').replaceAll(' ', '');
      final phoneRegex = RegExp(r'^01[0-9]{1}[0-9]{7,8}$');
      canSubmitFindId.value = phone.isNotEmpty && phoneRegex.hasMatch(phone);
    }
  }

  // Update password submit button state
  void _updatePwSubmitButton() {
    // Clear error message when user starts typing
    if (showPasswordFindError.value) {
      showPasswordFindError.value = false;
      passwordFindErrorMessage.value = '';
    }

    final userId = userIdController.text.trim();
    // Basic validation - at least 3 characters for user ID
    canSubmitFindPw.value = userId.length >= 3;
  }

  // Handle find ID submission
  Future<void> submitFindId() async {
    if (!canSubmitFindId.value) return;

    // Show loading state
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      String input;
      bool isEmail = idFindMethod.value == 0;
      bool exists = false;

      if (isEmail) {
        input = emailController.text.trim();
        exists = SignupModel.isValidTestEmail(input);
      } else {
        input = phoneController.text.trim();
        exists = SignupModel.isValidTestPhone(input);
      }

      // Close loading dialog
      Get.back();

      if (exists) {
        // Navigate to result screen
        Get.offNamed('/find-id-result');
      } else {
        // Show error message
        showIdFindError.value = true;
        idFindErrorMessage.value = '잘못된 회원정보입니다.';
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show general error
      showIdFindError.value = true;
      idFindErrorMessage.value = '오류가 발생했습니다. 다시 시도해주세요.';
    }
  }

  // Handle find password submission
  Future<void> submitFindPassword() async {
    if (!canSubmitFindPw.value) return;

    // Show loading state
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      String userId = userIdController.text.trim();
      bool exists = SignupModel.isValidTestUserId(userId);

      // Close loading dialog
      Get.back();

      if (exists) {
        // Navigate to password reset screen
        Get.offNamed('/password-reset');
      } else {
        // Show error message
        showPasswordFindError.value = true;
        passwordFindErrorMessage.value = '잘못된 회원정보입니다.';
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show general error
      showPasswordFindError.value = true;
      passwordFindErrorMessage.value = '오류가 발생했습니다. 다시 시도해주세요.';
    }
  }
}
