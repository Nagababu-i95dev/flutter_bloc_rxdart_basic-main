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

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    String latitude = '0';
    String longitude = '0';
    bool _isFreshList = false;

    return StreamBuilder<Location>(
        stream: geofenceBloc.locationPoints,
        builder: (context, curPos) {

          if (curPos.data != null) {
            return SafeArea(
              child: ListView(children: <Widget>[
                // Container(
                //   alignment: Alignment.centerLeft,
                //     margin: const EdgeInsets.symmetric(
                //         vertical: 10, horizontal: 15),
                //     child: TextFormField(
                //       onChanged: (val) {latitude = val;
                //       },
                //       decoration: InputDecoration(
                //           border: const OutlineInputBorder(),
                //           labelText: 'Latitude',
                //       ),
                //       style: const TextStyle(
                //           fontSize: 20, fontWeight: FontWeight.bold),
                //     )
                // ),
                // Container(
                //     alignment: Alignment.centerLeft,
                //     margin: const EdgeInsets.symmetric(
                //         vertical: 10, horizontal: 15),
                //
                //     child: TextFormField(
                //       onChanged: (val) {
                //         longitude = val;
                //       },
                //       decoration: InputDecoration(
                //         border: const OutlineInputBorder(),
                //         labelText: 'Longitude',
                //       ),
                //       style: const TextStyle(
                //           fontSize: 20, fontWeight: FontWeight.bold),
                //     )
                // ),
                // ElevatedButton(onPressed: (){
                //   _polyGeofenceList[0].polygon.add(LatLng(
                //       double.parse(latitude), double.parse(longitude)));
                //
                //   if (!_isFreshList) {
                //
                //     _polyGeofenceList[0].polygon.removeAt(0);
                //       _isFreshList = true;
                //   }
                // }, child: Text(' Add Points')),
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
