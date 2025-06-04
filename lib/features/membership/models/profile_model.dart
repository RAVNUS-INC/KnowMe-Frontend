class ProfileModel {
  final int id;
  final String loginId;
  final String name;
  final String email;
  final String phone;

  final String? job;
  final String? intro;
  final String? university;

  ProfileModel({
    this.id = 0,
    this.loginId = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.job,
    this.intro,
    this.university,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      loginId: json['loginId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      job: json['job'],
      intro: json['intro'],
      university: json['university'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginId': loginId,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

// 더미 프로필 데이터 (테스트용)
final ProfileModel dummyProfile = ProfileModel(
  id: 0,
  loginId: 'dummyLoginId',
  name: '이한양',
  email: 'adc1234@knowme.kr',
  phone: '010-1234-5678',
);

// 메뉴 항목
const List<String> profileMenuItems = [
  '프로필 수정',
  '비밀번호 변경',
  '소셜 연동',
  '멤버십 구독',
];