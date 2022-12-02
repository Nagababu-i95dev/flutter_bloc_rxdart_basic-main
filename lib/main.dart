// @dart=2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poc_bloc/src/app.dart';
import 'package:poc_bloc/src/utils/routes.dart';
import 'global.dart';
import 'package:poc_bloc/src/utils/color.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POC',
      scaffoldMessengerKey: snackBarKey,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        errorColor: Colors.red,
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: ColorUtils.WARNING_COLOR,
          elevation: 10,
          contentTextStyle: TextStyle(color: Colors.black, fontSize: 10),
          actionTextColor: Colors.red,
        ),
      ),
      home: App(),
      onGenerateRoute: CommonRoutes.generateRoutes,
    );
  }
}
