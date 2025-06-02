import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import '../../../routes/routes.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool showBottomBar;
  final String? activeIcon;
  final Color? backgroundColor; // 배경색 매개변수 추가

  const BaseScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
    this.showBackButton = false,
    this.onBack,
    this.showBottomBar = true,
    this.activeIcon,
    this.backgroundColor, // 배경색 매개변수 추가
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? const Color(0xFFFDFDFD), // 배경색 적용
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: showBottomBar ? _buildBottomNavBar() : null, // showBottomBar에 따라 표시 여부 결정
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
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
                    Get.toNamed(AppRoutes.home);
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
                _AppIconButton(
                  'assets/icons/Search.svg',
                  isActive: activeIcon == 'search',
                  onTap: () {
                    Get.toNamed(AppRoutes.search);
                  }
                ),
                const SizedBox(width: 16),
                _AppIconButton(
                  'assets/icons/bell.svg',
                  isActive: activeIcon == 'bell',
                  onTap: () {
                    // 알림 화면으로 이동
                    Get.toNamed(AppRoutes.notification);
                  }
                ),
                const SizedBox(width: 16),
                _AppIconButton(
                  'assets/icons/User.svg',
                  isActive: activeIcon == 'user',
                  onTap: () {
                    // 프로필 화면으로 이동
                    Get.toNamed(AppRoutes.profile);
                  }
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
            iconPath: 'assets/bottom_nav_svgs/icon-공고.svg',
            activeIcon: 'assets/bottom_nav_svgs/icon-공고_blue.svg', 
            label: '공고',
            isActive: currentIndex == 0,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 0) {
                // 디버그 로깅 추가
                Get.log('공고 탭 클릭: ${AppRoutes.post}');
                // Get.offAllNamed 대신 Get.toNamed 사용
                Get.toNamed(AppRoutes.home);
              }
            },
          ),
          _BottomNavItem(
            iconPath: 'assets/bottom_nav_svgs/icon-내활동.svg',
            activeIcon: 'assets/bottom_nav_svgs/icon-내활동_blue.svg',
            label: '내 활동',
            isActive: currentIndex == 1,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 1) {
                // 디버깅 로그 추가
                Get.log('내 활동 탭 클릭: ${AppRoutes.activity}');
                Get.toNamed(AppRoutes.activity);
              }
            },
          ),
          _BottomNavItem(
            iconPath: 'assets/bottom_nav_svgs/icon-활동추천.svg',
            activeIcon: 'assets/bottom_nav_svgs/icon-활동추천_blue.svg', // activeIcon 매개변수 추가
            label: '활동 추천',
            isActive: currentIndex == 2,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 2) {
                Get.toNamed(AppRoutes.recommendation);
              }
            },
          ),
          _BottomNavItem(
            iconPath: 'assets/bottom_nav_svgs/icon-AI분석.svg',
            activeIcon: 'assets/bottom_nav_svgs/icon-AI분석_blue.svg', // activeIcon 매개변수 추가
            label: 'AI 분석',
            isActive: currentIndex == 3,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (currentIndex != 3) {
                Get.toNamed(AppRoutes.aiAnalysis);
              }
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
  final bool isActive; // 활성화 상태 추가

  const _AppIconButton(
    this.assetPath, 
    {required this.onTap, this.isActive = false} // isActive 매개변수 추가
  );

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF4C80FF) : null;
    
    return GestureDetector(
      onTap: onTap,
      child: assetPath.endsWith('.svg') 
        ? SvgPicture.asset(
            assetPath,
            width: 24, 
            height: 24,
            fit: BoxFit.contain,
            // 활성화 상태일 때 색상 변경
            colorFilter: isActive 
              ? const ColorFilter.mode(Color(0xFF4C80FF), BlendMode.srcIn)
              : null,
          )
        : Image.asset(
            assetPath, 
            width: 24, 
            height: 24, 
            fit: BoxFit.contain,
            color: color,
          ),
    );
  }
}

// 하단 네비게이션 버튼
class _BottomNavItem extends StatelessWidget {
  final String iconPath;
  final String? activeIcon; // nullable로 변경
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.iconPath,
    this.activeIcon, // 선택적 매개변수로 변경
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;
    // activeIcon이 null이면 iconPath 사용, 아니면 활성 상태일 때 activeIcon 사용
    final currentIcon = (isActive && activeIcon != null) ? activeIcon! : iconPath;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SVG 파일이면 SvgPicture.asset 사용, 아니면 Image.asset 사용
          currentIcon.endsWith('.svg')
              ? SvgPicture.asset(
                  currentIcon,
                  width: 26,
                  height: 26,
                  colorFilter: currentIcon == iconPath && isActive
                      ? ColorFilter.mode(color, BlendMode.srcIn)
                      : null,
                )
              : Image.asset(
                  currentIcon,
                  width: 26,
                  height: 26,
                  color: color,
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
