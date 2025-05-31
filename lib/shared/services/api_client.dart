import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../../core/constants/api_constants.dart';

/// 간단한 API 클라이언트 (회원가입용)
class ApiClient {
  final Logger _logger = Logger();
  final http.Client _client = http.Client();

  // 싱글톤 패턴
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  /// POST 요청 (회원가입용)
  Future<ApiResponse<T>> post<T>(
      String endpoint, {
        Object? body,
        T Function(Map<String, dynamic>)? fromJson,
      }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final requestBody = body != null ? jsonEncode(body) : null;

      _logger.d('POST 요청: $uri');
      _logger.d('요청 본문: $requestBody');

      final response = await _client.post(
        uri,
        headers: headers,
        body: requestBody,
      ).timeout(const Duration(seconds: 30));

      _logger.d('응답 상태: ${response.statusCode}');
      _logger.d('응답 본문: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 성공
        if (response.body.isEmpty) {
          return ApiResponse.success(null as T);
        }

        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (fromJson != null) {
          final data = fromJson(responseData);
          return ApiResponse.success(data);
        } else {
          return ApiResponse.success(responseData as T);
        }
      } else {
        // 실패
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
    } catch (e) {
      _logger.e('POST 요청 오류: $e');
      return ApiResponse.error(
        message: '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
        statusCode: 0,
      );
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