class SignupModel {
  // User agreement states
  bool agreeToAllTerms = false;
  bool agreeToServiceTerms = false;
  bool agreeToPrivacyPolicy = false;
  bool agreeToMarketingInfo = false;

  // User registration information
  String userId = '';
  String password = '';
  String passwordConfirm = '';
  String phoneNumber = '';
  String verificationCode = '';

  // Third page information
  String name = '';
  String emailPrefix = '';
  String emailDomain = '';

  // 학력 정보
  String schoolName = '';
  String major = '';
  String grade = '1학년';
  bool isCurrentlyEnrolled = false;

  String desiredPosition = '';

  // Validation states
  bool isIdValid = false;
  bool isPasswordValid = false;
  bool isPasswordConfirmValid = false;
  bool isPhoneValid = false;
  bool isPhoneVerified = false;
  bool isNameValid = false;
  bool isEmailValid = false;
  bool isEducationValid = false;
  bool isDesiredPositionValid = false;

  // Password visibility states
  bool obscurePassword = false;
  bool obscurePasswordConfirm = false;

  // 정적 데이터 목록 - 드롭다운 옵션
  static final List<String> emailDomains = [
    '직접입력',
    'gmail.com',
    'naver.com',
    'daum.net',
    'hotmail.com'
  ];

  static final List<String> grades = ['1학년', '2학년', '3학년', '4학년'];

  static final List<String> positions = [
    '전체',
    '개발',
    '마케팅/광고',
    '경영/비즈니스',
    '디자인',
    '서비스',
    '영업',
    '설계/엔지니어링',
    'HR',
    '생산',
    '의료/제약/바이오',
    '금융',
    '미디어',
    '교육',
    '식품',
    '공공/복지',
    '건설/시설',
    '기타'
  ];

  // Getters for button states
  bool get isFirstNextButtonEnabled =>
      agreeToServiceTerms && agreeToPrivacyPolicy;

  bool get isSecondNextButtonEnabled =>
      isIdValid && isPasswordValid && isPasswordConfirmValid && isPhoneValid;

  bool get isThirdNextButtonEnabled =>
      isNameValid && isEmailValid && isEducationValid && isDesiredPositionValid;

  // 회원가입 완료 데이터를 Map으로 반환
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'password': password,
      'name': name,
      'email': '$emailPrefix@$emailDomain',
      'phoneNumber': phoneNumber,
      'education': {
        'schoolName': schoolName,
        'major': major,
        'grade': grade,
        'isCurrentlyEnrolled': isCurrentlyEnrolled,
      },
      'desiredPosition': desiredPosition,
      'marketingConsent': agreeToMarketingInfo,
    };
  }
}
