import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import 'package:knowme_frontend/features/posts/models/post_tabs/basepost_model.dart';

class SavedPostResponse {
  final int id;
  final int userId;
  final BasePost post;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavedPostResponse({
    required this.id,
    required this.userId,
    required this.post,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SavedPostResponse.fromJson(Map<String, dynamic> json) {
    return SavedPostResponse(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      post: _parsePost(json['post']),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  static BasePost _parsePost(Map<String, dynamic>? postJson) {
    if (postJson == null) return GetSavedPosts.empty();
    
    return GetSavedPosts(
      postId: postJson['post_id'] ?? 0,
      category: postJson['category'] ?? '',
      title: postJson['title'] ?? '',
      company: postJson['company'] ?? '',
      companyIntro: postJson['company_intro'] ?? '',
      externalIntro: postJson['external_intro'] ?? '',
      content: postJson['content'] ?? '',
      image: postJson['image'] ?? '',
      location: postJson['location'] ?? '',
      jobTitle: postJson['jobTitle'] ?? '',
      experience: postJson['experience'] ?? 0,
      education: postJson['education'] ?? '',
      activityField: postJson['activityField'] ?? '',
      activityDuration: postJson['activityDuration'] ?? 0,
      hostingOrganization: postJson['hostingOrganization'] ?? '',
      onlineOrOffline: postJson['onlineOrOffline'] ?? '',
      targetAudience: postJson['targetAudience'] ?? '',
      contestBenefits: postJson['contestBenefits'] ?? '',
      createdAt: DateTime.tryParse(postJson['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(postJson['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Contest toContest() {
    return post.toContest();
  }
}

// 채용 공고 모델
class GetSavedPosts extends BasePost {
  GetSavedPosts({
    required int postId,
    required String category,
    required String title,
    required String company,
    required String companyIntro,
    required String externalIntro,
    required String content,
    required String image,
    required String location,
    required String jobTitle,
    required int experience,
    required String education,
    required String activityField,
    required int activityDuration,
    required String hostingOrganization,
    required String onlineOrOffline,
    required String targetAudience,
    required String contestBenefits,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    postId: postId,
    category: category,
    title: title,
    company: company,
    companyIntro: companyIntro,
    externalIntro: externalIntro,
    content: content,
    image: image,
    location: location,
    jobTitle: jobTitle,
    experience: experience,
    education: education,
    activityField: activityField,
    activityDuration: activityDuration,
    hostingOrganization: hostingOrganization,
    onlineOrOffline: onlineOrOffline,
    targetAudience: targetAudience,
    contestBenefits: contestBenefits,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory GetSavedPosts.empty() {
    return GetSavedPosts(
      postId: 0,
      category: '',
      title: '',
      company: '',
      companyIntro: '',
      externalIntro: '',
      content: '',
      image: '',
      location: '',
      jobTitle: '',
      experience: 0,
      education: '',
      activityField: '',
      activityDuration: 0,
      hostingOrganization: '',
      onlineOrOffline: '',
      targetAudience: '',
      contestBenefits: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory GetSavedPosts.fromJson(Map<String, dynamic> json) {
    return GetSavedPosts(
      postId: json['post_id'] ?? 0,
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      companyIntro: json['company_intro'] ?? '',
      externalIntro: json['external_intro'] ?? '',
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      experience: json['experience'] ?? 0,
      education: json['education'] ?? '',
      activityField: json['activityField'] ?? '',
      activityDuration: json['activityDuration'] ?? 0,
      hostingOrganization: json['hostingOrganization'] ?? '',
      onlineOrOffline: json['onlineOrOffline'] ?? '',
      targetAudience: json['targetAudience'] ?? '',
      contestBenefits: json['contestBenefits'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'category': category,
      'title': title,
      'company': company,
      'company_intro': companyIntro,
      'external_intro': externalIntro,
      'content': content,
      'image': image,
      'location': location,
      'jobTitle': jobTitle,
      'experience': experience,
      'education': education,
      'activityField': activityField,
      'activityDuration': activityDuration,
      'hostingOrganization': hostingOrganization,
      'onlineOrOffline': onlineOrOffline,
      'targetAudience': targetAudience,
      'contestBenefits': contestBenefits,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  Contest toContest() {
    return Contest(
      id: postId.toString(),
      title: title,
      benefit: contestBenefits.isNotEmpty ? contestBenefits : '혜택 정보 없음',
      target: targetAudience.isNotEmpty ? targetAudience : education,
      imageUrl: super.getValidImageUrl(),
      organization: company,
      location: location,
      field: jobTitle,
      dateRange: _formatExperience(experience),
      additionalInfo: content,
      type: ActivityType.job,
      company: company,
    );
  }

  String _formatExperience(int exp) {
    if (exp == 0) return '신입';
    if (exp <= 3) return '${exp}년 이하';
    if (exp <= 5) return '3~5년';
    return '${exp}년 이상';
  }
  
  @override
  String toString() {
    return 'EmployeePost(postId: $postId, title: $title, company: $company, jobTitle: $jobTitle, experience: $experience, location: $location)';
  }
}
