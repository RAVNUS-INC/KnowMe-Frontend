import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/post_api_constants.dart';

/// API 클라이언트 - 인증 헤더 지원
class ApiClient {
  final Logger _logger = Logger();
  final http.Client _client = http.Client();

  // 싱글톤 패턴
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  /// 기본 헤더 생성
  Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      // 토큰을 가져와서 추가
      final authToken = await _getAuthHeaderTokenDirect();
      if (authToken != null) {
        headers['Authorization'] = authToken;
      }
    }

    return headers;
  }

  /// 직접 토큰을 가져오는 메서드 (순환 의존성 방지)
  Future<String?> _getAuthHeaderTokenDirect() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token != null && token.isNotEmpty) {
        // 중요: 공백 제거하여 토큰 문제 해결
        final cleanToken = token.trim();
        _logger.d('사용할 토큰 (공백 제거 후): $cleanToken');
        return 'Bearer $cleanToken';
      }
      return null;
    } catch (e) {
      _logger.e('토큰 로드 오류: $e');
      return null;
    }
  }

  /// POST 요청
  Future<ApiResponse<T>> post<T>(
      String endpoint, {
        Object? body,
        T Function(Map<String, dynamic>)? fromJson,
        bool requireAuth = false,
      }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);
      final requestBody = body != null ? jsonEncode(body) : null;

      _logger.d('POST 요청: $uri');
      _logger.d('요청 헤더: $headers');
      _logger.d('요청 본문: $requestBody');

      final response = await _client.post(
        uri,
        headers: headers,
        body: requestBody,
      ).timeout(const Duration(seconds: 30));

      _logger.d('응답 상태: ${response.statusCode}');
      _logger.d('응답 본문: ${response.body}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      _logger.e('POST 요청 오류: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
        statusCode: 0,
      );
    }
  }

  /// GET 요청
  Future<ApiResponse<T>> get<T>(
      String endpoint, {
        Map<String, String>? queryParameters,
        T Function(Map<String, dynamic>)? fromJson,
        bool requireAuth = true,
      }) async {
    try {
      Uri uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      final headers = await _getHeaders(requireAuth: requireAuth);

      _logger.d('GET 요청: $uri');
      _logger.d('요청 헤더: $headers');

      final response = await _client.get(
        uri,
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      _logger.d('응답 상태: ${response.statusCode}');
      _logger.d('응답 본문: ${response.body}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      _logger.e('GET 요청 오류: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
        statusCode: 0,
      );
    }
  }

  /// PUT 요청
  Future<ApiResponse<T>> put<T>(
      String endpoint, {
        Object? body,
        T Function(Map<String, dynamic>)? fromJson,
        bool requireAuth = true,
      }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);
      final requestBody = body != null ? jsonEncode(body) : null;

      _logger.d('PUT 요청: $uri');
      _logger.d('요청 헤더: $headers');
      _logger.d('요청 본문: $requestBody');

      final response = await _client.put(
        uri,
        headers: headers,
        body: requestBody,
      ).timeout(const Duration(seconds: 30));

      _logger.d('응답 상태: ${response.statusCode}');
      _logger.d('응답 본문: ${response.body}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      _logger.e('PUT 요청 오류: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
        statusCode: 0,
      );
    }
  }

  /// DELETE 요청
  Future<ApiResponse<T>> delete<T>(
      String endpoint, {
        T Function(Map<String, dynamic>)? fromJson,
        bool requireAuth = true,
      }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);

      _logger.d('DELETE 요청: $uri');
      _logger.d('요청 헤더: $headers');

      final response = await _client.delete(
        uri,
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      _logger.d('응답 상태: ${response.statusCode}');
      _logger.d('응답 본문: ${response.body}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      _logger.e('DELETE 요청 오류: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
        statusCode: 0,
      );
    }
  }

  /// POST 요청 - PostApiConstants 사용
  Future<ApiResponse<T>> postWithPostApi<T>(
      String endpoint, {
        Object? body,
        T Function(Map<String, dynamic>)? fromJson,
        bool requireAuth = false,
      }) async {
    try {
      final uri = Uri.parse('${PostApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);
      final requestBody = body != null ? jsonEncode(body) : null;

      _logger.d('POST 요청 (PostAPI): $uri');
      _logger.d('요청 헤더: $headers');
      _logger.d('요청 본문: $requestBody');

      final response = await _client.post(
        uri,
        headers: headers,
        body: requestBody,
      ).timeout(const Duration(seconds: 30));

      _logger.d('응답 상태: ${response.statusCode}');
      _logger.d('응답 본문: ${response.body}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      _logger.e('POST 요청 오류: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
        statusCode: 0,
      );
    }
  }

  /// GET 요청 - PostApiConstants 사용
  Future<ApiResponse<T>> getWithPostApi<T>(
      String endpoint, {
        Map<String, String>? queryParameters,
        T Function(Map<String, dynamic>)? fromJson,
        bool requireAuth = true,
      }) async {
    try {
      Uri uri = Uri.parse('${PostApiConstants.baseUrl}$endpoint');
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      final headers = await _getHeaders(requireAuth: requireAuth);

      _logger.d('GET 요청 (PostAPI): $uri');
      _logger.d('요청 헤더: $headers');

      // 디버깅: StoredToken 확인
      if (requireAuth) {
        final prefs = await SharedPreferences.getInstance();
        final storedToken = prefs.getString('jwt_token');
        _logger.d('저장된 원본 토큰: $storedToken');
      }

      final response = await _client.get(
        uri,
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      _logger.d('응답 상태: ${response.statusCode}');
      _logger.d('응답 본문: ${response.body}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      _logger.e('GET 요청 오류: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
        statusCode: 0,
      );
    }
  }

  /// DELETE 요청 - PostApiConstants 사용
  Future<ApiResponse<T>> deleteWithPostApi<T>(
      String endpoint, {
        T Function(Map<String, dynamic>)? fromJson,
        bool requireAuth = true,
      }) async {
    try {
      final uri = Uri.parse('${PostApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);

      _logger.d('DELETE 요청 (PostAPI): $uri');
      _logger.d('요청 헤더: $headers');

      final response = await _client.delete(
        uri,
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      _logger.d('응답 상태: ${response.statusCode}');
      _logger.d('응답 본문: ${response.body}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      _logger.e('DELETE 요청 오류: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
        statusCode: 0,
      );
    }
  }

  /// PUT 요청 - PostApiConstants 사용
  Future<ApiResponse<T>> putWithPostApi<T>(
      String endpoint, {
        Object? body,
        T Function(Map<String, dynamic>)? fromJson,
        bool requireAuth = true,
      }) async {
    try {
      final uri = Uri.parse('${PostApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);
      final requestBody = body != null ? jsonEncode(body) : null;

      _logger.d('PUT 요청 (PostAPI): $uri');
      _logger.d('요청 헤더: $headers');
      _logger.d('요청 본문: $requestBody');

      final response = await _client.put(
        uri,
        headers: headers,
        body: requestBody,
      ).timeout(const Duration(seconds: 30));

      _logger.d('응답 상태: ${response.statusCode}');
      _logger.d('응답 본문: ${response.body}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      _logger.e('PUT 요청 오류: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
        statusCode: 0,
      );
    }
  }

  /// 응답 처리
  ApiResponse<T> _handleResponse<T>(
      http.Response response,
      T Function(Map<String, dynamic>)? fromJson,
      ) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      // 성공
      if (response.body.isEmpty) {
        return ApiResponse.success(null as T);
      }

      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (fromJson != null) {
          final data = fromJson(responseData);
          return ApiResponse.success(data);
        } else {
          return ApiResponse.success(responseData as T);
        }
      } catch (e) {
        _logger.e('응답 파싱 오류: $e');
        return ApiResponse.error(
          message: '응답 데이터 처리 중 오류가 발생했습니다.',
          statusCode: response.statusCode,
        );
      }
    } else if (response.statusCode == 401) {
      // 토큰 만료나 인증 오류일 경우
      _logger.w('인증 오류 발생 (401): JWT 토큰에 문제가 있을 수 있습니다');
      
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final message = responseData['message'] ?? '인증에 실패했습니다.';
        
        // JWT 공백 문제가 발견되면 저장된 토큰 정리
        if (message.toString().contains('whitespace')) {
          _cleanStoredToken();
        }
        
        return ApiResponse.error(
          message: message,
          statusCode: response.statusCode,
        );
      } catch (e) {
        return ApiResponse.error(
          message: '인증에 실패했습니다.',
          statusCode: response.statusCode,
        );
      }
    } else {
      // 기타 오류
      try {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return ApiResponse.error(
          message: errorData['message'] ?? '요청 처리 중 오류가 발생했습니다.',
          statusCode: response.statusCode,
        );
      } catch (e) {
        return ApiResponse.error(
          message: 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }
    }
  }
  
  /// 토큰 공백 문제 해결을 위한 저장된 토큰 정리
  Future<void> _cleanStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      
      if (token != null) {
        // 공백 제거 후 다시 저장
        final cleanToken = token.trim();
        
        if (cleanToken != token) {
          _logger.i('토큰 공백 제거 및 재저장');
          await prefs.setString('jwt_token', cleanToken);
        }
      }
    } catch (e) {
      _logger.e('토큰 정리 중 오류: $e');
    }
  }

  /// 리소스 해제
  void dispose() {
    _client.close();
  }
}

/// API 응답 래퍼 클래스
class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse._({
    required this.isSuccess,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse._(
      isSuccess: true,
      data: data,
    );
  }

  factory ApiResponse.error({
    required String message,
    required int statusCode,
  }) {
    return ApiResponse._(
      isSuccess: false,
      message: message,
      statusCode: statusCode,
    );
  }
}
