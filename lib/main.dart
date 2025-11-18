import 'package:kunjungan/map/positionMap.dart';
import 'package:kunjungan/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
//import 'package:intl/intl.dart';
import 'package:kunjungan/task/dataSync.dart';
import 'package:kunjungan/task/locationTracking.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//import 'firebase_options.dart';


@pragma('vm:entry-point')
Future<void> callbackDispatcher() async {

  var lt = locationTracking();
  var data_sync = dataSync();
  /*
  if(await _handlePermission()) {
  Position post = await Geolocator.getCurrentPosition();
  print("Lat: ${post.latitude}");
  }

   */

  Workmanager().executeTask((task, inputData) async {
    // Your background task logic here
    switch (task) {
      case "LocationTracking":
        print("LocationTracking Task");
        return await lt.doWorkGetLocation();
        // Perform your periodic task operation
      case "SendData":
        print("Send DataSync Task");
        return await data_sync.doWork();
        //return Future.value(true);
      case "LocationTracking2":
        print("LocationTracking1 Task");
        return await lt.doWorkGetLocation();
      default:
        print("Unknown Task");
        return Future.value(false);
    // Add other task cases if needed
    }
  });
}


Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'KUNJUNGAN', // id
    'KUNJUNGAN SERVICE', // title
    description:
    'Ini adalah service dari sistem KUNJUNGAN', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'KUNJUNGAN',
      initialNotificationTitle: 'KUNJUNGAN SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<List<PositionMap>> streamStart() async {
  List <PositionMap> pm = [];
  StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    ),
  ).listen(
      (Position position){
        double speedinMps = position.speed;
        double speedinKmph = speedinMps * 3.6;
        PositionMap pos = PositionMap(position.latitude.toString(), position.longitude.toString(), speedinKmph.toString(), "toServer");
        pm.add(pos);
  });

  return pm;
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();


  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  /// Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  /// For flutter prior to version 3.0.0
  /// We have to register the plugin manually


  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  /// bring to foreground
  Timer.periodic(const Duration(minutes: 15), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'KUNJUNGAN SERVICE',
          'Date: ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'KUNJUNGAN',
              'KUNJUNGAN SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        // if you don't using custom notification, uncomment this
        service.setForegroundNotificationInfo(
          title: "Kunjungan Service",
          content: "Updated at ${DateTime.now()}",
        );
      }
    }

    /// you can see this log in logcat
    /// debugPrint('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
    List<PositionMap> pmList = await streamStart();
    if(pmList.length > 0){
      for(int i=0; i < pmList.length ; i++) {
        print(pmList[i].latitude);
      }
    }

    Position? prev_pos = await Geolocator.getLastKnownPosition();
    Position? curr_pos = await Geolocator.getCurrentPosition();
    print("Current Pos Lat:${curr_pos.latitude.toString()}, Long:${curr_pos.longitude.toString()}");

    if(prev_pos != null) {
      print("Prev Pos Lat:${prev_pos.latitude.toString()}, Long:${prev_pos.longitude.toString()}");
      double distanceMeters = await Geolocator.distanceBetween(curr_pos.latitude.toDouble(),
          curr_pos.longitude.toDouble(), prev_pos.latitude.toDouble(), prev_pos.longitude.toDouble());
      print("Distance: ${distanceMeters.toString()}");
      /// if distance more than 10 meter then update in database
      if(distanceMeters > 10){
        print("POSITION UPDATE");
        locationTracking lt = new locationTracking();
        lt.saveLocation(curr_pos);
      }
    }


    /// test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    } else if (Platform.isIOS) {
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

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  /// disable landscape rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// INITIASIZE BACKGROUND SERVICE FOR LOCATION
  await initializeService();

  /// initialise WORKMMANAGER
  await Workmanager().initialize(callbackDispatcher);

  Workmanager().registerOneOffTask(
    'kunjunganTask3', // Unique name
    'LocationTracking2',// Task name matching callbackDispatcher
    initialDelay: Duration(seconds: 10),
    tag: "location-tasks1",
    // Optional parameters like initialDelay, constraints, inputData, and tag
  );
  /*
  Workmanager().registerPeriodicTask(
    'kunjunganTask1', // Unique name
    'LocationTracking',// Task name matching callbackDispatcher
    frequency: Duration(minutes: 15), // Minimum 15 minutes
    tag: "location-tasks",
    // Optional parameters like initialDelay, constraints, inputData, and tag
  );*/

  Workmanager().registerPeriodicTask(
    'kunjunganTask2', // Unique name
    'SendData',// Task name matching callbackDispatcher
    frequency: Duration(minutes: 17), // Minimum 15 minutes
    tag: "Datasync-tasks",
    // Optional parameters like initialDelay, constraints, inputData, and tag
    constraints: Constraints(
      networkType: NetworkType.connected,      // Require internet connection
      requiresBatteryNotLow: true,            // Don't run when battery is low
      requiresCharging: false,                // Can run when not charging
      requiresDeviceIdle: false,              // Can run when device is active
      requiresStorageNotLow: true,            // Don't run when storage is low
    ),
  );


  runApp(const MyApp());
}

Future<bool> _handlePermission() async {
  final hasPermission = await Geolocator.checkPermission();

  if (hasPermission == LocationPermission.deniedForever) {
    print("The permission to access the device location was denied forever!");
    return false;
  }

  if (hasPermission == LocationPermission.denied){
    final hasFinalPermission = await Geolocator.requestPermission();
    if (hasFinalPermission == LocationPermission.denied ||
        hasFinalPermission == LocationPermission.deniedForever) {
      print("The permission to access the device location was denied!");
      return false;
    }
  }

  if (!await Geolocator.isLocationServiceEnabled()) {
    print("The location services of the device are not enabled!");
    return false;
  }
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kunjungan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const WelcomePage(title: 'Welcome'),
    );
  }
}

