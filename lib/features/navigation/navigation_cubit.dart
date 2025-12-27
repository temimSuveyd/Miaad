import 'package:flutter_bloc/flutter_bloc.dart';

// Navigation State
class NavigationState {
  final int currentIndex;

  const NavigationState({required this.currentIndex});

  NavigationState copyWith({int? currentIndex}) {
    return NavigationState(currentIndex: currentIndex ?? this.currentIndex);
  }
}

// Navigation Cubit
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(currentIndex: 0));

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  int get currentIndex => state.currentIndex;
}
