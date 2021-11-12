abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  HomeScreenLoaded(this.index);

  final int index;
}
