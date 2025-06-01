import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/recommendation_controller.dart';
import 'package:knowme_frontend/features/posts/models/contest_model.dart';
import 'package:knowme_frontend/routes/routes.dart';
import 'recommendation_postcard.dart';

/// 추천 활동 탭 화면 - 추천 채용, 대외활동, 강의를 섹션별로 보여주는 UI
class RecommendedActivitiesTab extends StatelessWidget {
  const RecommendedActivitiesTab({super.key}); // const 추가, key 파라미터 확인

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: GetBuilder<RecommendationController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(color: Color(0xFFEEEFF0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 100,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('이한양 님을 위한 채용 공고', 0),
                      const SizedBox(height: 16),
                      _buildJobListView(controller),
                      const SizedBox(height: 32),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 32),
                      _buildSectionHeader('맞춤 대외활동 추천', 2),
                      const SizedBox(height: 16),
                      _buildRecommendedActivity(controller),
                      const SizedBox(height: 32),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 32),
                      _buildSectionHeader('취업 준비 필수 강의', 3),
                      const SizedBox(height: 16),
                      _buildCoursesListView(controller),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 섹션 제목과 오른쪽 화살표 버튼 UI
  Widget _buildSectionHeader(String title, int tabIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF232323),
              fontSize: 18,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              letterSpacing: -0.72,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.comfortable,
          padding: const EdgeInsets.all(8.0),
          constraints: const BoxConstraints(minWidth: 44.0, minHeight: 44.0),
          iconSize: 24.0,
          icon: SvgPicture.asset(
            'assets/icons/right_arrow.svg',
            width: 16,
            height: 16,
          ),
          onPressed: () {
            // 해당 탭으로 이동
            Get.toNamed(AppRoutes.postList, arguments: {
              'tabIndex': tabIndex
            }); // 정확히 말하면 해당 탭 인덱스에서 추천순 버튼 눌려서 추천순대로 나열한 페이지로 넘어감
          },
        ),
      ],
    );
  }

  /// 추천 채용 공고 리스트 가로 스크롤 뷰
  Widget _buildJobListView(RecommendationController controller) {
    final recruitmentContests = controller.recommendedContests.isNotEmpty
        ? controller.recommendedContests
            .firstWhere((group) => group.groupName.contains('채용'),
                orElse: () => ContestGroup(groupName: '', contests: []))
            .contests
        : [];

    if (recruitmentContests.isEmpty) {
      return const Center(
        child: Text('채용 정보��� 불러오는 중입니다...'),
      );
    }

    return SizedBox(
      height: 232,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recruitmentContests.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final recruitment = recruitmentContests[index];
          return RecommendationPostCard(
            contest: recruitment,
            onBookmarkTap: () => controller.toggleBookmark(recruitment),
          );
        },
      ),
    );
  }

  /// 추천 대외활동 모두 표시 (수평 리스트뷰)
  Widget _buildRecommendedActivity(RecommendationController controller) {
    final activityContests = controller.recommendedContests.isNotEmpty
        ? controller.recommendedContests
            .firstWhere((group) => group.groupName.contains('대외활동'),
                orElse: () => ContestGroup(groupName: '', contests: []))
            .contests
        : [];

    if (activityContests.isEmpty) {
      return const Center(
        child: Text('대외활동 정보를 불러오는 중입니다...'),
      );
    }

    return SizedBox(
      height: 232,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: activityContests.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final activity = activityContests[index];
          return RecommendationPostCard(
            contest: activity,
            onBookmarkTap: () => controller.toggleBookmark(activity),
          );
        },
      ),
    );
  }

  /// 취업 관련 추천 강의 가로 스크롤 뷰
  Widget _buildCoursesListView(RecommendationController controller) {
    final lectureContests = controller.recommendedContests.isNotEmpty
        ? controller.recommendedContests
            .firstWhere((group) => group.groupName.contains('강의'),
                orElse: () => ContestGroup(groupName: '', contests: []))
            .contests
        : [];

    if (lectureContests.isEmpty) {
      return const Center(
        child: Text('강의 정보를 불러오는 중입니다...'),
      );
    }

    return SizedBox(
      height: 232,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: lectureContests.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final lecture = lectureContests[index];
          return RecommendationPostCard(
            contest: lecture,
            onBookmarkTap: () => controller.toggleBookmark(lecture),
          );
        },
      ),
    );
  }
}
