import '../models/investment_analysis_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<List<InvestmentAnalysisModel>> getAnalytics();
  Future<InvestmentAnalysisModel> getAnalysisById(String id);
  Future<InvestmentAnalysisModel> getAnalysisBySymbol(String symbol);
  Future<void> saveAnalysis(InvestmentAnalysisModel analysis);
  Future<void> deleteAnalysis(String id);
}

abstract class AnalyticsLocalDataSource {
  Future<List<InvestmentAnalysisModel>> getCachedAnalytics();
  Future<InvestmentAnalysisModel> getCachedAnalysisById(String id);
  Future<void> cacheAnalytics(List<InvestmentAnalysisModel> analytics);
  Future<void> cacheAnalysis(InvestmentAnalysisModel analysis);
  Future<void> clearCache();
}
