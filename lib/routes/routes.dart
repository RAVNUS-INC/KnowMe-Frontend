import 'package:get/get.dart';
import '../features/ai_analysis/views/ai_analysis_screen.dart';
import '../features/home/controllers/home_controller.dart';
import '../features/membership/views/login_page.dart';
import '../features/membership/views/signup_firstpage.dart';
import '../features/membership/views/signup_secondpage.dart';
import '../features/membership/views/signup_thirdpage.dart';
import '../features/membership/views/find_id_passwd.dart';
import '../features/home/views/home_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signupFirst = '/signup/first';
  static const String signupSecond = '/signup/second';
  static const String signupThird = '/signup/third';
  static const String home = '/home';
  static const String findIdPasswd = '/find-id-passwd';

  // ✅ 새 라우트 추가
  static const String post = '/post';
  static const String activity = '/activity';
  static const String recommendation = '/recommendation';
  static const String aiAnalysis = '/ai-analysis';

  static final routes = [
    GetPage(
      name: login,
      page: () => const LoginPage(),
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
      transition: Transition.downToUp,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
      transition: Transition.fadeIn,
    ),

    // 네비 라우트 등록 후
    GetPage(
      name: aiAnalysis,
      page: () => const AiAnalysisScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
