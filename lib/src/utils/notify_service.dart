import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../global.dart';

class NotifyService
{
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInit = const AndroidInitializationSettings('mipmap/ic_launcher');
    var iosInit = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  static showTextNotification({var id = 0,  required String title, required String body,
    var payLoad}) async {
    AndroidNotificationDetails channelSpecification = const AndroidNotificationDetails(
        'GeoFenceStatus', 'GeofenceStatusName',
        playSound: true,
        //sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high
    );
    var notificationDetails = NotificationDetails(
        android: channelSpecification, iOS: const DarwinNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}