import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/auth_repository.dart';
import '../models/password_reset_dtos.dart';
import 'package:logger/logger.dart';

class PasswordResetController extends GetxController {
  // Text controllers
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Rx variables
  final RxBool showNewPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;
  final RxBool canSubmit = false.obs;
  final RxBool isNewPasswordValid = false.obs;
  final RxBool isConfirmPasswordValid = false.obs;
  final RxBool isLoading = false.obs;

  // Repository & Logger
  final AuthRepository _authRepository = AuthRepository();
  final Logger _logger = Logger();

  // 사용자 ID 저장
  String userId = '';

  @override
  void onInit() {
    super.onInit();

    // 이전 페이지에서 전달받은 userId 가져오기
    if (Get.arguments != null && Get.arguments['userId'] != null) {
      userId = Get.arguments['userId'];
      _logger.d('비밀번호 재설정 대상 사용자: $userId');
    }

    // Add listeners to validate input
    newPasswordController.addListener(_validatePasswords);
    confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleNewPasswordVisibility() {
    showNewPassword.value = !showNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  void _validatePasswords() {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    // 비밀번호 검증 (영문, 숫자 포함 8자 이상)
    final hasMinLength = newPassword.length >= 8;
    final hasUppercase = newPassword.contains(RegExp(r'[A-Z]'));
    final hasLowercase = newPassword.contains(RegExp(r'[a-z]'));
    final hasDigits = newPassword.contains(RegExp(r'[0-9]'));

    isNewPasswordValid.value = hasMinLength && (hasUppercase || hasLowercase) && hasDigits;

    // 비밀번호 확인 검증
    isConfirmPasswordValid.value = confirmPassword.isNotEmpty && newPassword == confirmPassword;

    // 제출 버튼 활성화
    canSubmit.value = isNewPasswordValid.value && isConfirmPasswordValid.value;
  }

  /// 비밀번호 재설정 - 단순화된 버전
  Future<void> resetPassword() async {
    if (!canSubmit.value || isLoading.value) return;

    if (userId.isEmpty) {
      _showErrorMessage('사용자 정보를 찾을 수 없습니다.');
      return;
    }

    isLoading.value = true;
    _logger.d('=== 비밀번호 재설정 시작 ===');

    try {
      // 요청 데이터 준비
      final resetRequest = PasswordResetRequestDto(
        loginId: userId,
        password: newPasswordController.text,
      );

      _logger.d('요청 데이터: ${resetRequest.toJson()}');

      // API 호출 (단순한 Map으로 응답 받기)
      final response = await _authRepository.resetPassword(resetRequest);

      _logger.d('API 응답 성공 여부: ${response.isSuccess}');
      _logger.d('응답 상태 코드: ${response.statusCode}');
      _logger.d('응답 데이터: ${response.data}');
      _logger.d('응답 메시지: ${response.message}');

      if (response.isSuccess && response.data != null) {
        // 성공 - 응답 데이터 확인
        final responseData = response.data as Map<String, dynamic>;
        _logger.d('서버 응답 내용: $responseData');

        // 서버 응답에서 성공 여부 확인 (다양한 형태 지원)
        final isServerSuccess = _checkServerSuccess(responseData);

        if (isServerSuccess) {
          // 성공 처리
          final message = _getServerMessage(responseData) ?? '비밀번호가 성공적으로 변경되었습니다.';

          Get.snackbar(
            '비밀번호 재설정 완료',
            message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          // 성공 페이지로 이동
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offNamed('/password-reset-success');
          });

        } else {
          // 서버에서 실패 응답
          final errorMessage = _getServerMessage(responseData) ?? '비밀번호 재설정에 실패했습니다.';
          _showErrorMessage(errorMessage);
        }
      } else if (response.isSuccess && response.data == null) {
        // 응답 데이터가 null인 경우도 성공으로 간주 (HTTP 200)
        _logger.d('응답 데이터가 null이지만 HTTP 상태는 성공');

        Get.snackbar(
          '비밀번호 재설정 완료',
          '비밀번호가 성공적으로 변경되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offNamed('/password-reset-success');
        });
      } else {
        // API 호출 실패
        final errorMessage = response.message ?? '비밀번호 재설정에 실패했습니다.';

        // 상태 코드별 에러 메시지
        if (response.statusCode == 404) {
          _showErrorMessage('존재하지 않는 사용자 ID입니다.');
        } else if (response.statusCode == 400) {
          _showErrorMessage('비밀번호 중복. 입력 정보를 확인해주세요.');
        } else if (response.statusCode == 0) {
          _showErrorMessage('서버에 연결할 수 없습니다. 네트워크를 확인해주세요.');
        } else {
          _showErrorMessage(errorMessage);
        }
      }

    } catch (e) {
      _logger.e('비밀번호 재설정 예외: $e');
      _showErrorMessage('예상치 못한 오류가 발생했습니다: ${e.toString()}');
    } finally {
      isLoading.value = false;
      _logger.d('=== 비밀번호 재설정 종료 ===');
    }
  }

  /// 서버 응답에서 성공 여부 확인 (다양한 형태 지원)
  bool _checkServerSuccess(Map<String, dynamic> data) {
    // 가능한 성공 필드들 확인
    if (data.containsKey('success')) {
      return data['success'] == true;
    }
    if (data.containsKey('status')) {
      final status = data['status'].toString().toLowerCase();
      return status == 'success' || status == 'ok';
    }
    if (data.containsKey('result')) {
      final result = data['result'].toString().toLowerCase();
      return result == 'success' || result == 'ok';
    }

    // 기본적으로는 성공으로 간주 (HTTP 200이므로)
    return true;
  }

  /// 서버 응답에서 메시지 추출
  String? _getServerMessage(Map<String, dynamic> data) {
    if (data.containsKey('message')) {
      return data['message']?.toString();
    }
    if (data.containsKey('msg')) {
      return data['msg']?.toString();
    }
    return null;
  }

  /// 에러 메시지 표시
  void _showErrorMessage(String message) {
    Get.snackbar(
      '비밀번호 재설정 실패',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}