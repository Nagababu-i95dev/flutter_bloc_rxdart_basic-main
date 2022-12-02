import 'dart:async';

import 'package:poc_bloc/src/utils/snack_bar_display.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../utils/notify_service.dart';

class GeofenceBloc {
  final _geofenceStatus = BehaviorSubject<PolyGeofenceStatus>();
  final _location = BehaviorSubject<Location>();

  Stream<PolyGeofenceStatus> get geofenceStatus => _geofenceStatus.stream;

  Stream<Location> get locationPoints => _location.stream;

  PolyGeofence? get polyGeofence => null;

  PolyGeofenceStatus? get polyGeofenceStatus => null;

  // This function is to be called when the geofence status is changed.
  Future<void> onPolyGeofenceStatusChanged(PolyGeofence polyGeofence,
      PolyGeofenceStatus polyGeofenceStatus, Location location) async {
    // print('polyGeofence: ${polyGeofence.toJson()}');
    // print('polyGeofenceStatus: ${polyGeofenceStatus.name.toString()}');

    switch (polyGeofenceStatus.name.toString()) {
      case 'ENTER':
        NotifyService.showTextNotification(title: 'Geofence Status', body: 'Entered Geofence');
        SnackBarDisplay.buildSnackBar('ENTERED GEOFENCE', true);
        break;
      case 'DWELL':
        NotifyService.showTextNotification(title: 'Geofence Status', body: 'Dwelling in Geofence');
        SnackBarDisplay.buildSnackBar('DWELLING IN GEOFENCE', true);
        break;
      case 'EXIT':
        NotifyService.showTextNotification(title: 'Geofence Status', body: 'Exited Geofence');
        SnackBarDisplay.buildSnackBar('EXITED GEOFENCE', false);
        break;
    }
    _geofenceStatus.sink.add(polyGeofenceStatus);
  }

  // This function is to be called when the location has changed.
  Future<void> onLocationChanged(Location location) async {
    _location.sink.add(location);
  }

  // This function is to be called when a location services status change occurs
  // since the service was started.
  void onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
  }

  // This function is used to handle errors that occur in the service.
  void onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }
    print('ErrorCode: $errorCode');
  }
}

final geofenceBloc = GeofenceBloc();
