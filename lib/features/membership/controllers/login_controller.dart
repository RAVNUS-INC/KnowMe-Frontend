import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/login_model.dart';
import '../models/login_dtos.dart';
import '../repositories/auth_repository.dart';  // ✅ 변경: AuthRepository 사용
import 'package:logger/logger.dart';

class LoginController extends GetxController {
  final LoginModel model;
  final Logger logger = Logger();
  final AuthRepository _authRepository = AuthRepository();  // ✅ 변경: AuthRepository 사용

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
      final rememberMe = await _authRepository.getRememberMe();  // ✅ 변경
      if (rememberMe) {
        final credentials = await _authRepository.getSavedCredentials();  // ✅ 변경
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
        loginId: userId,
        password: password,
      );

      logger.d('로그인 요청: ${loginRequest.toJson()}');

      // ✅ 변경: AuthRepository를 통한 API 호출
      final response = await _authRepository.login(loginRequest);

      if (response.isSuccess && response.data != null) {
        final loginResponse = response.data!;

        // 서버 응답에서 성공 여부 확인
        if (loginResponse.isSuccess && loginResponse.token.isNotEmpty) {
          // 로그인 성공
          logger.d('로그인 성공: ${loginResponse.message}');

          // ✅ 변경: AuthRepository를 통한 토큰 저장
          await _authRepository.saveToken(loginResponse.token);

          // ✅ 변경: AuthRepository를 통한 사용자 정보 저장
          await _authRepository.saveUserInfo({
            'userId': userId,
            'loginTime': DateTime.now().toIso8601String(),
          });

          // ✅ 변경: AuthRepository를 통한 Remember Me 처리
          await _authRepository.setRememberMe(rememberAccount.value);
          if (rememberAccount.value) {
            await _authRepository.saveCredentials(
              loginId: userId,
              password: password,
            );
          } else {
            await _authRepository.clearSavedCredentials();
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

  /// 로그아웃 처리 (새로 추가)
  Future<void> handleLogout() async {
    try {
      final success = await _authRepository.logout();
      if (success) {
        Get.offAllNamed('/login');
        Get.snackbar(
          '로그아웃',
          '성공적으로 로그아웃되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          '로그아웃 실패',
          '로그아웃 중 오류가 발생했습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      logger.e('로그아웃 오류: $e');
      Get.snackbar(
        '로그아웃 실패',
        '로그아웃 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}