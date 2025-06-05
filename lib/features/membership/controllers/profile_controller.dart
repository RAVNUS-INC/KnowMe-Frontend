import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../repositories/auth_repository.dart';
import 'package:logger/logger.dart';

class ProfileController extends GetxController {
  final Logger _logger = Logger();
  final AuthRepository _authRepository = AuthRepository();

  // 사용자 프로필 상태 (기본값으로 더미 데이터 표시)
  final userProfile = defaultProfile.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  /// 사용자 프로필 정보 로드 (이름, 이메일만 실제 데이터로 업데이트)
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 저장된 사용자 ID 가져오기
      final userId = await _authRepository.getUserId();

      if (userId == null || userId <= 0) {
        _logger.w('사용자 ID가 없습니다. 더미 데이터 유지');
        return;
      }

      _logger.d('사용자 프로필 로드 시작 - User ID: $userId');

      // 현재 로그인된 사용자 정보 API 호출
      final response = await _authRepository.getCurrentUserInfo();

      if (response.isSuccess && response.data != null) {
        final userInfo = response.data!;

        if (userInfo.isSuccess) {
          // API 응답을 UserProfile로 변환 (이름, 이메일만 실제 데이터)
          userProfile.value = UserProfile.fromUserInfo(userInfo);
          _logger.d('사용자 프로필 로드 완료: ${userInfo.name}');
        } else {
          errorMessage.value = userInfo.message ?? '사용자 정보를 가져올 수 없습니다.';
          _logger.e('사용자 정보 API 응답 실패: ${userInfo.message}');
        }
      } else {
        errorMessage.value = response.message ?? '서버 오류가 발생했습니다.';
        _logger.e('사용자 정보 API 호출 실패: ${response.message}');
      }

    } catch (e) {
      errorMessage.value = '네트워크 오류가 발생했습니다.';
      _logger.e('사용자 프로필 로드 오류: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 프로필 새로고침
  Future<void> refreshProfile() async {
    await loadUserProfile();
  }

  void goToActivity() {
    Get.toNamed('/activity');
  }

  // 로그아웃, 계정탈퇴 등 추가
  void logout() {}
  void withdrawAccount() {}
}