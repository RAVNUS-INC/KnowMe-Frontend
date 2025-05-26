import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("404")),
      body: Center(child: Text("존재하지 않는 페이지입니다.")),
    );
  }
}
