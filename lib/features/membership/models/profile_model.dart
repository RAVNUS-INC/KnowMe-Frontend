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
}

// 더미 프로필 데이터
final UserProfile dummyProfile = UserProfile(
  name: '이한양',
  job: '프론트엔드 개발자',
  intro: '끊임없이 배우고 도전하는\n프론트엔드 개발자',
  university: '한양대학교 ERICA\nICT융합학부 재학',
  email: 'adc1234@knowme.kr',
);

// 메뉴 항목
const List<String> profileMenuItems = [
  '프로필 수정',
  '비밀번호 변경',
  '소셜 연동',
  '멤버십 구독',
];