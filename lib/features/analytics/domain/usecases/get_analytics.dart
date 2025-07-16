import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/investment_analysis.dart';
import '../repositories/analytics_repository.dart';

class GetAnalytics implements UseCase<List<InvestmentAnalysis>, NoParams> {
  final AnalyticsRepository repository;

  GetAnalytics(this.repository);

  @override
  Future<Either<Failure, List<InvestmentAnalysis>>> call(
      NoParams params) async {
    return await repository.getAnalytics();
  }
}
