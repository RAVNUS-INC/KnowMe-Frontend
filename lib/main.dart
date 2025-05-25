import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/views/post_list_screen.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/presenters/filter_presenter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // GetX 컨트롤러 초기화
  final postController = Get.put(PostController());
  final filterPresenter = Get.put(FilterPresenter());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Know Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const PostListScreen(),
    );
  }
}
