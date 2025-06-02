import 'package:flutter/material.dart';

class PostTabBar extends StatelessWidget {
  final TabController tabController;
  final List<String> tabTitles;

  const PostTabBar({
    super.key,
    required this.tabController,
    required this.tabTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
      child: TabBar(
        controller: tabController,
        isScrollable: false,
        indicatorColor: const Color(0xFF0068E5),
        indicatorWeight: 3,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.fill,
        labelColor: const Color(0xFF232323),
        unselectedLabelColor: const Color(0xFFB7C4D4),
        labelStyle: const TextStyle(
          fontSize: 19,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.64,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 19,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.64,
        ),
        tabs: tabTitles
            .map((title) => Tab(
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
