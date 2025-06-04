import 'package:dio/dio.dart';

class UserService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://server.tunnel.jaram.net', // 네 API 기본 주소로 변경
      headers: {
        'Content-Type': 'application/json',
        // 필요한 인증 토큰이 있다면 여기에 추가
        // 'Authorization': 'Bearer your_token',
      },
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
    ),
  );

  static Future<Response> getCurrentUser() {
    return _dio.get('/api/user/me');
  }
}