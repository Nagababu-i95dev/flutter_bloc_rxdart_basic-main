// ignore_for_file: prefer_const_constructors

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:poc_bloc/src/location/ui/location_screen.dart';
import 'package:poc_bloc/src/login/ui/login_screen.dart';
import 'package:poc_bloc/src/utils/notify_service.dart';
import 'package:poc_bloc/src/utils/snack_bar_display.dart';
import '../global.dart';
import 'common/blocs/connectivity_bloc.dart';
import 'movies/ui/movie_list.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late String _message = '';
  late bool _internetStatus = false;

  @override
  void initState() {
    connectivityBloc.checkInternetConnection();
    connectivityBloc.internetStatus.listen((data) {
      switch (data)
      {
        case ConnectivityResult.wifi:
        setState(() {
          _message = 'Internet Connect Restored';
          _internetStatus = true;
        });
        break;
        case ConnectivityResult.none:
        setState(() {
          _message = 'No Internet Connection';
          _internetStatus = false;
        });

        break;
        case ConnectivityResult.bluetooth:
          // TODO: Handle this case.
          break;
        case ConnectivityResult.ethernet:
          // TODO: Handle this case.
          break;
        case ConnectivityResult.mobile:
          // TODO: Handle this case.
          break;
        case ConnectivityResult.vpn:
          // TODO: Handle this case.
          break;
      }
      setState(() {});
      SnackBarDisplay.buildSnackBar(_message, _internetStatus);
    });
    NotifyService.initialize(flutterLocalNotificationsPlugin);

    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies DB'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              TextButton(
                child: Text(
                  'Get List of movies',
                  style: TextStyle(fontSize: 20,),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(MovieList.routeName);
                },
              ),
              TextButton(
                child: Text(
                  'Login Form',
                  style: TextStyle(fontSize: 20,),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                },
              ),
              TextButton(
                child: Text(
                  'Location',
                  style: TextStyle(fontSize: 20,),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(LocationScreen.routeName);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
