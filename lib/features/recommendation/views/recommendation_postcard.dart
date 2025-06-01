import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/models/contest_model.dart';
import 'package:knowme_frontend/routes/routes.dart';
import 'package:flutter/foundation.dart';

/// 추천 공고 카드를 나타내는 Stateless 위젯
class RecommendationPostCard extends StatelessWidget {
  // 카드 전체 높이, 이미지 높이, 내용 영역 높이 정의 (UI 고정값)
  static const double _cardHeight = 232.0;
  static const double _imageHeight = 150.0;
  static const double _contentHeight = 68.0; // 68
  // 그림자를 위한 여백 추가
  static const double _shadowPadding = 8.0;

  // 공고 데이터 모델
  final Contest contest;
  // 북마크 버튼 클릭 시 실행되는 콜백 함수 (선택 사항)
  final VoidCallback? onBookmarkTap;

  const RecommendationPostCard({
    super.key,
    required this.contest,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 최대 너비가 343을 넘지 않도록 제한
        final cardWidth =
            constraints.maxWidth > 315 ? 315.0 : constraints.maxWidth;

        // 그림자를 위해 패딩 추가
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: _shadowPadding),
          child: InkWell(
            onTap: () => _navigateToDetailScreen(),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: cardWidth,
              height: _cardHeight,
              decoration: _buildCardDecoration(), // 카드 배경 및 그림자
              child: Stack(
                children: [
                  _buildImageSection(cardWidth), // 상단 이미지 영역
                  _buildContentSection(cardWidth), // 하단 텍스트 영역
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 카드 탭 시 상세 화면으로 이동
  void _navigateToDetailScreen() {
    if (kDebugMode) {
      debugPrint('카드가 탭 됨: ${contest.id}');
    }
    // AppRoutes 상수를 사용하여 경로 지정
    Get.toNamed(
      AppRoutes.postDetail,
      arguments: {'contestId': contest.id},
    );
  }

  /// 카드 배경 및 그림자 스타일 정의
  ShapeDecoration _buildCardDecoration() {
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

  /// 상단 이미지 영역 구성 (이미지, 그라디언트, 북마크 포함)
  Widget _buildImageSection(double width) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        child: SizedBox(
          height: _imageHeight,
          child: Stack(
            children: [
              _buildImage(width), // 실제 이미지
              _buildGradientOverlay(), // 어두운 그라디언트 오버레이
              _buildBookmarkButton(), // 북마크 버튼
            ],
          ),
        ),
      ),
    );
  }

  /// 네트워크 이미지를 표시하며 실패 시 기본 이미지로 대체
  Widget _buildImage(double width) {
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
            onError: (exception, stackTrace) =>
                const NetworkImage("https://placehold.co/343x164"),
          ),
        ),
      ),
    );
  }

  /// 이미지 URL이 비어 있는 경우 기본 이미지로 대체
  String _getImageUrl() {
    return contest.imageUrl.isNotEmpty
        ? contest.imageUrl
        : "https://placehold.co/343x164";
  }

  /// 이미지 위에 반투명 그라디언트 오버레이 추가
  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
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

  /// 우측 상단의 북마크 버튼 구현
  Widget _buildBookmarkButton() {
    return Positioned(
      right: 4,
      top: 7,
      child: SizedBox(
        width: 24,
        height: 24,
        child: IconButton(
          icon: Icon(
            contest.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
            size: 20,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(), // 기본 크기 제약 제거
          onPressed: onBookmarkTap,
        ),
      ),
    );
  }

  /// 하단 텍스트(제목, 혜택 및 대상) 영역 구성
  Widget _buildContentSection(double width) {
    return Positioned(
      left: 0,
      top: _imageHeight,
      right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        child: Container(
          height: _contentHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(), // 제목
              const SizedBox(height: 2),
              _buildSubtitle(), // 혜택 및 대상 정보
            ],
          ),
        ),
      ),
    );
  }

  /// 공고 제목 텍스트 스타일 및 설정
  Widget _buildTitle() {
    return Text(
      contest.title,
      style: const TextStyle(
        color: Color(0xFF454C53),
        fontSize: 14,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
        letterSpacing: -0.56,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  /// 혜택 및 대상 정보를 한 줄에 표현
  Widget _buildSubtitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            contest.benefit,
            style: const TextStyle(
              color: Color(0xFF454C53),
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.40,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  contest.target,
                  style: const TextStyle(
                    color: Color(0xFF72787F),
                    fontSize: 10,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.40,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
