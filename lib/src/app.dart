// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'ui/movie_list.dart';

class App extends StatelessWidget {
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
              Container(

                child: TextButton(
                  child: Text(
                    'Get List of movies',
                    style: TextStyle(fontSize: 20,),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(MovieList.routeName);
                  },
                ),
              ),
            ],
          )
    );
  }
}
