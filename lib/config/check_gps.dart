import 'package:geolocator/geolocator.dart';


class checkGpsActive {
  Future<bool> canGetLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled.
      // You might want to show a message to the user or open location settings.
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied.
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied.
      // You might want to guide the user to app settings.
      return false;
    }

    // GPS is active and permissions are granted.
    return true;
  }
}