import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';

import 'package:eigital_sample_app/manager/location_manager.dart';
import 'package:eigital_sample_app/views/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:vector_math/vector_math.dart' hide Colors;

import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapLoaded()) {
    initializeCurrentLocation();
  }
  final Completer<GoogleMapController> controller = Completer();
  final CameraPosition defaultPosition = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 14.4746,
  );

  final Set<Marker> markers = <Marker>{};
  final double meterRadius = 10000; //10KM
  LatLng randomLocation = const LatLng(0.0, 0.0);
  LatLng currentLocation = const LatLng(0.0, 0.0);
  double totalDistance = 0.0;

  late PolylinePoints polylinePoints;

  List<LatLng> polylineCoordinates = [];

  Map<PolylineId, Polyline> polylines = {};

  Future<void> initializeCurrentLocation() async {
    await setCurrentLocation();
    animateLocation(currentLocation);
  }

  Future<void> setCurrentLocation() async {
    try {
      final LocationData locationData =
          await LocationManager().getCurrentLocation();

      currentLocation =
          LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> generateRandomLocation() async {
    try {
      resetPolyLines();
      await setCurrentLocation();
      randomLocation = getRandomLocation(meterRadius, currentLocation);

      calculateDistance(randomLocation, currentLocation);

      animateLocation(randomLocation);
      emit(MapLoaded(showNavigationButton: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> animateLocation(LatLng location, {double zoom = 15}) async {
    final CameraPosition _cameraPosition =
        CameraPosition(target: location, zoom: zoom);

    final GoogleMapController mapController = await controller.future;
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  void resetPolyLines() {
    polylineCoordinates = [];
    polylines = {};
  }

  // Add Markers to Map
  Set<Marker> createMarker() {
    return {
      Marker(
        markerId: const MarkerId('m1'),
        position: currentLocation,
        infoWindow: const InfoWindow(title: 'User location'),
      ),
      Marker(
        markerId: const MarkerId('m2'),
        position: randomLocation,
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(90),
      ),
    };
  }

  Future<void> createPolylines() async {
    polylinePoints = PolylinePoints();

    final PolylineResult result =
        await polylinePoints.getRouteBetweenCoordinates(
      Constants.googleMapApiKey,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(randomLocation.latitude, randomLocation.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      debugPrint('## No route found');
    }

    const PolylineId id = PolylineId('poly');

    final Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );

    polylines[id] = polyline;

    emit(MapLoaded(showNavigationButton: true));
    animateLocation(randomLocation, zoom: 13);
  }

// Calculating distance between two coordinates
// https://stackoverflow.com/a/54138876/11910277
  void calculateDistance(LatLng randomLocation, LatLng currentLocation) {
    var decimalDegree = 0.017453292519943295; //PI/180
    var c = cos;
    var a = 0.5 -
        c((randomLocation.latitude - currentLocation.latitude) *
                decimalDegree) /
            2 +
        c(currentLocation.latitude * decimalDegree) *
            c(randomLocation.latitude * decimalDegree) *
            (1 -
                c((randomLocation.longitude - currentLocation.longitude) *
                    decimalDegree)) /
            2;
    totalDistance = 12742 * asin(sqrt(a));
  }

  LatLng getRandomLocation(double radiusInMeters, LatLng currentLocation) {
    final double x0 = currentLocation.longitude;
    final double y0 = currentLocation.latitude;

    final Random random = Random();

    final double radiusInDegrees = radiusInMeters / 111320;

    final double u = random.nextDouble();
    final double v = random.nextDouble();
    final double w = radiusInDegrees * sqrt(u);
    final double t = 2 * pi * v;

    final double x = w * cos(t);
    final double y = w * sin(t);

    final double newX = x / cos(radians(y0));

    double foundLatitude;
    double foundLongitude;

    foundLatitude = y0 + y;
    foundLongitude = x0 + newX;

    return LatLng(foundLatitude, foundLongitude);
  }
}
