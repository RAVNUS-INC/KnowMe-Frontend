// 비밀번호 재설정 관련 DTO 정의

/// 비밀번호 재설정 요청 DTO
class PasswordResetRequestDto {
  final String loginId;
  final String password;

  PasswordResetRequestDto({
    required this.loginId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'password': password,
    };
  }
}

/// 비밀번호 재설정 응답 DTO
class PasswordResetResponseDto {
  final String status;
  final String message;

  PasswordResetResponseDto({
    required this.status,
    required this.message,
  });

  factory PasswordResetResponseDto.fromJson(Map<String, dynamic> json) {
    return PasswordResetResponseDto(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }

  /// 재설정 성공 여부 확인
  bool get isSuccess => status == 'success';
}