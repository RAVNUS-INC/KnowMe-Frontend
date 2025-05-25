import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/shared/widgets/base_scaffold.dart';
import 'package:knowme_frontend/features/ai_analysis/controllers/previous_result_controller.dart';

class AiAnalysisResultPreviousScreen extends StatelessWidget {
  const AiAnalysisResultPreviousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PreviousResultController());

    return BaseScaffold(
      currentIndex: 3, // AI 분석 탭
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '이전 분석 결과',
              style: TextStyle(
                color: Color(0xFF232323),
                fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.72,
              ),
            ),
            const SizedBox(height: 20),

            // 🔁 분석 카드 리스트 (컨트롤러 사용)
            Obx(() => Column(
                  children: controller.previousResults.map((result) {
                    return AnalysisResultCard(
                      date: result['date']!,
                      recordInfo: result['record']!,
                    );
                  }).toList(),
                )),
          ],
        ),
      ),
    );
  }
}

// ✅ 재사용 가능한 분석 카드 위젯
class AnalysisResultCard extends StatelessWidget {
  final String date;
  final String recordInfo;

  const AnalysisResultCard({
    super.key,
    required this.date,
    required this.recordInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAFF), // 밝은 푸른색 느낌
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD0D0D0),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(
              color: Color(0xFF232323),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.56,
            ),
          ),
          const SizedBox(height: 12),

          // 구분선
          Container(height: 1, color: const Color(0xFFE5E5E5)),

          const SizedBox(height: 12),
          Text(
            recordInfo,
            style: const TextStyle(
              color: Color(0xFF454C53),
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.48,
            ),
          ),
        ],
      ),
    );
  }
}
