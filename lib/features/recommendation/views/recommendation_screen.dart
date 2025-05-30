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
    // 컨트롤러 초기화 - 앱 시작시 한 번만 실행되도록 수정
    final controller = Get.put(RecommendationController(), permanent: true);

    // 디버깅용 코드 제거 (print 문 삭제)

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
              children: const [ // const 추가
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
