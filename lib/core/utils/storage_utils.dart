import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

/// 로컬 저장소 관련 유틸리티
class StorageUtils {
  static const String _sessionKey = 'user_session';
  static const String _rememberMeKey = 'remember_me';
  static const String _savedCredentialsKey = 'saved_credentials';

  static final Logger _logger = Logger();

  /// 세션 정보 저장
  static Future<bool> saveSession(Map<String, dynamic> sessionData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(sessionData);
      final result = await prefs.setString(_sessionKey, jsonString);

      if (result) {
        _logger.d('세션 저장 완료');
      } else {
        _logger.e('세션 저장 실패');
      }

      return result;
    } catch (e) {
      _logger.e('세션 저장 오류: $e');
      return false;
    }
  }

  /// 세션 정보 로드
  static Future<Map<String, dynamic>?> getSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_sessionKey);

      if (jsonString != null) {
        final sessionData = jsonDecode(jsonString) as Map<String, dynamic>;
        _logger.d('세션 로드 완료');
        return sessionData;
      }

      _logger.d('저장된 세션 없음');
      return null;
    } catch (e) {
      _logger.e('세션 로드 오류: $e');
      return null;
    }
  }

  /// 세션 정보 삭제
  static Future<bool> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.remove(_sessionKey);

      if (result) {
        _logger.d('세션 삭제 완료');
      } else {
        _logger.e('세션 삭제 실패');
      }

      return result;
    } catch (e) {
      _logger.e('세션 삭제 오류: $e');
      return false;
    }
  }

  /// Remember Me 상태 저장
  static Future<bool> setRememberMe(bool remember) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_rememberMeKey, remember);
    } catch (e) {
      _logger.e('Remember Me 저장 오류: $e');
      return false;
    }
  }

  /// Remember Me 상태 로드
  static Future<bool> getRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      _logger.e('Remember Me 로드 오류: $e');
      return false;
    }
  }

  /// 로그인 정보 저장 (Remember Me용)
  static Future<bool> saveCredentials({
    required String loginId,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final credentials = {
        'loginId': loginId,
        'password': password,
      };
      final jsonString = jsonEncode(credentials);
      return await prefs.setString(_savedCredentialsKey, jsonString);
    } catch (e) {
      _logger.e('로그인 정보 저장 오류: $e');
      return false;
    }
  }

  /// 저장된 로그인 정보 로드
  static Future<Map<String, String>?> getSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_savedCredentialsKey);

      if (jsonString != null) {
        final credentials = jsonDecode(jsonString) as Map<String, dynamic>;
        return {
          'loginId': credentials['loginId'] as String,
          'password': credentials['password'] as String,
        };
      }

      return null;
    } catch (e) {
      _logger.e('로그인 정보 로드 오류: $e');
      return null;
    }
  }

  /// 저장된 로그인 정보 삭제
  static Future<bool> clearSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_savedCredentialsKey);
    } catch (e) {
      _logger.e('로그인 정보 삭제 오류: $e');
      return false;
    }
  }

  /// 모든 저장 데이터 삭제
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final results = await Future.wait([
        prefs.remove(_sessionKey),
        prefs.remove(_rememberMeKey),
        prefs.remove(_savedCredentialsKey),
      ]);

      final allSuccess = results.every((result) => result);

      if (allSuccess) {
        _logger.d('모든 저장 데이터 삭제 완료');
      } else {
        _logger.e('일부 저장 데이터 삭제 실패');
      }

      return allSuccess;
    } catch (e) {
      _logger.e('전체 데이터 삭제 오류: $e');
      return false;
    }
  }

  /// 특정 키의 문자열 데이터 저장
  static Future<bool> setString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(key, value);
    } catch (e) {
      _logger.e('문자열 저장 오류 ($key): $e');
      return false;
    }
  }

  /// 특정 키의 문자열 데이터 로드
  static Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      _logger.e('문자열 로드 오류 ($key): $e');
      return null;
    }
  }

  /// 특정 키의 불린 데이터 저장
  static Future<bool> setBool(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(key, value);
    } catch (e) {
      _logger.e('불린 저장 오류 ($key): $e');
      return false;
    }
  }

  /// 특정 키의 불린 데이터 로드
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      _logger.e('불린 로드 오류 ($key): $e');
      return defaultValue;
    }
  }

  /// 특정 키의 정수 데이터 저장
  static Future<bool> setInt(String key, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(key, value);
    } catch (e) {
      _logger.e('정수 저장 오류 ($key): $e');
      return false;
    }
  }

  /// 특정 키의 정수 데이터 로드
  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key) ?? defaultValue;
    } catch (e) {
      _logger.e('정수 로드 오류 ($key): $e');
      return defaultValue;
    }
  }
}