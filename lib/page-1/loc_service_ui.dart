import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../config.dart';
import 'location_service.dart';
import 'package:provider/provider.dart';

import 'bottom_nav.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ServiceCheckerPage extends StatefulWidget {
  @override
  _ServiceCheckerPageState createState() => _ServiceCheckerPageState();
}

class _ServiceCheckerPageState extends State<ServiceCheckerPage> {
  late Position _currentPosition;
  TextEditingController textEditingController = TextEditingController();
  late bool _serviceAvailable;
  LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _currentPosition = Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    ); // Initial position
    _serviceAvailable = false; // Initial service availability
  }

  Future<void> useCurrentLocation() async {

    try {
      _currentPosition = await _locationService.getCurrentLocation();
      _serviceAvailable = await _locationService.isServiceAvailable(_currentPosition);
      print(_serviceAvailable);
      sendLocationToBackend();
      setState(() {}); // Update the UI with new state
      if (_serviceAvailable) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav(data: {},)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Service not available in your region.'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    }
  }

  Future<void> convertAddressToLatLng(String textEditingController) async {
    try {
      LocationService locationService = LocationService();
      Position position = await locationService.getLocationFromAddress(textEditingController);
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      _serviceAvailable = await _locationService.isServiceAvailable(position);
      print(_serviceAvailable);
      if (_serviceAvailable) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav(data: {},)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Service not available in your region.'),
        ));
      }
      // Now you can use the latitude and longitude for further operations
    } catch (e) {
      print('Error converting address to coordinates: $e');
      // Handle error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Checker'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Show dialog to choose method
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Choose Checking Method'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          // Show another dialog for entering PINCODE or CITY NAME
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return AlertDialog(
                                    title: Text('Enter PINCODE or CITY NAME'),
                                    content: TextField(
                                      controller: textEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter PINCODE or City Name',
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {
                                        // Update textEditingController value
                                        setState(() {
                                          textEditingController.text = value;
                                        });

                                      },
                                    ),
                                    actions: <Widget>[
                                      TextButton(

                                        onPressed: () {
                                          setState(() {
                                            textEditingController.text = ''; // Clear text field
                                          });
                                          Navigator.pop(context); // Close dialog without value
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // You can handle validation or further actions here
                                          print(textEditingController);
                                          convertAddressToLatLng(textEditingController.text);
                                          setState(() {
                                            textEditingController.text = ''; // Clear text field
                                          });
                                          Navigator.pop(context, textEditingController.text); // Close dialog and handle entered value

                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Enter PINCODE or CITY NAME',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          // Call function to use current location
                          useCurrentLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Use Current Location',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Check Location and Service',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }





  final storage = FlutterSecureStorage();


  // Define your function here
  Future<void> sendLocationToBackend() async {

    Future<String?> _getId() async {
      return await storage.read(key: 'user_id'); // Assuming you stored the token with key 'token'
    }
    Future<String?> _getLatitude() async {
      return await storage.read(key: 'latitude'); // Assuming you stored the token with key 'token'
    }
    Future<String?> _getLongitude() async {
      return await storage.read(key: 'longitude'); // Assuming you stored the token with key 'token'
    }
    String? id = await _getId();
    String? latitude = await _getLatitude();
    String? longitude = await _getLongitude();

    Map<String, dynamic> requestBody = {
      'latitude': latitude,
      'longitude': longitude,

    };
    print('request body is :$requestBody');
    String serverUrl = '${Config().apiDomain}/info/$id';

    try {
      var response = await http.patch(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        debugPrint('location stored successfully.');
      } else {
        debugPrint('Failed to store location. Status code: ${response.statusCode}');
        debugPrint('Failed to store location. Status code: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error storing location: $e');
    }
  }
}


class EnterPincodeOrCityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter PINCODE or City Name'),
      ),
      // Implement your UI to allow entering PINCODE or CITY NAME here
      body: Center(
        child: Text('Enter PINCODE or CITY NAME screen'),
      ),
    );
  }
}




