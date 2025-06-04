import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/login_model.dart';
import '../models/login_dtos.dart';
import '../repositories/auth_repository.dart';
import 'package:logger/logger.dart';

class LoginController extends GetxController {
  final LoginModel model;
  final Logger logger = Logger();
  final AuthRepository _authRepository = AuthRepository();

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
      final rememberMe = await _authRepository.getRememberMe();
      if (rememberMe) {
        final credentials = await _authRepository.getSavedCredentials();
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

  /// 일반 로그인 처리
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

      // API 호출
      final response = await _authRepository.login(loginRequest);

      if (response.isSuccess && response.data != null) {
        final loginResponse = response.data!;

        // 서버 응답에서 성공 여부 확인
        if (loginResponse.isSuccess && loginResponse.token.isNotEmpty) {
          await _handleLoginSuccess(userId, password, loginResponse);
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

  /// 네이버 소셜 로그인 처리
  Future<void> handleNaverLogin() async {
    try {
      logger.d('네이버 소셜 로그인 시작');

      // 로딩 상태 표시
      Get.snackbar(
        '네이버 로그인',
        '네이버 로그인 페이지로 이동합니다...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // 네이버 소셜 로그인 URL로 리디렉션
      final success = await _authRepository.loginWithNaver();

      if (!success) {
        _showErrorMessage('네이버 로그인 페이지를 열 수 없습니다.');
        return;
      }

      // 백엔드에서 쿠키로 JWT를 전달하므로
      // 실제 구현에서는 딥링크나 앱 재시작 시 토큰 확인 로직이 필요
      // 현재는 개발 단계이므로 성공 메시지만 표시
      logger.d('네이버 로그인 페이지 열기 성공');

    } catch (e) {
      logger.e('네이버 소셜 로그인 오류: $e');
      _showErrorMessage('네이버 로그인 중 오류가 발생했습니다.');
    }
  }

  /// ✅ 새로 추가: 현재 사용자 정보 조회 및 저장
  Future<void> _fetchAndUpdateUserInfo() async {
    try {
      logger.d('사용자 정보 조회 시작');

      final userInfoResponse = await _authRepository.getCurrentUserInfo();

      if (userInfoResponse.isSuccess && userInfoResponse.data != null) {
        final userInfo = userInfoResponse.data!;

        if (userInfo.isSuccess && userInfo.id > 0) {
          // 사용자 ID 저장
          await _authRepository.saveUserId(userInfo.id);

          logger.d('사용자 정보 조회 및 저장 완료 - ID: ${userInfo.id}');
        } else {
          logger.e('사용자 정보 응답 실패: ${userInfo.message}');
        }
      } else {
        logger.e('사용자 정보 API 호출 실패: ${userInfoResponse.message}');
      }
    } catch (e) {
      logger.e('사용자 정보 조회 오류: $e');
      // 사용자 정보 조회 실패는 로그인 성공에 영향을 주지 않음
    }
  }

  /// 로그인 성공 처리 공통 메서드
  Future<void> _handleLoginSuccess(
      String userId,
      String password,
      LoginResponseDto loginResponse
      ) async {
    // JWT 토큰 저장
    await _authRepository.saveToken(loginResponse.token);

    // 사용자 정보 저장
    await _authRepository.saveUserInfo({
      'userId': userId,
      'loginTime': DateTime.now().toIso8601String(),
    });

    // ✅ 새로 추가: 현재 사용자 정보 조회 및 저장
    await _fetchAndUpdateUserInfo();

    // Remember Me 처리
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
      '환영합니다!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // 홈 화면으로 이동
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAllNamed('/home');
    });
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

  /// 소셜 로그인 핸들러 (확장 가능)
  void handleSocialLogin(String provider) {
    switch (provider.toLowerCase()) {
      case '네이버':
        handleNaverLogin();
        break;
      case '구글':
        Get.snackbar(
          '소셜 로그인',
          '$provider 로그인은 현재 지원되지 않습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        break;
    }
  }
}