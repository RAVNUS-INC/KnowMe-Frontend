import 'package:flutter/material.dart';
import 'package:knowme_frontend/feature/posts/models/contest_model.dart';
import 'package:knowme_frontend/feature/posts/views/PostDetailScreen.dart';

class PostGrid extends StatelessWidget {
  final List<Contest> contests;

  const PostGrid({
    Key? key,
    required this.contests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2; // 좌우 패딩 16*2 + 카드 간 간격 16 = 48

    return SingleChildScrollView(
      child: Container(
        width: screenWidth,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 16),
        child: contests.isEmpty
            ? _buildEmptyState()
            : Wrap(
                spacing: 16, // 가로 간격
                runSpacing: 16, // 세로 간격
                alignment: WrapAlignment.spaceBetween,
                children: contests.map((contest) =>
                  ContestCard(
                    contest: contest,
                    width: cardWidth,
                  )
                ).toList(),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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
    Key? key,
    required this.contest,
    this.width = 164,
  }) : super(key: key);

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
        width: width,
        height: 232,
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
            // 이미지 부분
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: width,
                height: 164,
                child: Stack(
                  children: [
                    // 이미지
                    Container(
                      width: width,
                      height: 164,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(contest.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // 그라데이션 오버레이
                    Container(
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
                    // 북마크 버튼
                    Positioned(
                      right: 4,
                      top: 7,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const ShapeDecoration(
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.bookmark_border, color: Colors.white, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 컨텐츠 설명 부분
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
                  children: [
                    SizedBox(
                      width: width - 16, // 패딩 고려
                      child: Text(
                        contest.title,
                        style: const TextStyle(
                          color: Color(0xFF454C53),
                          fontSize: 17, // 17로 변경
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.56,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          contest.benefit,
                          style: const TextStyle(
                            color: Color(0xFF454C53),
                            fontSize: 12, // 12로 변경
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.40,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          contest.target,
                          style: const TextStyle(
                            color: Color(0xFF72787F),
                            fontSize: 12, // 12로 변경
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.40,
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
