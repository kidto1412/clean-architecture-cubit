import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/investment_analysis.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_datasource.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;
  final AnalyticsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AnalyticsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<InvestmentAnalysis>>> getAnalytics() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAnalytics = await remoteDataSource.getAnalytics();
        await localDataSource.cacheAnalytics(remoteAnalytics);
        return Right(remoteAnalytics);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      try {
        final localAnalytics = await localDataSource.getCachedAnalytics();
        return Right(localAnalytics);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, InvestmentAnalysis>> getAnalysisById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final analysis = await remoteDataSource.getAnalysisById(id);
        await localDataSource.cacheAnalysis(analysis);
        return Right(analysis);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      try {
        final analysis = await localDataSource.getCachedAnalysisById(id);
        return Right(analysis);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, InvestmentAnalysis>> getAnalysisBySymbol(
      String symbol) async {
    try {
      final analysis = await remoteDataSource.getAnalysisBySymbol(symbol);
      await localDataSource.cacheAnalysis(analysis);
      return Right(analysis);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveAnalysis(
      InvestmentAnalysis analysis) async {
    try {
      // Convert entity to model for data layer operations
      // This would typically be done through a mapper
      await remoteDataSource.saveAnalysis(analysis as dynamic);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAnalysis(String id) async {
    try {
      await remoteDataSource.deleteAnalysis(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
