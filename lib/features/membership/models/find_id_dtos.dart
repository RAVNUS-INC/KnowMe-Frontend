// 아이디 찾기 관련 DTO 정의

/// 아이디 찾기 요청 DTO
class FindIdRequestDto {
  final String? email;
  final String? phone;

  FindIdRequestDto({
    this.email,
    this.phone,
  });

  /// ✅ 핵심 수정: 실제로 사용하는 필드만 JSON에 포함
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // 이메일로 찾기인 경우 - email만 포함
    if (email != null && email!.isNotEmpty) {
      data['email'] = email;
    }

    // 휴대폰으로 찾기인 경우 - phone만 포함
    if (phone != null && phone!.isNotEmpty) {
      data['phone'] = phone;
    }

    return data;
  }
}

/// 아이디 찾기 응답 DTO
class FindIdResponseDto {
  final String status;
  final String message;
  final String? loginId;

  FindIdResponseDto({
    required this.status,
    required this.message,
    this.loginId,
  });

  factory FindIdResponseDto.fromJson(Map<String, dynamic> json) {
    return FindIdResponseDto(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      loginId: json['loginId'],
    );
  }

  /// ✅ 수정: 더 유연한 성공 판정
  bool get isSuccess {
    // 1. loginId가 null이 아니고 비어있지 않으면 성공
    if (loginId != null && loginId!.isNotEmpty) {
      return true;
    }

    // 2. status가 "success"이면 성공
    if (status.toLowerCase() == 'success') {
      return true;
    }

    return false;
  }

  /// 찾은 아이디 반환 (성공시에만)
  String get foundLoginId => loginId ?? '';
}