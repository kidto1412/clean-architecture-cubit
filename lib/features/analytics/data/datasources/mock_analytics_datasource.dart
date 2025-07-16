import '../models/investment_analysis_model.dart';
import 'analytics_datasource.dart';

class MockAnalyticsRemoteDataSource implements AnalyticsRemoteDataSource {
  @override
  Future<List<InvestmentAnalysisModel>> getAnalytics() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    return [
      InvestmentAnalysisModel(
        id: '1',
        symbol: 'AAPL',
        companyName: 'Apple Inc.',
        currentPrice: 175.43,
        targetPrice: 200.00,
        recommendation: 'Buy',
        riskScore: 7.5,
        analysisDate: DateTime.now().subtract(const Duration(days: 1)),
        metrics: {
          'pe_ratio': 28.5,
          'debt_to_equity': 1.73,
          'revenue_growth': 8.1,
        },
      ),
      InvestmentAnalysisModel(
        id: '2',
        symbol: 'GOOGL',
        companyName: 'Alphabet Inc.',
        currentPrice: 2420.87,
        targetPrice: 2600.00,
        recommendation: 'Buy',
        riskScore: 6.8,
        analysisDate: DateTime.now().subtract(const Duration(days: 2)),
        metrics: {
          'pe_ratio': 24.2,
          'debt_to_equity': 0.12,
          'revenue_growth': 12.3,
        },
      ),
      InvestmentAnalysisModel(
        id: '3',
        symbol: 'TSLA',
        companyName: 'Tesla, Inc.',
        currentPrice: 248.50,
        targetPrice: 220.00,
        recommendation: 'Hold',
        riskScore: 9.2,
        analysisDate: DateTime.now().subtract(const Duration(hours: 12)),
        metrics: {
          'pe_ratio': 45.8,
          'debt_to_equity': 0.05,
          'revenue_growth': 37.2,
        },
      ),
      InvestmentAnalysisModel(
        id: '4',
        symbol: 'MSFT',
        companyName: 'Microsoft Corporation',
        currentPrice: 378.85,
        targetPrice: 420.00,
        recommendation: 'Buy',
        riskScore: 5.4,
        analysisDate: DateTime.now().subtract(const Duration(days: 3)),
        metrics: {
          'pe_ratio': 32.1,
          'debt_to_equity': 0.31,
          'revenue_growth': 14.7,
        },
      ),
      InvestmentAnalysisModel(
        id: '5',
        symbol: 'AMZN',
        companyName: 'Amazon.com, Inc.',
        currentPrice: 3342.88,
        targetPrice: 3100.00,
        recommendation: 'Sell',
        riskScore: 8.1,
        analysisDate: DateTime.now().subtract(const Duration(hours: 6)),
        metrics: {
          'pe_ratio': 52.3,
          'debt_to_equity': 0.34,
          'revenue_growth': 9.4,
        },
      ),
    ];
  }

  @override
  Future<InvestmentAnalysisModel> getAnalysisById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final analytics = await getAnalytics();
    return analytics.firstWhere((analysis) => analysis.id == id);
  }

  @override
  Future<InvestmentAnalysisModel> getAnalysisBySymbol(String symbol) async {
    await Future.delayed(const Duration(seconds: 1));
    final analytics = await getAnalytics();
    return analytics.firstWhere((analysis) => analysis.symbol == symbol);
  }

  @override
  Future<void> saveAnalysis(InvestmentAnalysisModel analysis) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock save operation
  }

  @override
  Future<void> deleteAnalysis(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock delete operation
  }
}
