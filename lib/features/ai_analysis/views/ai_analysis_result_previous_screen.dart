// ✅ View
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/base_scaffold.dart';
import '../controllers/previous_result_controller.dart';

class AiAnalysisResultPreviousScreen extends StatelessWidget {
  const AiAnalysisResultPreviousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PreviousResultController());

    return BaseScaffold(
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.previousResults.length,
                itemBuilder: (context, index) {
                  final result = controller.previousResults[index];
                  return AnalysisResultCard(
                    date: result['date']!,
                    recordInfo: result['record']!,
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}

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
        color: const Color(0xFFF6FAFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD0D0D0),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
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
          Container(height: 1, color: Color(0xFFE5E5E5)),
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
