// ✅ Controller
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/past_analysis_summary.dart';
import '../services/ai_analysis_service.dart';

class PreviousResultController extends GetxController {
  final previousResults = <Map<String, String>>[].obs;
  final _service = AiAnalysisService();
  final int userId = 1; // 실제 사용자 ID로 교체

  @override
  void onInit() {
    super.onInit();
    loadPreviousResults();
  }

  void loadPreviousResults() async {
    final response = await _service.fetchAllPastAnalysis(userId);

    if (response != null) {
      final formatted = response.map((e) {
        final date = DateFormat('yyyy년 M월 d일').format(e.completedAt);
        return {
          'date': '$date에 생성된 분석',
          'record': '${e.activitiesCount}개의 활동 기록',
        };
      }).toList();

      previousResults.value = formatted;
    }
  }
}

