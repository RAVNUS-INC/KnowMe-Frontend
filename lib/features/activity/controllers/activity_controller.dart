import 'package:get/get.dart';
import '../models/activity_record.dart';
import '../services/activity_service.dart';
import '../../../features/membership/repositories/auth_repository.dart';  // ✅ 새로 추가
import 'package:flutter/material.dart';

class ActivityController extends GetxController {
  // 로딩 상태 관리
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // ✅ 수정: 사용자 ID를 동적으로 관리
  var userId = 0.obs; // Rx로 변경하여 반응형으로 관리

  // AuthRepository 인스턴스 추가
  final AuthRepository _authRepository = AuthRepository();

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
    _initializeUserId();
  }

  /// ✅ 새로 추가: 사용자 ID 초기화 및 활동 데이터 로드
  Future<void> _initializeUserId() async {
    try {
      // 저장된 사용자 ID 가져오기
      final savedUserId = await _authRepository.getUserId();

      if (savedUserId != null && savedUserId > 0) {
        userId.value = savedUserId;
        // 사용자 ID가 있으면 활동 데이터 로드
        await loadUserActivity();
      } else {
        // 사용자 ID가 없으면 로그인되지 않은 상태
        print('Warning: 사용자 ID가 없습니다. 로그인이 필요합니다.');
        errorMessage.value = '로그인이 필요합니다.';
      }
    } catch (e) {
      print('Error initializing user ID: $e');
      errorMessage.value = '사용자 정보를 불러올 수 없습니다.';
    }
  }

  /// ✅ 새로 추가: 외부에서 사용자 ID를 업데이트하는 메서드
  Future<void> updateUserId(int newUserId) async {
    if (newUserId > 0 && userId.value != newUserId) {
      userId.value = newUserId;
      // 새로운 사용자 ID로 활동 데이터 다시 로드
      await loadUserActivity();
    }
  }

  /// 사용자 활동 데이터를 로드합니다
  Future<void> loadUserActivity() async {
    // 사용자 ID가 유효하지 않으면 로드하지 않음
    if (userId.value <= 0) {
      errorMessage.value = '유효하지 않은 사용자 ID입니다.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ActivityService.getUserActivity(userId.value);
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
    if (userId.value <= 0) {
      print('Error: Invalid user ID for delete operation');
      return false;
    }

    try {
      // 서버에서 삭제
      final success =
      await ActivityService.deleteActivity(userId.value, project.portfolioId);

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
    if (userId.value <= 0) {
      detailErrorMessage.value = '유효하지 않은 사용자 ID입니다.';
      return;
    }

    try {
      isLoadingDetail.value = true;
      detailErrorMessage.value = '';

      final detail = await ActivityService.getProjectDetail(userId.value, activityId);
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
    if (userId.value <= 0) {
      createErrorMessage.value = '유효하지 않은 사용자 ID입니다.';
      return false;
    }

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

      final success = await ActivityService.createActivity(userId.value, request);

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
  /// ✅ 수정: 활동을 수정하고 즉시 데이터 동기화
  Future<bool> updateActivity({
    required int activityId,
    required String title,
    required String description,
    required String content,
    required List<String> tags,
    String? visibility,
  }) async {
    if (userId.value <= 0) {
      createErrorMessage.value = '유효하지 않은 사용자 ID입니다.';
      return false;
    }

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
        userId.value,
        activityId,
        request,
      );

      if (success) {
        // ✅ 수정 성공 시 즉시 데이터 동기화
        await _updateLocalData(activityId, title, description, content, tags);
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

  /// ✅ 새로 추가: 로컬 데이터 즉시 업데이트
  Future<void> _updateLocalData(
      int activityId,
      String title,
      String description,
      String content,
      List<String> tags,
      ) async {
    try {
      // 1. 목록 데이터 즉시 업데이트
      if (activityResponse.value != null) {
        final updatedPortfolios = activityResponse.value!.portfolios.map((project) {
          if (project.portfolioId == activityId) {
            return Project(
              portfolioId: project.portfolioId,
              title: title,
              description: description,
              content: content,
              visibility: project.visibility,
              tags: tags,
              createdAt: project.createdAt,
              updatedAt: DateTime.now().toIso8601String(),
            );
          }
          return project;
        }).toList();

        activityResponse.value = ActivityResponse(
          userId: activityResponse.value!.userId,
          portfolios: updatedPortfolios,
        );

        // 태그 목록 업데이트
        final allTags = <String>{};
        for (final project in updatedPortfolios) {
          allTags.addAll(project.tags);
        }
        availableTags.value = allTags.toList()..sort();
      }

      // 2. 상세 데이터도 즉시 업데이트 (상세 화면이 열려있는 경우)
      if (projectDetail.value != null && projectDetail.value!.id == activityId) {
        projectDetail.value = ProjectDetail(
          id: activityId,
          title: title,
          description: description,
          content: content,
          tags: tags,
          visibility: projectDetail.value!.visibility,
          createdAt: projectDetail.value!.createdAt,
          updatedAt: DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      print('Error updating local data: $e');
      // 로컬 업데이트 실패 시 서버에서 다시 로드
      await loadUserActivity();
      if (projectDetail.value?.id == activityId) {
        await loadProjectDetail(activityId);
      }
    }
  }
}