class AnalysisStartResponse {
  final int analysisId;
  final int activitiesCount;
  final String message;

  AnalysisStartResponse({
    required this.analysisId,
    required this.activitiesCount,
    required this.message,
  });

  factory AnalysisStartResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisStartResponse(
      analysisId: json['analysisId'],
      activitiesCount: json['activitiesCount'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analysisId': analysisId,
      'activitiesCount': activitiesCount,
      'message': message,
    };
  }
}

class AnalysisResult {
  final String strength;
  final String weakness;
  final String summary;
  final String recommendPosition;

  AnalysisResult({
    required this.strength,
    required this.weakness,
    required this.summary,
    required this.recommendPosition,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      strength: json['strength'],
      weakness: json['weakness'],
      summary: json['summary'],
      recommendPosition: json['recommendPosition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strength': strength,
      'weakness': weakness,
      'summary': summary,
      'recommendPosition': recommendPosition,
    };
  }
}
class PastAnalysisSummary {
  final int analysisId;
  final int activitiesCount;
  final DateTime completedAt;

  PastAnalysisSummary({
    required this.analysisId,
    required this.activitiesCount,
    required this.completedAt,
  });

  factory PastAnalysisSummary.fromJson(Map<String, dynamic> json) {
    return PastAnalysisSummary(
      analysisId: json['analysisId'],
      activitiesCount: json['activitiesCount'],
      completedAt: DateTime.parse(json['completedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analysisId': analysisId,
      'activitiesCount': activitiesCount,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}


