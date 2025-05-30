import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recommendation_controller.dart';

class RecommendationTabBar extends StatelessWidget {
  final RecommendationController controller = Get.find<RecommendationController>();
  
  // key 매개변수 추가
  RecommendationTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecommendationController>(
      builder: (controller) {
        return Container(
          height: 53,
          decoration: const BoxDecoration(color: Colors.white),
          child: TabBar(
            controller: controller.tabController,
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
            tabs: controller.tabTitles.map((title) => Tab(
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
            )).toList(),
          ),
        );
      },
    );
  }
}
