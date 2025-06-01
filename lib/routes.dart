import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/views/post_list_screen.dart';
import 'package:knowme_frontend/features/posts/views/post_detail_screen.dart';
import 'package:knowme_frontend/features/recommendation/views/recommendation_screen.dart';
import 'package:knowme_frontend/features/recommendation/controllers/recommendation_controller.dart';

// PostController를 바인딩하는 클래스 생성
class PostBinding implements Bindings {
  @override
  void dependencies() {
    // 메인 컨트롤러 생성 및 주입 (PageController 포함)
    Get.lazyPut<PostController>(() => PostController());
  }
}

class RecommendationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecommendationController>(() => RecommendationController(),
        fenix: true);
  }
}

class Routes {
  static const String postList = '/posts';
  static const String postDetail = '/posts/detail';
  static const String recommendation = '/recommendation'; // 추천 화면 경로 추가

  static final List<GetPage> routes = [
    // 기존 라우트들...

    // 게시물 관련 라우트
    GetPage(
      name: postList,
      page: () => const PostListScreen(),
      binding: PostBinding(), // 컨트롤러 바인딩 추가
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: postDetail,
      page: () => const PostDetailScreen(),
      binding: PostBinding(), // 필요한 경우 상세 페이지에도 바인딩
      transition: Transition.rightToLeft,
    ),

    // 추천 활동 화면 라우트
    GetPage(
      name: recommendation,
      page: () => const RecommendationScreen(),
      binding: RecommendationBinding(), // 추천 컨트롤러 바인딩 추가
      transition: Transition.fadeIn,
    ),
  ];

  static void navigateToPostList() {
    Get.toNamed(postList);
  }

  static void navigateToPostDetail() {
    Get.toNamed(postDetail);
  }

  static void navigateToRecommendation() {
    Get.toNamed(recommendation);
  }
}
