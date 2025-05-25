import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme/shared/widgets/base_scaffold.dart';
import 'package:knowme/features/ai_analysis/controllers/ai_analysis_result_controller.dart';

// 추후 하드코딩된 텍스트들은 mvc구조에 맞게 데이터로 대체 예정
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
                color: Colors.black.withAlpha((0.2 * 255).toInt()), // → 51
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
    final controller = Get.put(AiAnalysisResultController());

    return BaseScaffold(
      currentIndex: 3,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 상단 분석 문구
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: Color(0xFF454C53),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.64,
                ),
                children: [
                  TextSpan(text: '이한양 님이 기록한 '),
                  TextSpan(
                    text: '5개',
                    style: TextStyle(color: Color(0xFF0068E5)),
                  ),
                  TextSpan(text: ' 활동을\n분석했어요'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _verticalDivider,

            _section('강점', 'AI가 분석한 강점 정보입니다.\n\n기획력, 분석력 등...'),
            _section('약점', 'AI가 분석한 약점 정보입니다.\n\n협업 경험 부족 등...'),
            _section('추천 직무', '추천 직무는 다음과 같습니다.\n\n데이터 분석가, PO, 기획자'),

            const SizedBox(height: 32),
            const Text(
              '요약',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0068E5),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.64,
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 막대 그래프
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBar('실전형 주제', const Color(0xFF0068E5), 240),
                const SizedBox(height: 8),
                _buildBar('실무 적용력', const Color(0xFF0068E5), 200),
                const SizedBox(height: 8),
                _buildBar('UX 중심 구성', const Color(0xFF0068E5), 160),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildBar('실무 협업 역량', const Color(0xCDD0CFC7), 200),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildBar('운영 관점 역량', const Color(0xCDD0CFC7), 160),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildBar('전문성', const Color(0xCDD0CFC7), 120),
                ),
              ],
            ),

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

            const SizedBox(height: 32),

            _RecommendationButton(
              label: '활동추천 보러가기',
              onTap: controller.goToRecommendation, // ✅ controller로 분리됨
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBar(String label, Color color, double width) {
  return Container(
    width: width,
    height: 32,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFFF5F5F5),
        fontSize: 14,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        letterSpacing: -0.4,
      ),
    ),
  );
}

class _RecommendationButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RecommendationButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon-ai.png',
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF0068E5),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.48,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFF0068E5),
            ),
          ],
        ),
      ),
    );
  }
}
