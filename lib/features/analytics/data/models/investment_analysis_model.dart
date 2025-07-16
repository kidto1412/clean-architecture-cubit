import '../../domain/entities/investment_analysis.dart';

class InvestmentAnalysisModel extends InvestmentAnalysis {
  const InvestmentAnalysisModel({
    required super.id,
    required super.symbol,
    required super.companyName,
    required super.currentPrice,
    required super.targetPrice,
    required super.recommendation,
    required super.riskScore,
    required super.analysisDate,
    required super.metrics,
  });

  factory InvestmentAnalysisModel.fromJson(Map<String, dynamic> json) {
    return InvestmentAnalysisModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      companyName: json['company_name'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      targetPrice: (json['target_price'] as num).toDouble(),
      recommendation: json['recommendation'] as String,
      riskScore: (json['risk_score'] as num).toDouble(),
      analysisDate: DateTime.parse(json['analysis_date'] as String),
      metrics: Map<String, dynamic>.from(json['metrics'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'company_name': companyName,
      'current_price': currentPrice,
      'target_price': targetPrice,
      'recommendation': recommendation,
      'risk_score': riskScore,
      'analysis_date': analysisDate.toIso8601String(),
      'metrics': metrics,
    };
  }
}
