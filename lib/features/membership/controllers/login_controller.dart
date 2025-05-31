import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/login_model.dart';
import '../models/login_dtos.dart';
import '../../../shared/services/login_api_service.dart';
import '../../../shared/services/auth_service.dart';
import '../../../core/utils/storage_utils.dart';
import 'package:logger/logger.dart';

class LoginController extends GetxController {
  final LoginModel model;
  final Logger logger = Logger();
  final LoginApiService _loginApiService = LoginApiService();

  // TextEditingController
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Rx 변수로 상태 관리
  final RxBool obscureText = true.obs;
  final RxBool rememberAccount = false.obs;
  final RxBool isLoading = false.obs;

  LoginController({LoginModel? model}) : model = model ?? LoginModel();

  @override
  void onInit() {
    super.onInit();
    // 초기값 설정
    if (model.userId.isNotEmpty) {
      idController.text = model.userId;
    }
    if (model.password.isNotEmpty) {
      passwordController.text = model.password;
    }
    rememberAccount.value = model.rememberAccount;

    // 저장된 로그인 정보 로드
    _loadSavedCredentials();
  }

  /// 저장된 로그인 정보 로드
  Future<void> _loadSavedCredentials() async {
    try {
      final rememberMe = await StorageUtils.getRememberMe();
      if (rememberMe) {
        final credentials = await StorageUtils.getSavedCredentials();
        if (credentials != null) {
          idController.text = credentials['loginId'] ?? '';
          passwordController.text = credentials['password'] ?? '';
          rememberAccount.value = true;
          logger.d('저장된 로그인 정보 로드 완료');
        }
      }
    } catch (e) {
      logger.e('저장된 로그인 정보 로드 오류: $e');
    }
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
      // LoginRequestDto 생성
      final loginRequest = LoginRequestDto(
        loginId: userId,  // 서버 DTO에 맞춰 loginId로 전달
        password: password,
      );

      logger.d('로그인 요청: ${loginRequest.toJson()}');

      // API 호출
      final response = await _loginApiService.login(loginRequest);

      if (response.isSuccess && response.data != null) {
        final loginResponse = response.data!;

        // 서버 응답에서 성공 여부 확인
        if (loginResponse.isSuccess && loginResponse.token.isNotEmpty) {
          // 로그인 성공
          logger.d('로그인 성공: ${loginResponse.message}');

          // JWT 토큰 저장
          await AuthService.saveToken(loginResponse.token);

          // 사용자 정보 저장
          await AuthService.saveUserInfo({
            'userId': userId,
            'loginTime': DateTime.now().toIso8601String(),
          });

          // Remember Me 처리
          await StorageUtils.setRememberMe(rememberAccount.value);
          if (rememberAccount.value) {
            await StorageUtils.saveCredentials(
              loginId: userId,
              password: password,
            );
          } else {
            await StorageUtils.clearSavedCredentials();
          }

          // 모델 업데이트
          model.userId = userId;
          model.password = password;

          // 성공 메시지 표시
          Get.snackbar(
            '로그인 성공',
            loginResponse.message.isNotEmpty
                ? loginResponse.message
                : '환영합니다!',
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
          // 서버에서 실패 응답
          logger.e('로그인 실패: ${loginResponse.message}');
          _showErrorMessage(loginResponse.message);
        }
      } else {
        // API 호출 자체가 실패
        logger.e('API 호출 실패: ${response.message}');
        _showErrorMessage(
            response.message ?? '로그인 처리 중 오류가 발생했습니다.'
        );
      }

    } catch (e) {
      // 예외 처리
      logger.e('로그인 예외 발생: $e');
      _showErrorMessage('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    } finally {
      // 로딩 상태 종료
      isLoading.value = false;
    }
  }

  /// 에러 메시지 표시
  void _showErrorMessage(String message) {
    Get.snackbar(
      '로그인 실패',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void handleRegister() {
    Get.toNamed('/signup/first');
  }

  void handleForgotPassword() {
    Get.toNamed('/find-id-passwd');
  }

  void handleSocialLogin(String provider) {
    Get.snackbar(
      '소셜 로그인',
      '$provider 로그인은 현재 개발 중입니다.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}