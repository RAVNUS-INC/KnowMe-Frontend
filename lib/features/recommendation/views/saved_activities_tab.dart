import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/widgets/post_grid.dart';
import 'package:knowme_frontend/features/posts/models/contest_model.dart';

import '../controllers/reommendation_controller.dart';

class SavedActivitiesTab extends StatelessWidget {
  final RecommendationController controller = Get.find<RecommendationController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecommendationController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: controller.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(context),
        );
      },
    );
  }
  
  Widget _buildContent(BuildContext context) {
    final savedContests = controller.savedContests;
    
    // 활동을 타입별로 그룹화
    final groupedContests = _groupContestsByType(savedContests);
    
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16, 
          right: 16,
          bottom: 100,
        ),
        decoration: const BoxDecoration(color: Color(0xFFEDEFF0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 각 카테고리별 섹션 구성
            ...groupedContests.entries.map((entry) {
              return _buildCategorySection(context, entry.key, entry.value);
            }).toList(),
            
            // 대외활동 카테고리가 없는 경우 빈 섹션 표시
            if (!groupedContests.containsKey('대외 활동'))
              _buildEmptyCategorySection('대외 활동'),
          ],
        ),
      ),
    );
  }
  
  Map<String, List<Contest>> _groupContestsByType(List<Contest> contests) {
    Map<String, List<Contest>> groupedContests = {};
    
    for (var contest in contests) {
      final category = _getCategoryName(contest.type);
      
      // 해당 카테고리 리스트가 없으면 초기화
      groupedContests.putIfAbsent(category, () => []);
      
      // 해당 카테고리에 활동 추가
      groupedContests[category]!.add(contest);
    }
    
    return groupedContests;
  }
  
  String _getCategoryName(ActivityType type) {
    switch (type) {
      case ActivityType.job:
        return '채용';
      case ActivityType.internship:
        return '인턴십';
      case ActivityType.activity:
        return '대외 활동';
      case ActivityType.course:
        return '교육/강연';
      case ActivityType.contest:
        return '공모전';
    }
  }
  
  Widget _buildCategorySection(BuildContext context, String title, List<Contest> contests) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          const SizedBox(height: 16),
          _buildContestGrid(context, contests),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF232323),
        fontSize: 18,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w700,
        letterSpacing: -0.72,
      ),
    );
  }
  
  Widget _buildEmptyCategorySection(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          const SizedBox(height: 16),
          const Text(
            '저장한 활동이 없습니다',
            style: TextStyle(
              color: Color(0xFFB7C4D4),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.56,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContestGrid(BuildContext context, List<Contest> contests) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 64) / 2; // 좌우 마진 8*2 + 내부 패딩 16*2 + 카드 간 간격 16 = 64
    
    return Wrap(
      spacing: 16, // 가로 간격
      runSpacing: 16, // 세로 간격
      alignment: WrapAlignment.spaceBetween,
      children: contests.map((contest) => 
        _createCustomContestCard(contest, cardWidth)
      ).toList(),
    );
  }

  // ContestCard를 직접 사용하는 헬퍼 메서드
  Widget _createCustomContestCard(Contest contest, double width) {
    return _CustomContestCard(
      contest: contest,
      width: width,
      onBookmarkTap: () => controller.toggleBookmark(contest),
    );
  }
}

// ContestCard를 확장하여 북마크 기능을 추가한 커스텀 위젯
class _CustomContestCard extends StatelessWidget {
  final Contest contest;
  final double width;
  final VoidCallback? onBookmarkTap;

  const _CustomContestCard({
    required this.contest,
    required this.width,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          ContestCard(
            contest: contest,
            width: width,
          ),
          _buildBookmarkButton(),
        ],
      ),
    );
  }

  Widget _buildBookmarkButton() {
    return Positioned(
      right: 4,
      top: 7,
      child: Container(
        width: 24,
        height: 24,
        child: IconButton(
          icon: Icon(
            contest.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
            size: 20
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onBookmarkTap,
        ),
      ),
    );
  }
}
