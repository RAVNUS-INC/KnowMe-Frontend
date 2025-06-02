import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/membership/models/membership_model.dart';
import 'package:knowme_frontend/features/membership/controllers/membership_controller.dart';

/// 새로 만든 Subscription 화면
class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});
  static const double _imageAspectRatio = 375 / 217;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MembershipController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 이미지
            SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: _imageAspectRatio,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/Vector.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 0,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Image.asset('assets/images/knowme.png', height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '프리미엄 멤버십',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 카드 리스트
            Expanded(
              child: Obx(() => ListView(
                padding: EdgeInsets.zero,
                children: [
                  ...List.generate(membershipPlans.length, (i) {
                    final plan = membershipPlans[i];
                    final isSelected = controller.selectedIndex.value == i;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.85,
                          child: GestureDetector(
                            onTap: () => controller.selectPlan(i),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF0066FF)
                                      : Colors.grey[300]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // 추천 태그
                                  if (plan.isRecommended)
                                    Positioned(
                                      left: 0,
                                      top: -8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF0066FF),
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8),
                                            topLeft: Radius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          '추천',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  // 체크 아이콘
                                  if (isSelected)
                                    const Positioned(
                                      right: 8,
                                      top: 8,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF0066FF),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 40,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          plan.label,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            if (plan.originalPrice != null)
                                              Text(
                                                plan.originalPrice!,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  decoration: TextDecoration.lineThrough,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            if (plan.originalPrice != null)
                                              const SizedBox(height: 4),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: plan.price,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: plan.periodText,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.85,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    '유의사항',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/arrow.png',
                                    width: 12,
                                    height: 12,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 구독하기 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.85,
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: controller.subscribe,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0052CC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              '구독하기',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}