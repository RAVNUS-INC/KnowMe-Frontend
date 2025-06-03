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
