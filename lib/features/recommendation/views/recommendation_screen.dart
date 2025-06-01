import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/posts/widgets/post_list_app_bar.dart';
import '../controllers/recommendation_controller.dart';
import 'recommendation_tab_bar.dart';
import 'recommended_activities_tab.dart';
import 'saved_activities_tab.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 컨트롤러를 routes.dart의 Binding에서 주입받아 사용
    final controller = Get.find<RecommendationController>();

    return Scaffold(
      backgroundColor: const Color(0xFFEDEFF0),
      appBar: const PostListAppBar(),
      body: Column(
        children: [
          // 탭바를 별도 위젯으로 분리
          RecommendationTabBar(),

          // 탭 컨텐츠
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: const [
                // const 추가
                RecommendedActivitiesTab(),
                SavedActivitiesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
