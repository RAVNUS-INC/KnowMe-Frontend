import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/base_scaffold.dart';
import '../controllers/ai_analysis_result_controller.dart';

class AiAnalysisResultScreen extends StatelessWidget {
  const AiAnalysisResultScreen({super.key});

  Widget get _verticalDivider => Container(
    width: 1,
    height: 60,
    color: const Color(0xFFE5E5E5),
  );

  Widget _section(String title, String content) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF0068E5),
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.64,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.2 * 255).toInt()),
                offset: const Offset(0, -4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF232323),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.4,
            ),
          ),
        ),
        const SizedBox(height: 32),
        _verticalDivider,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiAnalysisResultController(1));

    return Obx(() {
      if (controller.isLoading.value) {
        return BaseScaffold(
          currentIndex: 3,
          body: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 200),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF454C53),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.64,
                    ),
                    children: [
                      const TextSpan(text: '이한양 님이 기록한 '),
                      TextSpan(
                        text: '${controller.activitiesCount}개',
                        style: const TextStyle(color: Color(0xFF0068E5)),
                      ),
                      const TextSpan(text: ' 활동을'),
                      const TextSpan(text: '\n분석하고 있어요'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const CircularProgressIndicator(color: Color(0xFF0068E5)),
              ],
            ),
          ),
        );
      }

      return BaseScaffold(
        currentIndex: 3,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF454C53),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.64,
                  ),
                  children: [
                    const TextSpan(text: '이한양 님이 기록한 '),
                    TextSpan(
                      text: '${controller.activitiesCount}개',
                      style: const TextStyle(color: Color(0xFF0068E5)),
                    ),
                    const TextSpan(text: ' 활동을'),
                    const TextSpan(text: '\n분석했어요'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _verticalDivider,
              _section('강점', controller.result.value?.strength ?? '강점 분석 중...'),
              _section('약점', controller.result.value?.weakness ?? '약점 분석 중...'),
              _section('추천 직무', controller.result.value?.recommendPosition ?? '직무 추천 중...'),
              _section('요약', controller.result.value?.summary ?? '요약 준비 중...'),
              const SizedBox(height: 40),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '실제 채용 담당자는\n',
                      style: TextStyle(
                        color: Color(0xFF454C53),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        letterSpacing: -0.56,
                      ),
                    ),
                    TextSpan(
                      text: '실무 투입 가능성, 협업 역량, 문제 해결력',
                      style: TextStyle(
                        color: Color(0xFF0068E5),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                        letterSpacing: -0.56,
                      ),
                    ),
                    TextSpan(
                      text:
                      ' 등을\n중심으로 판단해요.\n\n이런 기준에서 보완점을 조금만 더 채워넣으면 강한 인상을 줄 수 있습니다!',
                      style: TextStyle(
                        color: Color(0xFF454C53),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        letterSpacing: -0.56,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
