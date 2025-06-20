import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/main.dart'; // 절대 경로로 수정
import 'package:knowme_frontend/features/membership/views/profile_screen.dart'; // 절대 경로로 수정

void main() {
  testWidgets('TestHome에 "프로필로 이동" 버튼이 보이고, 누르면 동작한다', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: MyApp(),
        getPages: [GetPage(name: '/profile', page: () => ProfileScreen())],
      ),
    );

    expect(find.text('프로필로 이동'), findsOneWidget);

    await tester.tap(find.text('프로필로 이동'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
