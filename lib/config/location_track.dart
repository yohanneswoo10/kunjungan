import 'dart:async';
import 'location_helper.dart';

class locationTrack {
  final LocationHelper locationHelper = LocationHelper(); // Instance of the location helper class
  late final locationData;
  String userLocation = 'No data';
  String lokasiUser = 'No data';
  Timer? _timer;

  Future<String> start() async {
    String currentLocation = 'No Data';
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      currentLocation = await getLocation();
    });
    return currentLocation;
  }

  /// Fetches the user's location and updates the UI
  Future<String> getLocation() async {
    final locationData =
    await locationHelper.getUserLocation(); // Fetch location

    if (locationData != null) {
        // Format and display the location details
        userLocation =
        'Latitude: ${locationData['latitude']}, Longitude: ${locationData['longitude']}\n'
            'City: ${locationData['city']}, Country: ${locationData['country']}\n'
            'Address: ${locationData['address']}';
        lokasiUser = 'Lat: ${locationData['latitude']}, Long: ${locationData['longitude']}';
        return lokasiUser;
    } else {
        userLocation = 'Location not found'; // Display error message
        return lokasiUser;
    }
  }
}