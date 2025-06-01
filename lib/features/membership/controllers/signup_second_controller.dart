import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/signup_model.dart';
import 'package:logger/logger.dart';

class SignupSecondController extends GetxController {
  final SignupModel signupModel = SignupModel();
  final logger = Logger();

  // Text controllers
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController verificationCodeController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Initialize password visibility states
    signupModel.obscurePassword = false;
    signupModel.obscurePasswordConfirm = false;

    // Get marketing consent from previous page
    if (Get.arguments != null && Get.arguments is Map) {
      signupModel.agreeToMarketingInfo =
          Get.arguments['marketingConsent'] ?? false;
    }

    // Add listeners to text controllers
    idController.addListener(_validateId);
    passwordController.addListener(_validatePassword);
    passwordConfirmController.addListener(_validatePasswordConfirm);
    phoneController.addListener(_validatePhone);
  }

  @override
  void onClose() {
    // Dispose text controllers
    idController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    phoneController.dispose();
    verificationCodeController.dispose();
    super.onClose();
  }

  // Validate ID
  void _validateId() {
    final id = idController.text;
    final hasMinLength = id.length >= 6; // Minimum 6 characters
    final hasLetters = id.contains(RegExp(r'[A-Za-z]')); // Contains letters
    final hasDigits = id.contains(RegExp(r'[0-9]')); // Contains digits

    signupModel.userId = id;
    signupModel.isIdValid = hasMinLength && hasLetters && hasDigits;
    update();
  }

  // Validate password
  void _validatePassword() {
    final password = passwordController.text;
    // Password must be at least 8 characters, contain letters and digits
    final hasMinLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));

    signupModel.password = password;
    signupModel.isPasswordValid =
        hasMinLength && (hasUppercase || hasLowercase) && hasDigits;

    // If password changes, validate password confirmation again
    _validatePasswordConfirm();
    update();
  }

  // Validate password confirmation
  void _validatePasswordConfirm() {
    final passwordConfirm = passwordConfirmController.text;

    signupModel.passwordConfirm = passwordConfirm;
    signupModel.isPasswordConfirmValid =
        signupModel.password == passwordConfirm && passwordConfirm.isNotEmpty;
    update();
  }

  // Validate phone number
  void _validatePhone() {
    final phone = phoneController.text;

    signupModel.phoneNumber = phone;
    signupModel.isPhoneValid = phone.length >= 10;
    update();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    signupModel.obscurePassword = !signupModel.obscurePassword;
    update();
  }

  // Toggle password confirmation visibility
  void togglePasswordConfirmVisibility() {
    signupModel.obscurePasswordConfirm = !signupModel.obscurePasswordConfirm;
    update();
  }

  // Send verification code
  void sendVerificationCode() {
    if (signupModel.isPhoneValid) {
      logger.d('인증번호 발송');
      // Logic to send verification code
    }
  }

  // Navigate to the third page
  void navigateToThirdPage() {
    if (signupModel.isSecondNextButtonEnabled) {
      Get.toNamed('/signup/third', arguments: {
        'marketingConsent': signupModel.agreeToMarketingInfo,
        'userId': signupModel.userId,
        'password': signupModel.password,
        'phoneNumber': signupModel.phoneNumber,
      });
    }
  }
}
