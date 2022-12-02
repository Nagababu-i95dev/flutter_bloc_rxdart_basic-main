// @dart=2.9

import 'package:flutter/material.dart';
import 'package:poc_bloc/src/app.dart';
import 'package:poc_bloc/src/ui/movie_detail.dart';
import 'package:poc_bloc/src/ui/movie_list.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Movie Data base',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            errorColor: Colors.red,

          ),
          home: App(),
          routes: {
            MovieList.routeName: (context) => MovieList(),
            MovieDetails.routeName: (context) => MovieDetails()
          });

  }
}
