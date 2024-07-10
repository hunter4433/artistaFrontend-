import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<bool> isServiceAvailable(Position position) async {
    // Make an HTTP request to your server to check service availability
    // Example URL: https://example.com/check_service?lat=${position.latitude}&lng=${position.longitude}
    // Assume the server returns a boolean indicating service availability

    final storage = FlutterSecureStorage();

    await storage.write(key: 'latitude', value: position.latitude.toString());
    await storage.write(key: 'longitude', value: position.longitude.toString());


    final response = await http.get(Uri.parse('http://192.0.0.2:8000/api/check_service?lat=${position.latitude}&lng=${position.longitude}'));

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('serviceAvailable')) {
        return responseBody['serviceAvailable'];
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to check service availability');
    }
  }
}
