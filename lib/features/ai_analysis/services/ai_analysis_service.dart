import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_analysis_model.dart';
import '../models/past_analysis_summary.dart' hide PastAnalysisSummary; // 새 모델 import

class AiAnalysisService {
  final String baseUrl = 'http://server.tunnel.jaram.net';

  /// 1단계: 포트폴리오 분석 요청 → 전체 응답 JSON 반환
  Future<Map<String, dynamic>?> requestPortfolioAnalysis(int userId) async {
    final url = Uri.parse('$baseUrl/api/ai/analyze/portfolio');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // 🔁 전체 JSON 반환
    } else {
      print('분석 요청 실패: ${response.statusCode}');
      return null;
    }
  }

  /// 2단계: 분석 결과 조회 → 전체 응답 JSON 반환
  Future<Map<String, dynamic>?> fetchAnalysisResult(int analysisId) async {
    final url = Uri.parse('$baseUrl/api/ai/analysis/$analysisId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // 🔁 전체 JSON 반환
    } else {
      print('결과 조회 실패: ${response.statusCode}');
      return null;
    }
  }
  /// 🔁 모든 과거 분석 요약 목록 조회
  Future<List<PastAnalysisSummary>?> fetchAllPastAnalysis(int userId) async {
    final url = Uri.parse('$baseUrl/api/ai/analyses/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => PastAnalysisSummary.fromJson(e)).toList();
    } else {
      print('과거 분석 결과 조회 실패: ${response.statusCode}');
      return null;
    }
  }

  /// 🔁 3단계: 모든 포트폴리오 분석 결과 요약 조회 (userId 기준)
  Future<List<PastAnalysisSummary>> fetchAllAnalysisSummaries(int userId) async {
    final url = Uri.parse('$baseUrl/api/ai/analyses/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PastAnalysisSummary.fromJson(e)).toList();
    } else {
      print('모든 분석 요약 조회 실패: ${response.statusCode}');
      return [];
    }
  }
}
