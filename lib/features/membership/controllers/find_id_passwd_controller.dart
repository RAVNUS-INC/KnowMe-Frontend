import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/signup_model.dart';
import '../models/find_id_dtos.dart';  // ✅ 추가
import '../repositories/auth_repository.dart';  // ✅ 추가
import 'package:logger/logger.dart';

class FindIdPasswdController extends GetxController {
  // Repository 추가
  final AuthRepository _authRepository = AuthRepository();  // ✅ 추가

  // Rx variables
  final RxInt idFindMethod = 0.obs; // 0: Email, 1: Phone
  final RxBool canSubmitFindId = false.obs;
  final RxBool canSubmitFindPw = false.obs;

  // Error message variables
  final RxString idFindErrorMessage = ''.obs;
  final RxString passwordFindErrorMessage = ''.obs;
  final RxBool showIdFindError = false.obs;
  final RxBool showPasswordFindError = false.obs;

  // Loading state 추가
  final RxBool isLoading = false.obs;  // ✅ 추가

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();

  final Logger _logger = Logger();

  // 찾은 아이디 저장용 변수 추가
  String foundLoginId = '';  // ✅ 추가

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

  /// ✅ 수정: API를 사용한 아이디 찾기
  Future<void> submitFindId() async {
    if (!canSubmitFindId.value || isLoading.value) return;

    // 로딩 상태 시작
    isLoading.value = true;
    _logger.d('=== 아이디 찾기 API 호출 시작 ===');

    try {
      String? email;
      String? phone;

      // 이메일 또는 휴대폰 번호에 따라 요청 데이터 준비
      if (idFindMethod.value == 0) {
        // 이메일로 찾기
        email = emailController.text.trim();
        _logger.d('이메일로 아이디 찾기: $email');
      } else {
        // 휴대폰 번호로 찾기
        phone = phoneController.text.trim().replaceAll('-', '').replaceAll(' ', '');
        _logger.d('휴대폰 번호로 아이디 찾기: $phone');
      }

      // FindIdRequestDto 생성
      final findIdRequest = FindIdRequestDto(
        email: email,
        phone: phone,
      );

      _logger.d('아이디 찾기 요청 데이터: ${findIdRequest.toJson()}');

      // API 호출
      final response = await _authRepository.findId(findIdRequest);

      if (response.isSuccess && response.data != null) {
        final findIdResponse = response.data!;

        if (findIdResponse.isSuccess && findIdResponse.foundLoginId.isNotEmpty) {
          // 아이디 찾기 성공
          foundLoginId = findIdResponse.foundLoginId;
          _logger.d('아이디 찾기 성공: $foundLoginId');

          // 성공 메시지 표시
          Get.snackbar(
            '아이디 찾기 성공',
            findIdResponse.message.isNotEmpty
                ? findIdResponse.message
                : '아이디를 찾았습니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          // 결과 화면으로 이동 (찾은 아이디 전달)
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offNamed('/find-id-result', arguments: {'foundLoginId': foundLoginId});
          });

        } else {
          // 서버에서 실패 응답 (아이디를 찾을 수 없음)
          _logger.e('아이디 찾기 실패: ${findIdResponse.message}');
          _showIdFindError(findIdResponse.message.isNotEmpty
              ? findIdResponse.message
              : '입력하신 정보로 등록된 아이디를 찾을 수 없습니다.');
        }
      } else {
        // API 호출 자체가 실패
        _logger.e('아이디 찾기 API 호출 실패: ${response.message}');

        // 상태 코드별 에러 메시지
        if (response.statusCode == 404) {
          _showIdFindError('입력하신 정보로 등록된 아이디를 찾을 수 없습니다.');
        } else if (response.statusCode == 400) {
          _showIdFindError('입력 정보를 확인해주세요.');
        } else if (response.statusCode == 0) {
          _showIdFindError('서버에 연결할 수 없습니다. 네트워크를 확인해주세요.');
        } else {
          _showIdFindError(response.message ?? '아이디 찾기 중 오류가 발생했습니다.');
        }
      }

    } catch (e) {
      _logger.e('아이디 찾기 예외 발생: $e');
      _showIdFindError('예상치 못한 오류가 발생했습니다. 다시 시도해주세요.');
    } finally {
      // 로딩 상태 종료
      isLoading.value = false;
      _logger.d('=== 아이디 찾기 완료 ===');
    }
  }

  /// 아이디 찾기 에러 메시지 표시
  void _showIdFindError(String message) {
    showIdFindError.value = true;
    idFindErrorMessage.value = message;
  }

  // Handle find password submission - 사용자 ID 검증 없이 바로 비밀번호 재설정 페이지로 이동
  Future<void> submitFindPassword() async {
    if (!canSubmitFindPw.value) return;

    String userId = userIdController.text.trim();
    _logger.d('비밀번호 찾기 - 입력된 userId: $userId');

    // 사용자 ID 존재 여부 확인 없이 바로 비밀번호 재설정 페이지로 이동
    // 실제 검증은 /api/user/editPassword API에서 수행
    _logger.d('비밀번호 재설정 페이지로 이동 - userId: $userId');

    Get.offNamed('/password-reset', arguments: {'userId': userId});
  }
}