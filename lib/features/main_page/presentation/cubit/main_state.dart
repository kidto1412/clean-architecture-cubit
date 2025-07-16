import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainTabChanged extends MainState {
  final int selectedIndex;

  const MainTabChanged(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}
