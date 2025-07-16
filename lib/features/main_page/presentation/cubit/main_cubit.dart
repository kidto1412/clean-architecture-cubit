import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainTabChanged(0));

  void changeTab(int index) {
    emit(MainTabChanged(index));
  }

  int get currentIndex {
    if (state is MainTabChanged) {
      return (state as MainTabChanged).selectedIndex;
    }
    return 0;
  }
}
