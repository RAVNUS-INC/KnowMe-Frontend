import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/signup_model.dart';
import 'package:logger/logger.dart';

class SignupThirdController extends GetxController {
  final SignupModel model;
  final logger = Logger();

  // TextEditingController 추가
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailPrefixController = TextEditingController();
  final TextEditingController emailDomainController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController majorController = TextEditingController();

  SignupThirdController({required this.model});

  @override
  void onInit() {
    super.onInit();

    // 이전 페이지에서 전달받은 데이터 처리 - Map<String, dynamic> 타입 명시
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final Map<String, dynamic> args = Get.arguments;
      model.agreeToMarketingInfo = args['marketingConsent'] ?? false;
      model.userId = args['userId'] ?? '';
      model.password = args['password'] ?? '';
      model.phoneNumber = args['phoneNumber'] ?? '';
    }

    // TextController에 리스너 추가
    nameController.addListener(() => updateName(nameController.text));
    emailPrefixController
        .addListener(() => updateEmailPrefix(emailPrefixController.text));
    emailDomainController
        .addListener(() => updateEmailDomain(emailDomainController.text));
    schoolNameController
        .addListener(() => updateSchoolName(schoolNameController.text));
    majorController.addListener(() => updateMajor(majorController.text));
  }

  @override
  void onClose() {
    // 컨트롤러 해제
    nameController.dispose();
    emailPrefixController.dispose();
    emailDomainController.dispose();
    schoolNameController.dispose();
    majorController.dispose();
    super.onClose();
  }

  // 이름 업데이트 및 유효성 검사
  void updateName(String value) {
    model.name = value;
    model.isNameValid = value.isNotEmpty;
    update();
  }

  // 이메일 접두사 업데이트 및 유효성 검사
  void updateEmailPrefix(String value) {
    model.emailPrefix = value;
    _validateEmail();
    update();
  }

  // 이메일 도메인 업데이트 및 유효성 검사
  void updateEmailDomain(String? value) {
    if (value != null) {
      model.emailDomain = value;
      _validateEmail();
      update();
    }
  }

  // 학교명 업데이트 및 유효성 검사
  void updateSchoolName(String value) {
    model.schoolName = value;
    _validateEducation();
    update();
  }

  // 전공(학과) 업데이트 및 유효성 검사
  void updateMajor(String value) {
    model.major = value;
    _validateEducation();
    update();
  }

  // 학년 업데이트
  void updateGrade(String value) {
    model.grade = value;
    update();
  }

  // 재학 상태 업데이트
  void updateEducationStatus(bool isEnrolled) {
    model.isCurrentlyEnrolled = isEnrolled;
    update();
  }

  // 학력 정보 유효성 검사
  void _validateEducation() {
    model.isEducationValid =
        model.schoolName.isNotEmpty && model.major.isNotEmpty;
  }

  // 희망 직종 업데이트 및 유효성 검사
  void updateDesiredPosition(String? value) {
    if (value != null && value != '선택') {
      model.desiredPosition = value;
      model.isDesiredPositionValid = true;
    } else {
      model.desiredPosition = '';
      model.isDesiredPositionValid = false;
    }
    update();
  }

  // 이메일 전체 유효성 검사
  void _validateEmail() {
    model.isEmailValid = model.emailPrefix.isNotEmpty &&
        model.emailDomain.isNotEmpty &&
        _isValidEmail();
  }

  // 이메일 형식 유효성 검사
  bool _isValidEmail() {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$');
    final fullEmail = '${model.emailPrefix}@${model.emailDomain}';
    return emailRegex.hasMatch(fullEmail);
  }

  // 회원가입 완료 처리
  void completeSignup() {
    if (model.isThirdNextButtonEnabled) {
      try {
        // API 호출 또는 데이터베이스 저장 로직
        final userData = model.toJson();
        logger.d('회원가입 데이터: $userData');

        // 성공 메시지 표시
        Get.snackbar(
          '회원가입 완료',
          '회원가입이 성공적으로 완료되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // 로그인 페이지로 이동
        Get.offAllNamed('/login');
      } catch (e) {
        // 오류 처리
        Get.snackbar(
          '회원가입 실패',
          '회원가입 처리 중 오류가 발생했습니다. 다시 시도해주세요.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
