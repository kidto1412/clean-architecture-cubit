import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadHomeData() async {
    try {
      emit(HomeLoading());

      // Simulate loading data
      await Future.delayed(const Duration(seconds: 1));

      emit(HomeLoaded(
        welcomeMessage: 'Welcome to Analytic Invest',
        recentActivity: [
          'Portfolio updated',
          'New analysis available',
          'Price alert triggered',
        ],
      ));
    } catch (e) {
      emit(HomeError('Failed to load home data: ${e.toString()}'));
    }
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}
