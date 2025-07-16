import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/investment_analysis.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, List<InvestmentAnalysis>>> getAnalytics();
  Future<Either<Failure, InvestmentAnalysis>> getAnalysisById(String id);
  Future<Either<Failure, InvestmentAnalysis>> getAnalysisBySymbol(
      String symbol);
  Future<Either<Failure, void>> saveAnalysis(InvestmentAnalysis analysis);
  Future<Either<Failure, void>> deleteAnalysis(String id);
}
