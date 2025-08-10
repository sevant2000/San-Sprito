import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationHelper {
  /// Gets the current location with a cleaned-up, readable address.
  static Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return {'error': 'Location services are disabled.'};
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // If permission is permanently denied
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return {
          'error': 'Location permission is permanently denied. Please allow from settings.'
        };
      }

      // If permission is granted
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isEmpty) {
          return {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'address': 'Unknown location',
          };
        }

        final Placemark place = placemarks.first;

        /// Helper function to check if value is usable
        bool isValid(String? value) {
          return value != null &&
              value.trim().isNotEmpty &&
              !RegExp(r'^[A-Z0-9]+\+[A-Z0-9]+$').hasMatch(value); // filters Plus Code
        }

        final List<String> parts = [
          if (isValid(place.subLocality)) place.subLocality!,
          if (isValid(place.locality)) place.locality!,
          if (isValid(place.subAdministrativeArea)) place.subAdministrativeArea!,
          if (isValid(place.administrativeArea)) place.administrativeArea!,
          if (isValid(place.postalCode)) place.postalCode!,
          if (isValid(place.country)) place.country!,
        ];

        final String address = parts.join(', ');

        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'address': address.isNotEmpty ? address : 'Unknown location',
        };
      }

      await Geolocator.openAppSettings();
      return {'error': 'Location permission not granted.'};
    } catch (e) {
      return {'error': 'Failed to get location: $e'};
    }
  }
}
