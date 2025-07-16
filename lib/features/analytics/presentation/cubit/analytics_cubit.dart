import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_analytics.dart';
import '../../../../core/utils/usecase.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GetAnalytics getAnalytics;

  AnalyticsCubit({required this.getAnalytics}) : super(AnalyticsInitial());

  Future<void> loadAnalytics() async {
    try {
      emit(AnalyticsLoading());

      final result = await getAnalytics(NoParams());

      result.fold(
        (failure) =>
            emit(AnalyticsError(failure.message ?? 'Unknown error occurred')),
        (analytics) => emit(AnalyticsLoaded(analytics)),
      );
    } catch (e) {
      emit(AnalyticsError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> refreshAnalytics() async {
    await loadAnalytics();
  }

  void clearError() {
    if (state is AnalyticsError) {
      emit(AnalyticsInitial());
    }
  }
}
