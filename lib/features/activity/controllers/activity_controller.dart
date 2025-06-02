import 'package:get/get.dart';
import '../models/activity_record.dart';
import 'package:flutter/material.dart';

class ActivityController extends GetxController {
  final filterTags = [
    'React',
    'Firebase',
    'ResponsiveUI',
    'TailwindCSS',
    'TypeScript',
    'API\\u연동',
  ];

  var selectedTag = RxnString();

  // TODO : 더미데이터 삭제 예정
  final projects = <Project>[
    Project(
      title: 'MyPlanner – 일정 관리 웹앱',
      description: 'React와 Firebase로 만든 개인 일정 관리 서비스',
      tags: ['React', 'Firebase', 'ResponsiveUI'],
      date: '2025.03.28',
    ),
    Project(
      title: 'Shopixel – 반응형 이커머스 프론트엔드',
      description: 'SCSS와 JavaScript로 만든 쇼핑몰 웹사이트',
      tags: ['ResponsiveUI', 'VanillaJS', 'SCSS'],
      date: '2024.10.02',
    ),
    Project(
      title: '코딩톡 – 개발자 커뮤니티 SPA',
      description: 'Next.js 기반의 소셜 피드형 커뮤니티',
      tags: ['React', 'TailwindCSS', 'TypeScript'],
      date: '2024.08.12',
    ),
    Project(
      title: 'DevBoard – 개발자 대시보드',
      description: 'Github API 기반의 개인 프로젝트 관리 대시보드',
      tags: ['React', 'API\\u연동', 'ResponsiveUI'],
      date: '2024.06.05',
    ),
    Project(
      title: '모두의 날씨 – 실시간 날씨 조회 앱',
      description: 'OpenWeather API 연동과 사용자 경험 중심 UI',
      tags: ['React', 'API\\u연동', 'ResponsiveUI'],
      date: '2024.02.10',
    ),
  ];

  List<Project> get visibleProjects =>
      selectedTag.value == null
          ? projects
          : projects.where((p) => p.tags.contains(selectedTag.value)).toList();

  void selectTag(String? tag) {
    selectedTag.value = tag;
  }

  void removeProject(Project project) {
    projects.remove(project);
  }

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final sumController = TextEditingController();
  final tagController = TextEditingController();

  void loadProjectForEdit(Project? project) {
    if (project != null) {
      titleController.text = project.title;
      descController.text = project.description;
      sumController.text = project.summary ?? '';
      tagController.text = ''; // 필요 시 별도 처리
    } else {
      titleController.clear();
      descController.clear();
      sumController.clear();
      tagController.clear();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    sumController.dispose();
    tagController.dispose();
    super.onClose();
  }
}