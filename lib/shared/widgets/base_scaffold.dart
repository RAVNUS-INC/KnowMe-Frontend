import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart'; // ✅ AppRoutes 사용
// 홈, 검색 등 실제 페이지는 AppRoutes 통해 관리되므로 직접 import 불필요

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const BaseScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAppBar() {
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
            // 로고
            Row(
              children: [
                Image.asset('assets/images/symbol.png', width: 28, height: 28),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    Get.offAllNamed(AppRoutes.home); // ✅ 이름기반 경로
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
                  Get.toNamed(AppRoutes.search); // ✅ binding 적용됨
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
            iconPath: 'assets/images/icon-공고.png',
            label: '공고',
            isActive: currentIndex == 0,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 0) Get.offAllNamed(AppRoutes.post); // ✅
            },
          ),
          _BottomNavItem(
            iconPath: 'assets/images/내활동.png',
            label: '내 활동',
            isActive: currentIndex == 1,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 1) Get.offAllNamed(AppRoutes.activity); // ✅
            },
          ),
          _BottomNavItem(
            iconPath: 'assets/images/활동추천.png',
            label: '활동 추천',
            isActive: currentIndex == 2,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 2)
                Get.offAllNamed(AppRoutes.recommendation); // ✅
            },
          ),
          _BottomNavItem(
            iconPath: 'assets/images/AI분석.png',
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
          Image.asset(iconPath, width: 26, height: 26, color: color),
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
