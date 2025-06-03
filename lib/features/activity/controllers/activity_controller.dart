import 'package:get/get.dart';
import '../models/activity_record.dart';
import '../services/activity_service.dart';
import 'package:flutter/material.dart';

class ActivityController extends GetxController {
  // 로딩 상태 관리
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // 사용자 ID (실제 앱에서는 인증 시스템에서 가져와야 함)
  final int userId = 2; // TODO: 실제 로그인한 사용자 ID로 변경

  // 활동 데이터
  var activityResponse = Rxn<ActivityResponse>();
  // 프로젝트 상세 데이터
  var projectDetail = Rxn<ProjectDetail>();
  var isLoadingDetail = false.obs;
  var detailErrorMessage = ''.obs;

  // 활동 생성/추가 상태 관리
  var isCreatingActivity = false.obs;
  var createErrorMessage = ''.obs;

  // 필터링을 위한 태그들 (서버 데이터에 따라 동적으로 업데이트됨)
  var availableTags = <String>[].obs;
  var selectedTag = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadUserActivity();
  }

  /// 사용자 활동 데이터를 로드합니다
  Future<void> loadUserActivity() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ActivityService.getUserActivity(userId);
      activityResponse.value = response;

      // 모든 프로젝트의 태그들을 수집하여 필터 태그 목록 생성
      final tags = <String>{};
      for (final project in response.portfolios) {
        tags.addAll(project.tags);
      }
      availableTags.value = tags.toList()..sort();
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error loading user activity: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 새로고침
  Future<void> refreshActivity() async {
    await loadUserActivity();
  }

  /// 필터링된 프로젝트 목록을 반환합니다
  List<Project> get visibleProjects {
    if (activityResponse.value == null) return [];

    final projects = activityResponse.value!.portfolios;

    if (selectedTag.value == null) {
      return projects;
    } else {
      return projects.where((p) => p.tags.contains(selectedTag.value)).toList();
    }
  }

  /// 태그 선택/해제
  void selectTag(String? tag) {
    selectedTag.value = tag;
  }

  /// 프로젝트 삭제 (서버 API 호출)
  Future<bool> removeProject(Project project) async {
    try {
      // 서버에서 삭제
      final success =
          await ActivityService.deleteActivity(userId, project.portfolioId);

      if (success && activityResponse.value != null) {
        // 로컬 데이터에서도 제거
        final updatedPortfolios =
            List<Project>.from(activityResponse.value!.portfolios);
        updatedPortfolios
            .removeWhere((p) => p.portfolioId == project.portfolioId);

        activityResponse.value = ActivityResponse(
          userId: activityResponse.value!.userId,
          portfolios: updatedPortfolios,
        );

        // 태그 목록 업데이트
        final tags = <String>{};
        for (final proj in updatedPortfolios) {
          tags.addAll(proj.tags);
        }
        availableTags.value = tags.toList()..sort();

        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting project: $e');
      return false;
    }
  }

  // 프로젝트 편집용 컨트롤러들
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final contentController = TextEditingController();
  final tagController = TextEditingController();

  /// 프로젝트 편집을 위해 데이터를 로드합니다
  void loadProjectForEdit(Project? project) {
    if (project != null) {
      titleController.text = project.title;
      descController.text = project.description;
      contentController.text = project.content;
      tagController.text = project.tags.join(', ');
    } else {
      titleController.clear();
      descController.clear();
      contentController.clear();
      tagController.clear();
    }
  }

  /// 프로젝트 상세 정보를 로드합니다
  Future<void> loadProjectDetail(int activityId) async {
    try {
      isLoadingDetail.value = true;
      detailErrorMessage.value = '';

      final detail = await ActivityService.getProjectDetail(userId, activityId);
      projectDetail.value = detail;
    } catch (e) {
      detailErrorMessage.value = e.toString();
      print('Error loading project detail: $e');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  /// 프로젝트 상세 데이터 새로고침
  Future<void> refreshProjectDetail(int activityId) async {
    await loadProjectDetail(activityId);
  }

  /// 새로운 활동을 생성합니다
  /// [title] 활동 제목
  /// [description] 활동 요약
  /// [content] 활동 내용
  /// [tags] 활동 태그 리스트
  /// Returns [bool] 생성 성공 여부
  Future<bool> createActivity({
    required String title,
    required String description,
    required String content,
    required List<String> tags,
  }) async {
    try {
      isCreatingActivity.value = true;
      createErrorMessage.value = '';

      final request = CreateActivityRequest(
        title: title,
        description: description,
        content: content,
        tags: tags,
        visibility: null, // NULL로 전달
      );

      final success = await ActivityService.createActivity(userId, request);

      if (success) {
        // 활동 생성 성공 시 목록 새로고침
        await loadUserActivity();
        return true;
      }
      return false;
    } catch (e) {
      createErrorMessage.value = e.toString();
      print('Error creating activity: $e');
      return false;
    } finally {
      isCreatingActivity.value = false;
    }
  }

  /// 활동을 수정합니다
  Future<bool> updateActivity({
    required int activityId,
    required String title,
    required String description,
    required String content,
    required List<String> tags,
    String? visibility,
  }) async {
    try {
      isCreatingActivity.value = true;
      createErrorMessage.value = '';

      final request = UpdateActivityRequest(
        title: title,
        description: description,
        content: content,
        tags: tags,
        visibility: visibility,
      );

      final success = await ActivityService.updateActivity(
        userId,
        activityId,
        request,
      );

      if (success) {
        // 수정 성공 시 활동 목록을 다시 로드
        await loadUserActivity();
      }

      return success;
    } catch (e) {
      createErrorMessage.value = e.toString();
      return false;
    } finally {
      isCreatingActivity.value = false;
    }
  }

  /// 태그 문자열을 리스트로 파싱합니다
  /// 예: "태그1, 태그2, 태그3" -> ["태그1", "태그2", "태그3"]
  List<String> parseTagsFromString(String tagsString) {
    if (tagsString.trim().isEmpty) return [];

    return tagsString
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    contentController.dispose();
    tagController.dispose();
    super.onClose();
  }
}