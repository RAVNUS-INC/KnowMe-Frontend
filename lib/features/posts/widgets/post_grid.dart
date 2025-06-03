import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/routes/routes.dart';
import 'package:knowme_frontend/features/posts/models/postsPostid_model.dart';

class PostGrid extends StatelessWidget {
  final List<PostModel> posts;

  const PostGrid({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (screenWidth - 64) / 2; // 좌우 마진 8*2 + 내부 패딩 16*2 + 카드 간 간격 16 = 64

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Container(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 16),
          child: posts.isEmpty
              ? _buildEmptyState()
              : _buildPostGrid(cardWidth),
        ),
      ),
    );
  }

  Widget _buildPostGrid(double cardWidth) {
    return Wrap(
      spacing: 16, // 가로 간격
      runSpacing: 16, // 세로 간격
      alignment: WrapAlignment.spaceBetween,
      children: posts
          .map((post) => PostCard(
        post: post,
        width: cardWidth,
      ))
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Color(0xFFB7C4D4)),
            SizedBox(height: 16),
            Text(
              '조건에 맞는 게시물이 없습니다.',
              style: TextStyle(
                color: Color(0xFF454C53),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final PostModel post;
  final double width;
  static const double _cardHeight = 232.0;
  static const double _imageHeight = 164.0;
  static const double _contentHeight = 68.0;

  const PostCard({
    super.key,
    required this.post,
    this.width = 164, // 기본값을 Card1의 너비와 유사하게 설정
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // null 체크 추가
        if (post.post_id != null && post.post_id! > 0) {
          Get.toNamed(AppRoutes.postDetail, arguments: {'postId': post.post_id});
        } else {
          Get.snackbar(
            '오류',
            '유효하지 않은 게시물입니다',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Container(
        width: width,
        height: _cardHeight,
        clipBehavior: Clip.antiAlias,
        decoration: _buildCardDecoration(),
        child: Stack(
          children: [
            _buildImageSection(),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Decoration _buildCardDecoration() {
    return ShapeDecoration(
      color: const Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      shadows: const [
        BoxShadow(
          color: Color(0x33184173),
          blurRadius: 4,
          offset: Offset(0, 2),
          spreadRadius: 0,
        )
      ],
    );
  }

  Widget _buildImageSection() {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: width,
        height: _imageHeight,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            _buildImage(),
            _buildGradientOverlay(),
            _buildBookmarkButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: width,
        height: _imageHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(_getImageUrl()),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  String _getImageUrl() {
    // 첨부 파일이 있으면 첫 번째 첨부파일의 URL 사용, 없으면 기본 이미지
    return (post.attachments != null && post.attachments!.isNotEmpty)
        ? post.attachments![0].url
        : "https://placehold.co/600x400?text=No+Image";
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: width,
        height: _imageHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.50, 1.00),
            end: Alignment(0.50, -0.00),
            colors: [Color(0x00F5F5F5), Color(0xFF5D666F)],
          ),
        ),
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
            size: 20
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            // 북마크 기능 - 컨트롤러에 연결 필요
          },
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Positioned(
      left: 0,
      top: _imageHeight,
      child: Container(
        width: width,
        height: _contentHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 2),
            _buildSubtitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return SizedBox(
      width: width - 16, // 좌우 패딩 8*2 제외
      child: Text(
        post.title,
        style: const TextStyle(
          color: Color(0xFF454C53),
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.56,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            post.company,
            style: const TextStyle(
              color: Color(0xFF454C53),
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.40,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            post.category,
            style: const TextStyle(
              color: Color(0xFF72787F),
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.40,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
