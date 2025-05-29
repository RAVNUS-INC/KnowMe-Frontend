import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/views/post_list_screen.dart';
import 'package:knowme_frontend/binding/init_binding.dart';
import 'package:knowme_frontend/features/posts/controllers/filter_controller.dart';
import 'package:knowme_frontend/features/posts/services/filter_options_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 앱 실행 전 필요한 서비스와 컨트롤러 초기화
  initServices();
  runApp(const MyApp());
}

// 앱에서 사용하는 서비스 초기화
Future<void> initServices() async {
  // 필터 옵션 서비스 등록
  Get.lazyPut(() => FilterOptionsService());
  
  // 필터 컨트롤러 등록
  Get.lazyPut(() => FilterController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Know Me',
      debugShowCheckedModeBanner: false,
      initialBinding: InitBinding(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const PostListScreen(),
    );
  }
}
