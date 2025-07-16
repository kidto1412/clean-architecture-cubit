import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/investment_analysis_model.dart';
import 'analytics_datasource.dart';

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final Dio dio;

  AnalyticsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<InvestmentAnalysisModel>> getAnalytics() async {
    try {
      final response = await dio.get('/analytics');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data'] ?? [];
        return jsonList
            .map((json) => InvestmentAnalysisModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Failed to fetch analytics');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }

  @override
  Future<InvestmentAnalysisModel> getAnalysisById(String id) async {
    try {
      final response = await dio.get('/analytics/$id');

      if (response.statusCode == 200) {
        return InvestmentAnalysisModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to fetch analysis');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }

  @override
  Future<InvestmentAnalysisModel> getAnalysisBySymbol(String symbol) async {
    try {
      final response = await dio.get('/analytics/symbol/$symbol');

      if (response.statusCode == 200) {
        return InvestmentAnalysisModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to fetch analysis for symbol');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }

  @override
  Future<void> saveAnalysis(InvestmentAnalysisModel analysis) async {
    try {
      final response = await dio.post(
        '/analytics',
        data: analysis.toJson(),
      );

      if (response.statusCode != 201) {
        throw ServerException('Failed to save analysis');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAnalysis(String id) async {
    try {
      final response = await dio.delete('/analytics/$id');

      if (response.statusCode != 200) {
        throw ServerException('Failed to delete analysis');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }
}

class AnalyticsLocalDataSourceImpl implements AnalyticsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String analyticsKey = 'cached_analytics';

  AnalyticsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<InvestmentAnalysisModel>> getCachedAnalytics() async {
    try {
      final jsonString = sharedPreferences.getString(analyticsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((json) => InvestmentAnalysisModel.fromJson(json))
            .toList();
      } else {
        throw CacheException('No cached analytics found');
      }
    } catch (e) {
      throw CacheException('Failed to load cached analytics: ${e.toString()}');
    }
  }

  @override
  Future<InvestmentAnalysisModel> getCachedAnalysisById(String id) async {
    try {
      final analytics = await getCachedAnalytics();
      final analysis = analytics.firstWhere(
        (analysis) => analysis.id == id,
        orElse: () => throw CacheException('Analysis not found in cache'),
      );
      return analysis;
    } catch (e) {
      throw CacheException('Failed to load cached analysis: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheAnalytics(List<InvestmentAnalysisModel> analytics) async {
    try {
      final jsonString = json.encode(
        analytics.map((analysis) => analysis.toJson()).toList(),
      );
      await sharedPreferences.setString(analyticsKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache analytics: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheAnalysis(InvestmentAnalysisModel analysis) async {
    try {
      List<InvestmentAnalysisModel> analytics = [];
      try {
        analytics = await getCachedAnalytics();
      } catch (_) {
        // No cached analytics, start with empty list
      }

      // Remove existing analysis with same id if exists
      analytics.removeWhere((item) => item.id == analysis.id);
      // Add new analysis
      analytics.add(analysis);

      await cacheAnalytics(analytics);
    } catch (e) {
      throw CacheException('Failed to cache analysis: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(analyticsKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
