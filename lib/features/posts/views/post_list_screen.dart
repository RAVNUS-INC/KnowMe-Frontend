import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/models/contest_model.dart';
import 'package:knowme_frontend/features/posts/widgets/post_grid.dart';
import 'package:knowme_frontend/features/posts/widgets/post_list_app_bar.dart';
import 'package:knowme_frontend/features/posts/widgets/post_tab_bar.dart';
import 'package:knowme_frontend/features/posts/widgets/filter_row_widget.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> with SingleTickerProviderStateMixin {
  final List<String> tabTitles = ['채용', '인턴', '대외활동', '교육/강연', '공모전'];
  late TabController _tabController;
  final PageController _pageController = PageController();

  // GetX Controller 인스턴스화
  final PostController _postController = Get.put(PostController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: tabTitles.length,
      vsync: this,
      initialIndex: _postController.currentTabIndex.value,
    );

    // TabBar와 PageView 연결
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        // GetX Controller에 현재 탭 인덱스 업데이트
        _postController.changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEFF0),
      appBar: const PostListAppBar(),
      body: Column(
        children: [
          // 상단 고정 영역
          PostTabBar(
            tabController: _tabController,
            tabTitles: tabTitles,
          ),
          
          // 필터 행 위젯
          FilterRowWidget(
            postController: _postController,
            tabController: _tabController,
          ),

          // 스크롤 가능한 콘텐츠 영역
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                _tabController.animateTo(index);
                // GetX Controller에 현재 탭 인덱스 업데이트
                _postController.changeTab(index);
              },
              itemCount: tabTitles.length,
              itemBuilder: (context, index) {
                // GetX를 사용하여 상태 변화 감지 및 UI 업데이트
                return Obx(() {
                  List<Contest> filteredContests = _postController.getFilteredContentsByTabIndex(index);
                  return PostGrid(contests: filteredContests);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
