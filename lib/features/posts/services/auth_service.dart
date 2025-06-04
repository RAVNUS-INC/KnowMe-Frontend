// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:logger/logger.dart';
//
// class AuthService {
//   final Logger _logger = Logger();
//
//   // 싱글톤 패턴
//   static final AuthService _instance = AuthService._internal();
//   factory AuthService() => _instance;
//   AuthService._internal();
//
//   /// 토큰 저장 기능
//   Future<void> saveToken(String token) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       // 토큰 저장 전 공백 제거
//       final cleanToken = token.trim();
//       await prefs.setString('jwt_token', cleanToken);
//       _logger.i('토큰 저장 성공');
//     } catch (e) {
//       _logger.e('토큰 저장 오류: $e');
//       throw Exception('토큰을 저장하는 데 실패했습니다');
//     }
//   }
//
//   /// 토큰 가져오기
//   Future<String?> getToken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('jwt_token');
//       return token;
//     } catch (e) {
//       _logger.e('토큰 로드 오류: $e');
//       return null;
//     }
//   }
//
//   /// 토큰 삭제 (로그아웃)
//   Future<void> deleteToken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('jwt_token');
//       _logger.i('토큰 삭제 성공');
//     } catch (e) {
//       _logger.e('토큰 삭제 오류: $e');
//       throw Exception('토큰을 삭제하는 데 실패했습니다');
//     }
//   }
//
//   /// 로그인 상태 확인
//   Future<bool> isLoggedIn() async {
//     final token = await getToken();
//     return token != null && token.isNotEmpty;
//   }
// }
