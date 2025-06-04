import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_record.dart';

/// 활동 생성 요청 모델
class CreateActivityRequest {
  final String title;
  final String description;
  final String content;
  final List<String> tags;
  final String? visibility;

  const CreateActivityRequest({
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
    this.visibility,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'tags': tags,
      'visibility': visibility,
    };
  }
}

/// 활동 수정 요청 모델
class UpdateActivityRequest {
  final String title;
  final String description;
  final String content;
  final List<String> tags;
  final String? visibility;

  const UpdateActivityRequest({
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
    this.visibility,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'tags': tags,
      'visibility': visibility,
    };
  }
}

class ActivityService {
  static const String _baseUrl = 'http://server.tunnel.jaram.net';

  /// 사용자의 활동 데이터를 가져옵니다.
  ///
  /// [userId] 사용자 ID
  ///
  /// Returns [ActivityResponse] 사용자의 포트폴리오 목록을 포함한 응답
  ///
  /// Throws [Exception] API 호출 실패 시
  static Future<ActivityResponse> getUserActivity(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/$userId/activity'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return ActivityResponse.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load user activity: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching user activity: $e');
    }
  }

  /// 특정 활동의 상세 정보를 가져옵니다.
  ///
  /// [userId] 사용자 ID
  /// [activityId] 활동 ID
  ///
  /// Returns [ProjectDetail] 활동 상세 정보
  ///
  /// Throws [Exception] API 호출 실패 시
  static Future<ProjectDetail> getProjectDetail(
      int userId, int activityId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/$userId/activity/$activityId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return ProjectDetail.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load project detail: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching project detail: $e');
    }
  }

  /// 특정 활동을 삭제합니다.
  ///
  /// [userId] 사용자 ID
  /// [activityId] 삭제할 활동 ID
  ///
  /// Returns [bool] 삭제 성공 여부
  ///
  /// Throws [Exception] API 호출 실패 시
  static Future<bool> deleteActivity(int userId, int activityId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/users/$userId/activity/$activityId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
            'Failed to delete activity: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting activity: $e');
    }
  }

  /// 새로운 활동을 생성합니다.
  ///
  /// [userId] 사용자 ID
  /// [request] 활동 생성 요청 데이터
  ///
  /// Returns [bool] 생성 성공 여부
  ///
  /// Throws [Exception] API 호출 실패 시
  static Future<bool> createActivity(
      int userId, CreateActivityRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/users/$userId/activity'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Failed to create activity: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating activity: $e');
    }
  }

  /// 활동을 수정합니다.
  ///
  /// [userId] 사용자 ID
  /// [activityId] 수정할 활동 ID
  /// [request] 수정할 활동 데이터
  ///
  /// Returns [bool] 수정 성공 여부
  ///
  /// Throws [Exception] API 호출 실패 시
  static Future<bool> updateActivity(
    int userId,
    int activityId,
    UpdateActivityRequest request,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/api/users/$userId/activity/$activityId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Failed to update activity: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating activity: $e');
    }
  }
}