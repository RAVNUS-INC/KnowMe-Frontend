import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/views/post_list_screen.dart';
import 'package:knowme_frontend/features/posts/views/post_detail_screen.dart';

class Routes {
  static const String postList = '/posts';
  static const String postDetail = '/posts/detail';

  static final List<GetPage> routes = [
    // 기존 라우트들...

    // 게시물 관련 라우트
    GetPage(
      name: postList,
      page: () => const PostListScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: postDetail,
      page: () => const PostDetailScreen(),
      transition: Transition.rightToLeft,
    ),
  ];

  static void navigateToPostList() {
    Get.toNamed(postList);
  }

  static void navigateToPostDetail() {
    Get.toNamed(postDetail);
  }
}