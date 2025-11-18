import 'dart:async';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kunjungan/config/localDb.dart';
import 'package:kunjungan/map/user_tracking_map.dart';

// Example Worker 1
class locationTracking{
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  Future<bool> doWorkGetLocation() async {
    // Logic for MyWorker1
    bool isLocated = true;
    isLocated = await _getCurrentPosition();
    if(isLocated){
      return true;
    }
    return false;
  }

  Future<bool> _getCurrentPosition() async {

    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return false;
    }

    Position position = await _geolocatorPlatform.getCurrentPosition(locationSettings: locationSettings);

    await saveLocation(position);
    print(position == null ? 'Unknown, Update: ${DateTime.now()}' : '${position.latitude.toString()}, ${position.longitude.toString()}, Update: ${DateTime.now()}');
    return true;

  }

  Future<void> saveLocation(Position pst) async {
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }
    var date = DateTime.now();
    var day = date.day.toInt();
    var month = date.month.toInt();
    var year = date.year.toInt();
    var hour = date.hour.toInt();
    var minute = date.minute.toInt();
    var second = date.minute.toInt();
    String dt = "$day/$month/$year";
    String tm = "$hour:$minute:$second";
    var db = localDb();
    trackUserMap trkUser = new trackUserMap(device!, pst.latitude.toString(), pst.longitude.toString(), dt, tm, "toServer");
    //trackUserMap trkUser = new trackUserMap(_username, _lat, _long, _track_date, _track_time, _track_server)
    print("device: ${trkUser.device}");
    print("Lat: ${trkUser.latitude_track}");
    int i = await db.saveUserTracking(trkUser);
    print(i.toString());
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

}