import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
final service = FlutterBackgroundService();