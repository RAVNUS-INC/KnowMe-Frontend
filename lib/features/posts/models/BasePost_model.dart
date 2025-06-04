import 'package:knowme_frontend/features/posts/models/contests_model.dart';

// 📄 base_post.dart
abstract class BasePost {
  final int postId;
  final String category;
  final String title;
  final String company;
  final String companyIntro;
  final String externalIntro;
  final String content;
  final String image;
  final String location;
  final String jobTitle;
  final int experience;
  final String education;
  final String activityField;
  final int activityDuration;
  final String hostingOrganization;
  final String onlineOrOffline;
  final String targetAudience;
  final String contestBenefits;
  final DateTime createdAt;
  final DateTime updatedAt;

  BasePost({
    required this.postId,
    required this.category,
    required this.title,
    required this.company,
    required this.companyIntro,
    required this.externalIntro,
    required this.content,
    required this.image,
    required this.location,
    required this.jobTitle,
    required this.experience,
    required this.education,
    required this.activityField,
    required this.activityDuration,
    required this.hostingOrganization,
    required this.onlineOrOffline,
    required this.targetAudience,
    required this.contestBenefits,
    required this.createdAt,
    required this.updatedAt,
  });

  String getValidImageUrl() {
    // 이미지가 있고 HTTP URL인 경우에만 사용
    if (image.isNotEmpty &&
        (image.startsWith('http://') || image.startsWith('https://'))) {
      return image;
    }

    // 없거나 유효하지 않으면 기본 이미지 사용
    return 'assets/images/whitepage.svg';
  }


  Map<String, dynamic> toJson();

  Contest toContest();
}

// @override
// String toString() {
//   return 'EmployeePost(postId: $postId, title: $title, company: $company, jobTitle: $jobTitle, experience: $experience, location: $location)';
// }

// 아래에 있는 각 post 클래스는 BasePost를 상속
// 각 탭별 모델은 아래 파일들로 분리해서 작성
// - employee_post.dart
// - intern_post.dart
// - activity_post.dart
// - lecture_post.dart
// - contest_post.dart

// 모든 파일 구조와 구현 방식은 동일하며
// 차이는 class명과 파일명 정도임