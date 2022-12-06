// @dart=2.9
import 'dart:async';
import 'dart:ui';
import 'dart:io' ;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_bloc/src/app.dart';
import 'package:poc_bloc/src/location/bloc/geofence_bloc.dart';
import 'package:poc_bloc/src/utils/notify_service.dart';
import 'package:poc_bloc/src/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global.dart';
import 'package:poc_bloc/src/utils/color.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  NotifyService.initialize(flutterLocalNotificationsPlugin);
  geofenceBloc.initializeGeofence();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 0,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      //onBackground: onIosBackground,
    ),
  );

  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
//
// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.reload();
//   final log = preferences.getStringList('log') ?? <String>[];
//   log.add(DateTime.now().toIso8601String());
//   await preferences.setStringList('log', log);
//
//   return true;
// }

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.setString("hello", "world");
  //
  // /// OPTIONAL when use custom notification
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('statusChanged').listen((event) async {
      if (service is AndroidServiceInstance){
        if (await service.isForegroundService()) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.reload();
          final message = preferences.getString('status');
          NotifyService.showTextNotification(title: 'Status Changed', body: message);
          print('Status changed received ::: $message');
        }
      }
     // NotifyService.showTextNotification(title: 'Status Changed', body: 'Awesome ${DateTime.now()}');
      print ('Status changed');
      //NotifyService.showTextNotification(title: 'Status Changed', body: message);

    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  //bring to foreground
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    // if (service is AndroidServiceInstance) {
    //   print ('Service is AndroidInstance');
    //   if (await service.isForegroundService()) {
    //     print ('Service is foreground');
    //     service.on('statusChanged').listen((event) async {
    //       SharedPreferences preferences = await SharedPreferences.getInstance();
    //       await preferences.reload();
    //       final message = preferences.getString('status');
    //       NotifyService.showTextNotification(title: 'Status Changed', body: message);
    //       print('Status changed received ::: $message');
    //     });
    //
    //   }
    // }

    /// you can see this log in logcat
   // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotifyService.initialize(flutterLocalNotificationsPlugin);
  await initializeService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var _androidAppRetain = MethodChannel("android_app_retain");

  @override
  Widget build(BuildContext context) {
   //  FlutterBackgroundService().invoke("setAsForeground");
   // // FlutterBackgroundService().invoke("setAsBackground");
   //  FlutterBackgroundService().startService();
   Future<bool> doPop() {
     if (Platform.isAndroid) {
       if (Navigator.of(context).canPop()) {
         return Future.value(true);
       } else {
         _androidAppRetain.invokeMethod("sendToBackground");         return Future.value(false);
       }
     } else {
       return Future.value(true);
     }

   }
    return WillPopScope(
      onWillPop: doPop,
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
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
      ),
    );
  }
}
