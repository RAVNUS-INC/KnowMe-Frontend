import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart'; // AppRoutes 경로 맞게 수정
import '../../../shared/widgets/base_scaffold.dart'; // BaseScaffold 경로 맞게 수정

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<String> menuItems = [
    '프로필 수정',
    '비밀번호 변경',
    '소셜 연동',
    '멤버십 구독',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBottomBar: false,
      activeIcon: 'user',
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Divider(
            color: Colors.grey[100],
            thickness: 10,
            height: 20,
          ),

          // 프로필 영역
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 62,
                  backgroundColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 58,
                    backgroundImage: AssetImage('images/silhouette.png'),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '프론트엔드 개발자',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  '이한양',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  '끊임없이 배우고 도전하는\n프론트엔드 개발자',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.5),
                ),
                const SizedBox(height: 16),
                _divider(),
                const Text(
                  '한양대학교 ERICA\nICT융합학부 재학',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.5),
                ),
                const SizedBox(height: 16),
                _divider(),
                const Text(
                  'adc1234@knowme.kr',
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 16),
                _divider(),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 내 활동 버튼
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.activity); // ✅ 다른 route로 이동도 가능
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 8,
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: const Text(
                '내 활동',
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 40),
          Container(width: double.infinity, height: 24, color: Colors.grey[50]),
          const SizedBox(height: 20),

          // 메뉴 리스트
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: menuItems.map((item) {
                final isMembership = item == '멤버십 구독';
                final text = Text(
                  item,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: isMembership
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MembershipScreen()),
                            );
                          },
                          child: const Text('멤버십 구독',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                        )
                      : text,
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 80),
          const Divider(thickness: 0.5),

          // 푸터 상단 로고
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset('images/knowme_logo.png', height: 40),
                const SizedBox(width: 10),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 푸터 텍스트
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('고객지원',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(height: 4),
                Text('tel: 02-000-0000', style: TextStyle(fontSize: 12)),
                Text('email : help@knowme.com', style: TextStyle(fontSize: 12)),
                Text('주소', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 그라데이션 푸터
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(), // 완전 투명 (또는 흰색)
                  Colors.white.withValues(), // 중간까지 흰색/투명
                  const Color(0xFFE8F2FF)
                      .withValues(), // 아주 연한 파란색 (hex 값은 이미지 참고)
                  const Color(0xFFBFDFFF).withValues(),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이용약관   |   개인정보처리방침   |   고객센터   |   로그아웃   |   계정탈퇴',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
                const SizedBox(height: 8),
                Text(
                  '©KnowMe. All rights reserved.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey[300],
    );
  }
}

/// 새로 만든 Subscription 화면
class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  // 원본 이미지의 가로:세로 비율 (예: 375x217)
  static const double _imageAspectRatio = 375 / 217;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── 상단 이미지 + 텍스트 ──
            SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: _imageAspectRatio,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/Vector.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 0,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Image.asset('assets/images/knowme.png', height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── '프리미엄 멤버십' 텍스트 ──
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '프리미엄 멤버십',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── 구독 옵션 카드들 ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 12개월 추천 카드
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.85,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFF0066FF), width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // 추천 태그
                              Positioned(
                                left: 0,
                                top: -8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF0066FF),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(8),
                                      topLeft: Radius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    '추천',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                              // 체크 아이콘
                              const Positioned(
                                right: 8,
                                top: 8,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF0066FF),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('\u00A0\u00A0\u00A012개월',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '70,800원',
                                          style: TextStyle(
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '63,800원',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' / 년',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 1개월 카드
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.85,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.grey[300]!, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('\u00A0\u00A0\u00A01개월',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '5,900원',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' / 월',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 유의사항 박스
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.85,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                          ),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('유의사항',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                  Image.asset('assets/images/arrow.png',
                                      width: 12,
                                      height: 12,
                                      fit: BoxFit.contain),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 구독하기 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.85,
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0052CC),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('구독하기',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
