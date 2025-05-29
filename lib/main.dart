import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/routes/routes.dart';

void main() {
  // 앱 실행 전 의존성 초기화
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KnowMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
      ),
      // 시작 화면 설정 (원하는 시작 화면으로 변경하세요)
      initialRoute: AppRoutes.postList, // 또는 기존 initialRoute 사용
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
