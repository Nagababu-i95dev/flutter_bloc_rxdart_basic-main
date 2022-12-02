import 'package:flutter/material.dart';
import 'package:poc_bloc/src/location/bloc/location_bloc.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';
import '../bloc/geofence_bloc.dart';

class CurrentLocationStatus extends StatefulWidget {
  const CurrentLocationStatus({super.key});

  @override
  State<CurrentLocationStatus> createState() => _CurrentLocationStatusState();
}

class _CurrentLocationStatusState extends State<CurrentLocationStatus> {
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
        const LatLng(17.46159, 78.34296),
        const LatLng(17.46182, 78.34264),
        const LatLng(17.46171, 78.34330),
        const LatLng(17.46158, 78.34360),
        const LatLng(17.46137, 78.34353),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _polyGeofenceService.addPolyGeofenceStatusChangeListener( geofenceBloc.onPolyGeofenceStatusChanged);
      _polyGeofenceService.addLocationChangeListener(geofenceBloc.onLocationChanged);
      _polyGeofenceService.addLocationServicesStatusChangeListener(geofenceBloc.onLocationServicesStatusChanged);
      _polyGeofenceService.addStreamErrorListener(geofenceBloc.onError);
      _polyGeofenceService.start(_polyGeofenceList).catchError(geofenceBloc.onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Location>(
        stream: geofenceBloc.locationPoints,
        builder: (context, curPos) {
          if (curPos.data != null) {
            return SafeArea(
              child: ListView(children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: Text(
                      'LAT : ${curPos.data!.latitude}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: Text(
                      'LNG : ${curPos.data!.longitude}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: buildAddress(curPos.data!)),
                const SizedBox(
                  height: 10,
                ),
              ]),
            );
          } else {
            return Text('${curPos.error}');
          }
        });
  }

  Widget buildAddress(Location curPos) {
    locationBloc.fetchAddressFromLatLong(curPos.latitude, curPos.longitude);
    return StreamBuilder<String>(
        stream: locationBloc.address,
        builder: (context, snapshot) {
          return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Address: ${snapshot.data}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ));
        });
  }
}
