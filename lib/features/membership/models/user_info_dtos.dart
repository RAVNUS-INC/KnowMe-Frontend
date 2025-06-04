// 사용자 정보 관련 DTO 정의

/// 사용자 정보 조회 응답 DTO
class UserInfoResponseDto {
  final int id;
  final String loginId;
  final String name;
  final String email;
  final String phone;
  final String? status;  // nullable로 변경
  final String? message; // nullable로 변경

  UserInfoResponseDto({
    required this.id,
    required this.loginId,
    required this.name,
    required this.email,
    required this.phone,
    this.status,   // nullable로 변경
    this.message,  // nullable로 변경
  });

  factory UserInfoResponseDto.fromJson(Map<String, dynamic> json) {
    return UserInfoResponseDto(
      id: json['id'] as int? ?? 0,
      loginId: json['loginId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      status: json['status'] as String?,   // null 허용
      message: json['message'] as String?, // null 허용
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginId': loginId,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
      'message': message,
    };
  }

  /// ✅ 수정: 요청이 성공적으로 처리되었는지 확인
  /// HTTP 200 응답이고 id가 유효하면 성공으로 판단
  bool get isSuccess {
    // 1. status가 'success'이거나
    // 2. status가 null이지만 id가 유효한 경우 (실제 서버 응답 형태)
    return status == 'success' || (status == null && id > 0);
  }
}