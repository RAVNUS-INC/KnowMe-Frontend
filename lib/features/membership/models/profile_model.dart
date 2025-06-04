import '../models/user_info_dtos.dart';

class UserProfile {
  final String name;
  final String job;
  final String intro;
  final String university;
  final String email;

  UserProfile({
    required this.name,
    required this.job,
    required this.intro,
    required this.university,
    required this.email,
  });

  // API 응답에서 UserProfile 생성 (이름, 이메일만 실제 데이터, 나머지는 더미)
  factory UserProfile.fromUserInfo(UserInfoResponseDto userInfo) {
    return UserProfile(
      name: userInfo.name, // 실제 API 데이터
      job: '프론트엔드 개발자', // 더미 데이터 유지
      intro: '끊임없이 배우고 도전하는\n프론트엔드 개발자', // 더미 데이터 유지
      university: '한양대학교 ERICA\nICT융합학부 재학', // 더미 데이터 유지
      email: userInfo.email, // 실제 API 데이터
    );
  }
}

// 더미 프로필 데이터 (로딩 중 표시용)
final UserProfile defaultProfile = UserProfile(
  name: '사용자',
  job: '프론트엔드 개발자',
  intro: '끊임없이 배우고 도전하는\n프론트엔드 개발자',
  university: '한양대학교 ERICA\nICT융합학부 재학',
  email: 'loading@knowme.kr',
);

// 메뉴 항목
const List<String> profileMenuItems = [
  '프로필 수정',
  '비밀번호 변경',
  '소셜 연동',
  '멤버십 구독',
];