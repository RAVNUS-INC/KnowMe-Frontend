import 'dart:async';
import 'package:get/get.dart';
import '../models/ai_analysis_model.dart';
import '../services/ai_analysis_service.dart';

class AiAnalysisResultController extends GetxController {
  final _service = AiAnalysisService();
  final RxBool isLoading = true.obs;

  final Rx<AnalysisResult?> result = Rx<AnalysisResult?>(null);
  final RxInt activitiesCount = 0.obs;
  final int userId;

  AiAnalysisResultController(this.userId);

  @override
  void onReady() {
    super.onReady();
    startFullAnalysisFlow();
  }

  Future<void> startFullAnalysisFlow() async {
    isLoading.value = true;
    result.value = null;

    final postRes = await _service.requestPortfolioAnalysis(userId);
    final analysisId = postRes?['analysisId'];
    final count = postRes?['activitiesCount'];

    if (analysisId == null) {
      isLoading.value = false;
      return;
    }

    activitiesCount.value = count ?? 0;

    while (true) {
      final getRes = await _service.fetchAnalysisResult(analysisId);
      if (getRes != null) {
        result.value = AnalysisResult.fromJson(getRes);
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }

    isLoading.value = false;
  }

  void goToRecommendation() {
    Get.offAllNamed('/recommendation');
  }
}
