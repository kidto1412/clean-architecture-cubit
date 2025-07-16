import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String welcomeMessage;
  final List<String> recentActivity;

  const HomeLoaded({
    required this.welcomeMessage,
    required this.recentActivity,
  });

  @override
  List<Object> get props => [welcomeMessage, recentActivity];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
