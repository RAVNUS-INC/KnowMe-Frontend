import 'package:get/get.dart';
import '../views/ai_analysis_result_screen.dart';
import '../views/ai_analysis_result_previous_screen.dart';

class AiAnalysisController extends GetxController {
  void startAnalysis() {
    Get.to(() => const AiAnalysisResultScreen());
  }

  void viewPreviousResult() {
    Get.to(() => const AiAnalysisResultPreviousScreen());
  }
}
