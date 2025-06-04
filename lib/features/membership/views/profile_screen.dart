import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart'; // AppRoutes 경로 맞게 수정
import '../../../shared/widgets/base_scaffold.dart'; // BaseScaffold 경로 맞게 수정
import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';
import '../views/membership_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Obx(() {
        final profile = controller.userProfile.value;

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            Divider(color: Colors.grey[100], thickness: 10, height: 20),

            // 프로필 영역
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 62,
                    backgroundColor: Colors.transparent,
                    child: CircleAvatar(
                      radius: 58,
                      backgroundImage: AssetImage(
                          'assets/images/silhouette.png'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // loginId
                  Text(
                    profile.loginId,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),

                  // name
                  Text(
                    profile.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // job (nullable 대비)
                  Text(
                    profile.job ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),

                  // intro (nullable 대비)
                  Text(
                    profile.intro ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 16),

                  // university (nullable 대비)
                  Text(
                    profile.university ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 16),

                  // email
                  Text(
                    profile.email,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // phone
                  Text(
                    profile.phone,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 내 활동 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.activity); // ✅ 다른 route로 이동도 가능
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 8,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: const Text(
                  '내 활동',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
            Container(
                width: double.infinity, height: 24, color: Colors.grey[50]),
            const SizedBox(height: 20),

            // 메뉴 리스트
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: profileMenuItems.map((item) {
                  final isMembership = item == '멤버십 구독';
                  final text = Text(
                    item,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: isMembership
                        ? InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MembershipScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        '멤버십 구독',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    )
                        : text,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 80),
            const Divider(thickness: 0.5),

            // 푸터 상단 로고
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Image.asset('assets/images/knowme_logo.png', height: 40),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 푸터 텍스트
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '고객지원',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text('tel: 02-000-0000', style: TextStyle(fontSize: 12)),
                  Text('email : help@knowme.com',
                      style: TextStyle(fontSize: 12)),
                  Text('주소', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 그라데이션 푸터
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    const Color(0xFFE8F2FF),
                    const Color(0xFFBFDFFF),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '이용약관   |   개인정보처리방침   |   고객센터   |   로그아웃   |   계정탈퇴',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '©KnowMe. All rights reserved.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

/*
  Widget _divider() {
    return Container(width: 1, height: 40, color: Colors.grey[300]);
  }
*/

}