import 'package:equatable/equatable.dart';
import '../../domain/entities/investment_analysis.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final List<InvestmentAnalysis> analytics;

  const AnalyticsLoaded(this.analytics);

  @override
  List<Object> get props => [analytics];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object> get props => [message];
}
