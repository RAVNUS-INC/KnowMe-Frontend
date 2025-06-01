import 'package:get/get.dart';

class PreviousResultController extends GetxController {
  // 분석 결과 리스트 (임시 데이터)
  final previousResults = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 예시 데이터 삽입
    loadPreviousResults();
  }

  void loadPreviousResults() {
    previousResults.value = [
      {
        'date': '2025년 4월 1일에 생성된 분석',
        'record': '5개의 활동 기록',
      },
      {
        'date': '2025년 3월 20일에 생성된 분석',
        'record': '3개의 활동 기록',
      },
      {
        'date': '2025년 2월 10일에 생성된 분석',
        'record': '4개의 활동 기록',
      },
      {
        'date': '리스트라서',
        'record': '동적으로 추가가능',
      },
    ];
  }

// 나중에 삭제/편집 등 추가 가능
}
