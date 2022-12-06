import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:poc_bloc/src/utils/snack_bar_display.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';
import 'package:rxdart/rxdart.dart';

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
    String message='';
    switch (polyGeofenceStatus.name.toString()) {
      case 'ENTER':
        message = 'Entered Geofence';
        break;
      case 'DWELL':
        message = 'Dwelling in Geofence';
        break;
      case 'EXIT':
        message = 'Exited Geofence';
        break;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('status', message);
    FlutterBackgroundService().invoke('statusChanged');
    //NotifyService.showTextNotification(
      //  title: 'Geofence Status', body: message);
    SnackBarDisplay.buildSnackBar(message, true);
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

  initializeGeofence() {
    final _polyGeofenceService = PolyGeofenceService.instance.setup(
        interval: 5000,
        accuracy: 100,
        loiteringDelayMs: 60000,
        statusChangeDelayMs: 10000,
        allowMockLocations: false,
        printDevLog: false);

    // Create a [PolyGeofence] list.
    final _polyGeofenceList = <PolyGeofence>[
      PolyGeofence(
        id: 'Park',
        data: {
          'address': 'Near Botanical Garden',
          'about': '',
        },
        polygon: <LatLng>[
          const LatLng(17.46154, 78.34457),
          const LatLng(17.46079, 78.34423),
          const LatLng(17.46113, 78.34233),
          const LatLng(17.46231, 78.34303),
          const LatLng(17.46256, 78.34425),
        ],
      ),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _polyGeofenceService.addPolyGeofenceStatusChangeListener(
          geofenceBloc.onPolyGeofenceStatusChanged);
      _polyGeofenceService
          .addLocationChangeListener(geofenceBloc.onLocationChanged);
      _polyGeofenceService.addLocationServicesStatusChangeListener(
          geofenceBloc.onLocationServicesStatusChanged);
      _polyGeofenceService.addStreamErrorListener(geofenceBloc.onError);
      _polyGeofenceService
          .start(_polyGeofenceList)
          .catchError(geofenceBloc.onError);
    });
  }
}

final geofenceBloc = GeofenceBloc();
