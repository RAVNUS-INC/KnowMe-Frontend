import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/routes/routes.dart'; // ✅ AppRoutes 사용

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final int? currentIndex;
  final String? activeIcon;
  final bool showBottomNavBar;
  final Widget? bottomNavigationBar;
  final bool showBottomBar;

  const BaseScaffold({
    super.key,
    required this.body,
    this.currentIndex,
    this.activeIcon,
    this.showBottomNavBar = true,
    this.bottomNavigationBar,
    this.showBottomBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: showBottomBar ? _buildBottomNavBar() : null,
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
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
                    width: 190,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // 오른쪽 아이콘
            Row(
              children: [
                _AppIconButton(
                  activeIcon == 'search'
                      ? 'assets/images/Search_on.png'
                      : 'assets/images/Search.png',
                  onTap: () => Get.toNamed(AppRoutes.search),
                ),
                const SizedBox(width: 16),
                _AppIconButton(
                  activeIcon == 'bell'
                      ? 'assets/images/bellon.png'
                      : 'assets/images/bell.png',
                  onTap: () {
                    Get.toNamed(AppRoutes.notification);
                    debugPrint('Bell tapped');
                  },
                ),
                const SizedBox(width: 16),
                _AppIconButton(
                  activeIcon == 'user'
                      ? 'assets/images/useron.png'
                      : 'assets/images/user.png',
                  onTap: () {
                    Get.toNamed(AppRoutes.profile);
                    debugPrint('Profile tapped');
                  },
                ),
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
        color: Colors.white,
        boxShadow: [
          // ✅ 스크롤 겹침 대비용 그림자 효과
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
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
                if (currentIndex != 2) {
                  Get.offAllNamed(AppRoutes.recommendation); // ✅
                }
              }),
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
      child: Image.asset(assetPath, width: 28, height: 28, fit: BoxFit.contain),
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
          Image.asset(iconPath, width: 40, height: 40, color: color),
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
