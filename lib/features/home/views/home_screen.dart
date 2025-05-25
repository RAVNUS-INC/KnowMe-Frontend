import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../shared/widgets/base_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return BaseScaffold(
      currentIndex: 0,
      body: Container(
        width: double.infinity,
        color: const Color(0xFFFAFAFA),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // 🔹 카드 슬라이더
            SizedBox(
              height: 157,
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: 3,
                itemBuilder: (context, index) => controller.buildPage(index),
              ),
            ),

            const SizedBox(height: 12),

            // 🔸 인디케이터
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final isActive = controller.currentPage.value == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                )),

            const SizedBox(height: 30),

            // 🔹 아이콘 리스트
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: controller.iconItems.map((item) {
                  return _IconLabelItem(
                    imageName: item['image']!,
                    label: item['label']!,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                width: double.infinity,
                color: const Color(0xFFE5E5E5),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              '내 활동 분석 리포트가 도착했어요',
              style: TextStyle(
                color: Color(0xFF232323),
                fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.72,
              ),
            ),

            const SizedBox(height: 24),

            _analysisReportBox(),

            const SizedBox(height: 30),

            // AI 분석 버튼
            GestureDetector(
              onTap: controller.goToAiAnalysis,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF5F5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x33184173),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/icon-ai.png',
                        width: 16, height: 16),
                    const SizedBox(width: 8),
                    const Text(
                      'AI분석 바로가기',
                      style: TextStyle(
                        color: Color(0xFF0068E5),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.48,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right,
                        size: 18, color: Color(0xFF0068E5)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _analysisReportBox() {
    return Column(
      children: [
        Center(
          child: Container(
            width: 341,
            height: 171,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '이한양 님의 직무 적합도',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF454C53),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.48,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  color: const Color(0xFFE5E5E5),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '추천 활동',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF454C53),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.48,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 311,
          height: 15,
          decoration: const BoxDecoration(
            color: Color(0xFFE5E5E5),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class _IconLabelItem extends StatelessWidget {
  final String imageName;
  final String label;

  const _IconLabelItem({
    required this.imageName,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/$imageName', width: 40, height: 40),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF454C53),
            fontSize: 10,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}
