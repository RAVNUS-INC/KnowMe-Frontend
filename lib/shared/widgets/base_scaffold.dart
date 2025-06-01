import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart'; // flutter_svg 패키지 import
import '../../../routes/routes.dart'; // ✅ AppRoutes 사용
// 홈, 검색 등 실제 페이지는 AppRoutes 통해 관리되므로 직접 import 불필요

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final bool showBackButton; // 추가
  final VoidCallback? onBack; // 추가

  const BaseScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
    this.showBackButton = false, // 추가
    this.onBack, // 추가
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Column(
        children: [
          _buildAppBar(context), // context 전달
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xCCF5F5F5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 왼쪽: 뒤로가기 버튼 + 로고(심볼+텍스트) 항상 표시
            Row(
              children: [
                if (showBackButton)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/arrow.svg',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                Image.asset('assets/images/symbol.png', width: 28, height: 28),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    Get.offAllNamed(AppRoutes.home);
                  },
                  child: Image.asset(
                    'assets/images/knowme.png',
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            // 오른쪽 아이콘
            Row(
              children: [
                _AppIconButton('assets/images/Search.png', onTap: () {
                  Get.toNamed(AppRoutes.search);
                }),
                const SizedBox(width: 16),
                _AppIconButton('assets/images/bell.png', onTap: () {
                  print('Bell tapped');
                }),
                const SizedBox(width: 16),
                _AppIconButton('assets/images/User.png', onTap: () {
                  print('Profile tapped');
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    const activeColor = Color(0xFF4C80FF);
    const inactiveColor = Color(0xFFB7C4D4);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFFDFDFD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            iconPath: currentIndex == 0 
                ? 'assets/bottom_nav_svgs/icon-공고_blue.svg'
                : 'assets/bottom_nav_svgs/icon-공고.svg',
            label: '공고',
            isActive: currentIndex == 0,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 0) Get.offAllNamed(AppRoutes.post); // ✅
            },
          ),
          _BottomNavItem(
            iconPath: currentIndex == 1
                ? 'assets/bottom_nav_svgs/icon-내활동_blue.svg'
                : 'assets/bottom_nav_svgs/icon-내활동.svg',
            label: '내 활동',
            isActive: currentIndex == 1,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 1) Get.offAllNamed(AppRoutes.activity); // ✅
            },
          ),
          _BottomNavItem(
            iconPath: currentIndex == 2
                ? 'assets/bottom_nav_svgs/icon-활동추천_blue.svg'
                : 'assets/bottom_nav_svgs/icon-활동추천.svg',
            label: '활동 추천',
            isActive: currentIndex == 2,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 2) Get.offAllNamed(AppRoutes.recommendation);
            },
          ),
          _BottomNavItem(
            iconPath: currentIndex == 3
                ? 'assets/bottom_nav_svgs/icon-AI분석_blue.svg'
                : 'assets/bottom_nav_svgs/icon-AI분석.svg',
            label: 'AI 분석',
            isActive: currentIndex == 3,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 3) Get.offAllNamed(AppRoutes.aiAnalysis); // ✅
            },
          ),
        ],
      ),
    );
  }
}

// 상단 아이콘 버튼
class _AppIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const _AppIconButton(this.assetPath, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(assetPath, width: 24, height: 24, fit: BoxFit.contain),
    );
  }
}

// 하단 네비게이션 버튼
class _BottomNavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SVG 파일이면 SvgPicture.asset 사용, 아니면 Image.asset 사용
          iconPath.endsWith('.svg')
              ? SvgPicture.asset(
                  iconPath,
                  width: 26,
                  height: 26,
                )
              : Image.asset(
                  iconPath,
                  width: 26,
                  height: 26,
                ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}
