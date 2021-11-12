abstract class MapState {}

class MapLoaded extends MapState {
  MapLoaded({this.showNavigationButton = false});

  bool showNavigationButton;
}
