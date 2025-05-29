import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordResetController extends GetxController {
  // Text controllers
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Rx variables
  final RxBool showNewPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;
  final RxBool canSubmit = false.obs;
  final RxBool isNewPasswordValid = false.obs;
  final RxBool isConfirmPasswordValid = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Add listeners to validate input
    newPasswordController.addListener(_validatePasswords);
    confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void onClose() {
    // Dispose text controllers
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle new password visibility
  void toggleNewPasswordVisibility() {
    showNewPassword.value = !showNewPassword.value;
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  // Validate passwords
  void _validatePasswords() {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validate new password (영문, 숫자 포함 8자 이상)
    final hasMinLength = newPassword.length >= 8;
    final hasUppercase = newPassword.contains(RegExp(r'[A-Z]'));
    final hasLowercase = newPassword.contains(RegExp(r'[a-z]'));
    final hasDigits = newPassword.contains(RegExp(r'[0-9]'));

    isNewPasswordValid.value =
        hasMinLength && (hasUppercase || hasLowercase) && hasDigits;

    // Validate confirm password (matches new password)
    isConfirmPasswordValid.value =
        confirmPassword.isNotEmpty && newPassword == confirmPassword;

    // Enable submit button if both passwords are valid
    canSubmit.value = isNewPasswordValid.value && isConfirmPasswordValid.value;
  }

  // Handle password reset
  Future<void> resetPassword() async {
    if (!canSubmit.value) return;

    // Show loading state
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Close loading dialog
      Get.back();

      // Navigate to success screen
      Get.offNamed('/password-reset-success');
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error message
      Get.snackbar(
        '오류',
        '비밀번호 재설정 중 오류가 발생했습니다. 다시 시도해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
