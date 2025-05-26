import 'package:flutter/material.dart';
import 'package:knowme_frontend/features/posts/models/contest_model.dart';
import 'package:knowme_frontend/features/posts/views/post_detail_screen.dart';

class PostGrid extends StatelessWidget {
  final List<Contest> contests;

  const PostGrid({
    super.key,
    required this.contests,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 64) / 2; // 좌우 마진 8*2 + 내부 패딩 16*2 + 카드 간 간격 16 = 64

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 16),
          child: contests.isEmpty
              ? _buildEmptyState()
              : Wrap(
                  spacing: 16, // 가로 간격
                  runSpacing: 16, // 세로 간격
                  alignment: WrapAlignment.spaceBetween,
                  children: contests
                      .map((contest) => ContestCard(
                            contest: contest,
                            width: cardWidth,
                          ))
                      .toList(),
                ),
        ),
      ),
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
              '조건에 맞는 공모전이 없습니다.',
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

class ContestCard extends StatelessWidget {
  final Contest contest;
  final double width;

  const ContestCard({
    super.key,
    required this.contest,
    this.width = 164, // 기본값을 Card1의 너비와 유사하게 설정 (실제로는 PostGrid에서 계산된 값 사용)
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PostDetailScreen()),
        );
      },
      child: Container(
        width: width, // PostGrid에서 계산된 동적 너비 사용
        height: 232, // Card1과 동일한 높이
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
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
        ),
        child: Stack(
          children: [
            // 이미지 및 북마크 영역 (상단)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: width,
                height: 164,
                clipBehavior: Clip.antiAlias, // Card1의 구조 반영
                decoration: const BoxDecoration(), // Card1의 구조 반영
                child: Stack(
                  children: [
                    // 이미지
                    Positioned( // Card1의 구조 반영
                      left: 0,
                      top: 0,
                      child: Container(
                        width: width,
                        height: 164,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(contest.imageUrl.isNotEmpty ? contest.imageUrl : "https://placehold.co/600x400?text=No+Image"), // URL이 비어있을 경우 플레이스홀더
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // 그라데이션 오버레이
                    Positioned( // Card1의 구조 반영
                      left: 0,
                      top: 0,
                      child: Container(
                        width: width,
                        height: 164,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.50, 1.00),
                            end: Alignment(0.50, -0.00),
                            colors: [Color(0x00F5F5F5), Color(0xFF5D666F)],
                          ),
                        ),
                      ),
                    ),
                    // 북마크 버튼 (기존 IconButton 유지 및 스타일 적용)
                    Positioned(
                      right: 4, // Card1은 left: 136, 기존 코드는 right: 4. 동적 너비에는 right가 더 적합.
                      top: 7,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: ShapeDecoration(
                          color: Colors.black.withOpacity(0.3), // 배경 추가하여 아이콘 가시성 확보
                          shape: const CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.bookmark_border, color: Colors.white, size: 16), // 아이콘 크기 조정
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // 북마크 기능
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 텍스트 컨텐츠 영역 (하단)
            Positioned(
              left: 0,
              top: 164,
              child: Container(
                width: width,
                height: 68,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // spacing: 2, -> SizedBox로 대체
                  children: [
                    SizedBox(
                      width: width - 16, // 좌우 패딩 8*2 제외
                      child: Text(
                        contest.title,
                        style: const TextStyle(
                          color: Color(0xFF454C53),
                          fontSize: 14, // Card1의 폰트 크기
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.56,
                        ),
                        maxLines: 2, // 제목이 길 경우 2줄로 제한
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2), // spacing: 2 대체
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // spacing: 4, -> SizedBox로 대체
                      children: [
                        Flexible(
                          child: Text(
                            contest.benefit,
                            style: const TextStyle(
                              color: Color(0xFF454C53),
                              fontSize: 10, // Card1의 폰트 크기
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.40,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4), // spacing: 4 대체
                        Flexible(
                          child: Text(
                            contest.target,
                            style: const TextStyle(
                              color: Color(0xFF72787F),
                              fontSize: 10, // Card1의 폰트 크기
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.40,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
