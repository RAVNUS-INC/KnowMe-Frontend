import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/base_scaffold.dart'; // BaseScaffold import

import '../controllers/recommendation_controller.dart';
import 'recommendation_tab_bar.dart';
import 'recommended_activities_tab.dart';
import 'saved_activities_tab.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecommendationController>();

    return BaseScaffold(
      currentIndex: 2, // '활동 추천' 탭 인덱스
      body: Column(
        children: [
          RecommendationTabBar(),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: const [
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
