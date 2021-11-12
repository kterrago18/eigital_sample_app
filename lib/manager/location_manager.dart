import 'package:location/location.dart';

class LocationManager{
  factory LocationManager()=>_instance;
  LocationManager._();
  static final LocationManager _instance =LocationManager._();

  Location location = Location();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

  Future<void> init()async{
    await requestService();
    await requestPermission();
  }

  Future<void> requestService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
  }

  Future<void> requestPermission()async{
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
  }

  Future<LocationData> getCurrentLocation() async {
    await requestService();
    await requestPermission();
    if(!_serviceEnabled){
      throw Exception('Service is disable');
    }
    if(_permissionGranted==PermissionStatus.denied){
      throw Exception('Access denied!');
    }
    return await location.getLocation();
  }

}