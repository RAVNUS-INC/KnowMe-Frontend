import 'package:flutter/material.dart';
import 'package:knowme_frontend/feature/posts/views/post_list_screen.dart';
// import 'package:knowme_frontend/lib/binding/init_binding.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Know Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      // initialBinding: InitBinding(), // GetX 바인딩 사용
      home: const PostListScreen(), // ← 여가 시작 화면! 지민이가 home으로 바꿔야 함
    );
  }
}
