import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/widgets/post_grid.dart';
import 'package:knowme_frontend/features/posts/models/postsPostid_model.dart';
import '../controllers/recommendation_controller.dart';

/// 저장된 활동 탭 - 사용자가 북마크한 활동들을 카테고리별로 정리해서 보여주는 탭 화면
class SavedActivitiesTab extends StatelessWidget {
  const SavedActivitiesTab({super.key});

  // GetX로 주입된 RecommendationController 사용
  RecommendationController get controller =>
      Get.find<RecommendationController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecommendationController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: controller.refreshData, // 당겨서 새로고침 기능
          child: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator()) // 로딩 중이면 로딩 인디케이터
              : _buildContent(context), // 로딩이 끝났으면 콘텐츠 빌드
        );
      },
    );
  }

  /// 저장된 활동들을 분류하고 UI로 렌더링
  Widget _buildContent(BuildContext context) {
    final savedPosts = controller.savedPosts;

    // 활동을 타입에 따라 분류
    final groupedPosts = _groupPostsByCategory(savedPosts);

    // 모든 카테고리 이름 목록 정의
    final allCategories = ['채용', '인턴십', '대외 활동', '교육/강연', '공모전'];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
        decoration: const BoxDecoration(color: Color(0xFFEDEFF0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 모든 카테고리를 순회하면서 섹션 빌드
            for (int i = 0; i < allCategories.length; i++) ...[
              _buildCategorySection(context, allCategories[i],
                  groupedPosts[allCategories[i]] ?? []),
              // 마지막 항목이 아닌 경우에만 구분선 추가
              if (i < allCategories.length - 1) ...[
                const SizedBox(height: 20),
                Divider(color: Colors.grey[300], thickness: 1),
                const SizedBox(height: 20),
              ],
            ],
          ],
        ),
      ),
    );
  }

  /// 활동들을 카테고리에 따라 그룹화
  Map<String, List<PostModel>> _groupPostsByCategory(List<PostModel> posts) {
    Map<String, List<PostModel>> groupedPosts = {};

    for (var post in posts) {
      final category = _getCategoryName(post.category);
      groupedPosts.putIfAbsent(category, () => []);
      groupedPosts[category]!.add(post);
    }

    return groupedPosts;
  }

  /// 카테고리 타입을 한글 카테고리명으로 변환
  String _getCategoryName(String category) {
    switch (category.toLowerCase()) {
      case 'job':
        return '채용';
      case 'internship':
        return '인턴십';
      case 'activity':
        return '대외 활동';
      case 'course':
        return '교육/강연';
      case 'contest':
        return '공모전';
      default:
        return '기타';
    }
  }

  /// 카테고리 섹션 UI 빌드 (카테고리명 + 활동 있으면 카드 그리드, 없으면 비어있음 메시지)
  Widget _buildCategorySection(
      BuildContext context, String title, List<PostModel> posts) {
    return SizedBox(
      // Container에서 SizedBox로 변경
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          const SizedBox(height: 16),
          // 해당 카테고리에 저장된 활동이 있으면 그리드로 표시, 없으면 비어있음 메시지 표시
          posts.isEmpty
              ? const Text(
                  '저장한 활동이 없습니다',
                  style: TextStyle(
                    color: Color(0xFFB7C4D4),
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.56,
                  ),
                )
              : _buildPostGrid(context, posts),
        ],
      ),
    );
  }

  /// 섹션 제목 텍스트 스타일
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

  /// 그리드 형태로 활동 카드 배치
  Widget _buildPostGrid(BuildContext context, List<PostModel> posts) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2; // 전체 너비에서 padding, margin 감안

    return Wrap(
      spacing: 16, // 가로 간격
      runSpacing: 16, // 세로 간격
      children: posts
          .map((post) => _createCustomPostCard(post, cardWidth))
          .toList(),
    );
  }

  /// 각 PostModel 데이터를 위젯으로 만들어 반환 (북마크 버튼 포함된 카드)
  Widget _createCustomPostCard(PostModel post, double width) {
    return _CustomPostCard(
      key: ValueKey(post.post_id), // 고유 키 추가
      post: post,
      width: width,
      onBookmarkTap: () => controller.toggleBookmark(post),
    );
  }
}

/// PostCard에 북마크 버튼이 포함된 사용자 정의 위젯
class _CustomPostCard extends StatelessWidget {
  final PostModel post;
  final double width;
  final VoidCallback? onBookmarkTap;

  const _CustomPostCard({
    super.key,
    required this.post,
    required this.width,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          PostCard(
            post: post,
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
      child: SizedBox(
        width: 24,
        height: 24,
        child: IconButton(
          icon: Icon(
              post.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onBookmarkTap,
        ),
      ),
    );
  }
}
