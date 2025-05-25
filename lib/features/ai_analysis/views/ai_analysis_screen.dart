import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme/features/ai_analysis/controllers/ai_analysis_controller.dart';

class AiAnalysisScreen extends StatefulWidget {
  const AiAnalysisScreen({super.key});

  @override
  State<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends State<AiAnalysisScreen>
    with SingleTickerProviderStateMixin {
  bool _showDetails = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late AiAnalysisController _analysisController;

  @override
  void initState() {
    super.initState();

    // ✅ 수정된 부분: 주입받기
    _analysisController = Get.find<AiAnalysisController>();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
      setState(() {
        _showDetails = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFD9D9D9)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Center(
              child: Image.asset(
                'assets/images/ai_analysis_logo.png',
                width: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(height: 1, color: const Color(0xFFE5E5E5)),
            ),
            const SizedBox(height: 120),
            SlideTransition(
              position: _offsetAnimation,
              child: Image.asset(
                'assets/images/image-ai.png',
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            if (_showDetails) ...[
              const Text(
                '내 활동에 기록된 내용으로\nKnowMe AI가 취업 정보를 \n제공합니다',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF454C53),
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.56,
                ),
              ),
              const SizedBox(height: 102),
              GestureDetector(
                onTap: _analysisController.startAnalysis,
                child: Container(
                  width: 380,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0068E5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      '분석 시작하기',
                      style: TextStyle(
                        color: Color(0xFFF5F5F5),
                        fontSize: 18,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.72,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _analysisController.viewPreviousResult,
                child: Container(
                  width: 380,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xCDD0CFC7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      '이전 결과 보기',
                      style: TextStyle(
                        color: Color(0xFFF5F5F5),
                        fontSize: 18,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.72,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
