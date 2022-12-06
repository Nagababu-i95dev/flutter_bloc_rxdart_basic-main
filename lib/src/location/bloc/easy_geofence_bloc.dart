import 'dart:async';

import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:rxdart/rxdart.dart';

class EasyGeofenceBloc {
  final _radius = BehaviorSubject<String>();
  final _position = BehaviorSubject<Position>();
  final _location = BehaviorSubject<location.Location>();

  var geofenceStatusStream = StreamSubscription<GeofenceStatus>;

  final _geofenceStatus = BehaviorSubject<GeofenceStatus>();
  final geolocator = Geolocator();
  final _isReady = BehaviorSubject<bool>();

  Future<void> getCurrentPosition() async {
    print ('In getCurrentPos');
    _position.sink.add(await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high));
    _isReady.sink.add((_position.value != null) ? true : false);
    print('Is Ready ${_isReady.value}');
  }

  setLocation() async {
    await getCurrentPosition();
  }

  // // This function is to be called when the location has changed.
  // Future<void> onLocationChanged(location.Location location) async {
  //   _location.sink.add(location);
  //   getCurrentPosition();
  // }

  bool get readyStatus => _isReady.value;

  Stream<Position> get position => _position.stream;

  Stream<String> get radius => _radius.stream;

  Sink<String> get sinkRadius => _radius.sink;

  Stream<GeofenceStatus> get geofenceStatus => _geofenceStatus.stream;

  startGeofenceService() {
    EasyGeofencing.startGeofenceService(
        //pointedLatitude: _position.value.latitude.toString(),
        //  pointedLongitude: _position.value.longitude.toString(),
        // radiusMeter: _radius.value.toString(),
        pointedLatitude: '17.4615667',
        pointedLongitude: '78.3434917',
        radiusMeter: '500',
        eventPeriodInSeconds: 5);
    // if (_geofenceStatus.hasValue)
    //   print('trial 1 ${_geofenceStatus.value}');
    // else
    //   print('trial1 ${_geofenceStatus.hasValue}');
    // if (!_geofenceStatus.hasValue) {
    //   print('Trial ');
    //
    //       EasyGeofencing.getGeofenceStream()!.listen((GeofenceStatus status) {
    //     print('Status::: ${status.toString()}');
    //
    //     _geofenceStatus.sink.add(status);
    //     print ('updated status ${_geofenceStatus.hasValue}');
    //   }) ;
    // }
  }

  getGeoFenceStream() {
    StreamSubscription<GeofenceStatus> geofenceStatusStream =
        EasyGeofencing.getGeofenceStream()!.listen((GeofenceStatus status) {
      print(status.toString());
    });
    print('geofences stream ${geofenceStatusStream}');
  }
}

final easy_geofence_bloc = EasyGeofenceBloc();
