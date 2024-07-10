import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

class LocationProvider with ChangeNotifier {
  LocationService _locationService = LocationService();
  late Position _currentPosition;
  late bool _serviceAvailable;

  Position get currentPosition => _currentPosition;
  bool get serviceAvailable => _serviceAvailable;

  Future<void> checkLocationAndService() async {
    try {
      _currentPosition = await _locationService.getCurrentLocation();
      _serviceAvailable = await _locationService.isServiceAvailable(_currentPosition);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
