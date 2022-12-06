import 'package:flutter/material.dart';
import 'package:poc_bloc/src/app.dart';
import '../location/ui/location_screen.dart';
import '../login/ui/login_screen.dart';
import '../movies/ui/movie_detail.dart';
import '../movies/ui/movie_list.dart';

class CommonRoutes {
  static Route<dynamic> generateRoutes(RouteSettings settings)
  {
    if (settings.name ==  '/') return MaterialPageRoute(builder: (context) => App());
    if (settings.name == MovieList.routeName) return MaterialPageRoute(builder: (context) => MovieList());
    if (settings.name == MovieDetails.routeName) return MaterialPageRoute(builder: (context) => const MovieDetails());
    if (settings.name == LoginScreen.routeName) return MaterialPageRoute(builder: (context) => LoginScreen());
    if (settings.name == LocationScreen.routeName) return MaterialPageRoute(builder: (context) => const LocationScreen());
    // if (settings.name == NearByPlacesScreen.routeName){
    //   final args = settings.arguments as Coordinates;
    //
    //   return MaterialPageRoute(builder: (context) {
    //     return NearByPlacesScreen(
    //       coordinates: args,
    //     );
    //   },);
    // };
    //
    return MaterialPageRoute(builder: (context) => App());
  }
}


