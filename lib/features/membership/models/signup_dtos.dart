// 회원가입 관련 모든 DTO를 하나의 파일에 정의

/// 회원가입 요청 DTO
class SignupRequestDto {
  final String loginId;
  final String password;
  final String phone;
  final String email;
  final String name;
  final String role;
  final String provider;
  final String providerId;
  final List<EducationRequestDto> educations;

  SignupRequestDto({
    required this.loginId,
    required this.password,
    required this.phone,
    required this.email,
    required this.name,
    this.role = 'ROLE_USER',
    this.provider = '',
    this.providerId = '',
    required this.educations,
  });

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'password': password,
      'phone': phone,
      'email': email,
      'name': name,
      'role': role,
      'provider': provider,
      'providerId': providerId,
      'educations': educations.map((e) => e.toJson()).toList(),
    };
  }
}

/// 학력 정보 요청 DTO
class EducationRequestDto {
  final int id;
  final String school;
  final String major;
  final String grade;
  final String userId;

  EducationRequestDto({
    this.id = 0,
    required this.school,
    required this.major,
    required this.grade,
    this.userId = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school': school,
      'major': major,
      'grade': grade,
      'userId': userId,
    };
  }
}

/// 회원가입 응답 DTO
class SignupResponseDto {
  final String status;
  final String message;
  final int userId;
  final int educationId;

  SignupResponseDto({
    required this.status,
    required this.message,
    required this.userId,
    required this.educationId,
  });

  factory SignupResponseDto.fromJson(Map<String, dynamic> json) {
    return SignupResponseDto(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      userId: json['userId'] ?? 0,
      educationId: json['educationId'] ?? 0,
    );
  }
}