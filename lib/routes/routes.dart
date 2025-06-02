import 'package:get/get.dart';
import '../features/ai_analysis/views/ai_analysis_screen.dart';
import '../features/home/controllers/home_controller.dart';
import '../features/membership/views/login_page.dart';
import '../features/membership/views/signup_firstpage.dart';
import '../features/membership/views/signup_secondpage.dart';
import '../features/membership/views/signup_thirdpage.dart';
import '../features/membership/views/find_id_passwd.dart';
import '../features/membership/views/find_id_result_screen.dart';
import '../features/membership/views/password_reset_screen.dart';
import '../features/membership/views/password_reset_success_screen.dart';
import '../features/home/views/home_screen.dart';
import '../features/ai_analysis/controllers/ai_analysis_controller.dart';
import '../features/search/controllers/search_controller.dart';
import '../features/search/controllers/search_result_controller.dart';
import '../features/search/views/search_result_screen.dart';
import '../features/search/views/search_screen.dart';
import '../features/membership/controllers/login_controller.dart';
import '../features/membership/controllers/find_id_passwd_controller.dart';
import '../features/membership/controllers/password_reset_controller.dart';
// import '../features/membership/models/login_model.dart'; unused import래 이런 건 주석 처리 하던 지우던 합시다
import '../features/home/views/notification_screen.dart';
import '../features/membership/views/profile_screen.dart';
import '../features/membership/controllers/profile_controller.dart';
//posts, recommendation
import 'package:knowme_frontend/features/posts/controllers/filter_controller.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/recommendation/controllers/recommendation_controller.dart';

import 'package:knowme_frontend/features/posts/services/filter_options_service.dart';
import 'package:knowme_frontend/features/posts/views/post_detail_screen.dart';
import 'package:knowme_frontend/features/posts/views/post_list_screen.dart';

import 'package:knowme_frontend/features/recommendation/views/recommendation_screen.dart';
//

class AppRoutes {
  static const String login = '/login';
  static const String signupFirst = '/signup/first';
  static const String signupSecond = '/signup/second';
  static const String signupThird = '/signup/third';
  static const String home = '/home';
  static const String findIdPasswd = '/find-id-passwd';
  static const String findIdResult = '/find-id-result';
  static const String passwordReset = '/password-reset';
  static const String passwordResetSuccess = '/password-reset-success';
  static const String search = '/search';
  static const String searchResult = '/searchResult';


  // ✅ 새 라우트 추가
  static const String post = '/post';
  static const String activity = '/activity';
  static const String recommendation = '/recommendation';
  static const String aiAnalysis = '/ai-analysis';
  static const String notification = '/notification';
  static const String profile = '/profile';

  // 게시물 관련 라우트 상수 추가
  static const String postList = '/posts';
  static const String postDetail = '/post/detail';
  // 추천 활동 관련 라우트
  static const String recommendationScreen = '/recommendation';

  static final routes = [
    GetPage(
      name: login,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        Get.put(LoginController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signupFirst,
      page: () => const SignupFirstPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signupSecond,
      page: () => const SignupSecondPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signupThird,
      page: () => const SignupThirdPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: findIdPasswd,
      page: () => const FindIdPasswd(),
      binding: BindingsBuilder(() {
        Get.put(FindIdPasswdController());
      }),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: findIdResult,
      page: () => const FindIdResultScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: passwordReset,
      page: () => const PasswordResetScreen(),
      binding: BindingsBuilder(() {
        Get.put(PasswordResetController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: passwordResetSuccess,
      page: () => const PasswordResetSuccessScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.aiAnalysis,
      page: () => const AiAnalysisScreen(),
      binding: BindingsBuilder(() {
        Get.put(AiAnalysisController()); // ✅ 이게 반드시 있어야 합니다.
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: BindingsBuilder(() {
        Get.put(SearchController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => const NotificationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.searchResult,
      page: () => const SearchResultScreen(),
      binding: BindingsBuilder(() {
        Get.put(SearchResultController());
      }),
      transition: Transition.fadeIn,
    ),
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
  //////////게시물 관련 라우트Add commentMore actions
// 의존성 주입을 위한 공통 메서드
  static void dependencies() {
    // Controller 등록
    Get.put(PostController());
    Get.put(FilterController());
    Get.put(RecommendationController());

    // Services 등록
    Get.put(FilterOptionsService());
  }

  // main.dart에서 사용할 지연 의존성 주입
  static void lazyDependencies() {
    // 필터 옵션 서비스 등록
    Get.lazyPut(() => FilterOptionsService());

    // 필터 컨트롤러 등록
    Get.lazyPut(() => FilterController());

    // 추천 컨트롤러 등록
    Get.lazyPut(() => RecommendationController());
  }

  // 각 화면별 바인딩 클래스 정의
  static final Bindings postListBinding = BindingsBuilder(() {
    Get.put(PostController());
    Get.put(FilterController());
    Get.put(FilterOptionsService());
  });

  static final Bindings postDetailBinding = BindingsBuilder(() {
    Get.put(PostController());
  });

  static final Bindings recommendationBinding = BindingsBuilder(() {
    Get.put(RecommendationController());
  });
}

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
