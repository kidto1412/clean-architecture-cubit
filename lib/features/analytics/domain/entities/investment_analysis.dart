import 'package:equatable/equatable.dart';

class InvestmentAnalysis extends Equatable {
  final String id;
  final String symbol;
  final String companyName;
  final double currentPrice;
  final double targetPrice;
  final String recommendation;
  final double riskScore;
  final DateTime analysisDate;
  final Map<String, dynamic> metrics;

  const InvestmentAnalysis({
    required this.id,
    required this.symbol,
    required this.companyName,
    required this.currentPrice,
    required this.targetPrice,
    required this.recommendation,
    required this.riskScore,
    required this.analysisDate,
    required this.metrics,
  });

  @override
  List<Object> get props => [
        id,
        symbol,
        companyName,
        currentPrice,
        targetPrice,
        recommendation,
        riskScore,
        analysisDate,
        metrics,
      ];
}
