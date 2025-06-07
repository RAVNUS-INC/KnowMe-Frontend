import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../../shared/widgets/base_scaffold.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';
import '../views/membership_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: -1, // 어떤 탭도 활성화하지 않음
      body: Obx(() {
        // 에러 상태 처리 (로딩은 기본 더미 데이터 표시하면서 백그라운드 로딩)
        if (controller.errorMessage.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () => controller.refreshProfile(),
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '프로필을 불러올 수 없습니다',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.refreshProfile(),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // 정상적으로 프로필 표시 (로딩 중에도 더미 데이터 표시)
        return RefreshIndicator(
          onRefresh: () => controller.refreshProfile(),
          child: ListView(
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
                        backgroundImage:
                            AssetImage('assets/images/silhouette.png'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 1. 직업 (더미 데이터)
                    Text(
                      controller.userProfile.value.job,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),

                    // 2. 이름 (실제 API 데이터)
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Text(
                          controller.userProfile.value.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // 로딩 중일 때 작은 로딩 인디케이터 표시
                        if (controller.isLoading.value)
                          Positioned(
                            right: -30,
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey[400]!),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3. 자기소개 (더미 데이터)
                    Text(
                      controller.userProfile.value.intro,
                      textAlign: TextAlign.center,
                      style: const TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    _divider(),

                    // 4. 학교/학과 (더미 데이터)
                    Text(
                      controller.userProfile.value.university,
                      textAlign: TextAlign.center,
                      style: const TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    _divider(),

                    // 5. 이메일 (실제 API 데이터)
                    Text(
                      controller.userProfile.value.email,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    _divider(),
                  ],
                ),
              ),

              // 내 활동 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.activity);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 3,
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: InkWell(
                        onTap: () {
                          if (isMembership) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MembershipScreen(),
                              ),
                            );
                          }
                          // 다른 메뉴 항목 처리 로직 추가 가능
                        },
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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

              // 그라데이션 푸터 및 로그아웃 메뉴
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(),
                      Colors.white.withValues(),
                      const Color(0xFFE8F2FF).withValues(),
                      const Color(0xFFBFDFFF).withValues(),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이용약관   |   개인정보처리방침   |   고객센터   |   로그아웃   |   계정탈퇴',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '©KnowMe. All rights reserved.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 40, color: Colors.grey[300]);
  }
}
