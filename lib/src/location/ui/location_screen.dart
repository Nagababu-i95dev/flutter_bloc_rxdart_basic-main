import 'package:flutter/material.dart';

import 'current_location_status.dart';

class LocationScreen extends StatelessWidget {

  static const routeName = '/location';

  const LocationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Location'),
            bottom: TabBar(
              controller: DefaultTabController.of(context),
              tabs: const [
                Tab(
                  icon: Icon(Icons.location_pin),
                  text: 'Current Location',
                ),
                Tab(
                  icon: Icon(Icons.location_searching),
                  text: 'Search Location',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CurrentLocationStatus(),
              CurrentLocationStatus(),
            ],
          ),
        ));
  }
}
