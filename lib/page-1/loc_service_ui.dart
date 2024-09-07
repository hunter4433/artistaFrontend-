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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInitialDialog();
    });
  }

  Future<void> useCurrentLocation() async {
    try {
      _currentPosition = await _locationService.getCurrentLocation();
      _serviceAvailable =
      await _locationService.isServiceAvailable(_currentPosition);
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
      Position position = await locationService.getLocationFromAddress(
          textEditingController);
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

  void _showInitialDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Let’s Find Out If We’re Near You!',
            style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),
          ),
          content: Container(
            constraints: BoxConstraints(
              maxWidth: 300, // Adjust width here
              maxHeight: 200, // Adjust height here
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    _showPincodeOrCityDialog(); // Show the PINCODE or CITY NAME dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Change color here
                    padding: EdgeInsets.symmetric(vertical: 14), // Adjust height here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Adjust corner radius here
                    ),
                  ),
                  child: Text(
                    'Enter PINCODE or CITY NAME',
                    style: TextStyle(fontSize: 16,color: Colors.black),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    useCurrentLocation(); // Call function to use current location
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Change color here
                    padding: EdgeInsets.symmetric(vertical: 14), // Adjust height here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Adjust corner radius here
                    ),
                  ),
                  child: Text(
                    'Use Current Location',
                    style: TextStyle(fontSize: 16,color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor:Color(0xfffff5f8), // Slightly darker than Color(0xfffff5f8) , // Change dialog background color here
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), // Adjust corner radius of dialog here
          ),
        );
      },
    );
  }

  void _showPincodeOrCityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Please Enter Your PINCODE or City Name',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                ),
              ),
              content: Container(
                width: 300, // Adjust width here
                height: 150, // Adjust height here
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Enter PINCODE or City Name',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Color when not focused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue), // Color when focused
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    setState(() {
                      textEditingController.text = value;
                    });
                  },
                ),
              ),
              backgroundColor: Colors.white, // Change dialog background color here
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners for dialog box
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      textEditingController.text = ''; // Clear text field
                    });
                    Navigator.pop(context); // Close dialog without value
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Button background color
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Adjust padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners for button
                    ),
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle validation or further actions here
                    convertAddressToLatLng(textEditingController.text);
                    setState(() {
                      textEditingController.text = ''; // Clear text field
                    });
                    Navigator.pop(context, textEditingController.text); // Close dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button background color
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Adjust padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners for button
                    ),
                  ),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  final storage = FlutterSecureStorage();


  // Define your function here
  Future<void> sendLocationToBackend() async {
    Future<String?> _getId() async {
      return await storage.read(
          key: 'user_id'); // Assuming you stored the token with key 'token'
    }
    Future<String?> _getLatitude() async {
      return await storage.read(
          key: 'latitude'); // Assuming you stored the token with key 'token'
    }
    Future<String?> _getLongitude() async {
      return await storage.read(
          key: 'longitude'); // Assuming you stored the token with key 'token'
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
        debugPrint(
            'Failed to store location. Status code: ${response.statusCode}');
        debugPrint('Failed to store location. Status code: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error storing location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Color(0xFF121217),
      appBar: AppBar(backgroundColor:Color(0xFF121217),
        title: Text('Service Checker', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // You can adjust the padding value
          child: Text(
            'Unfortunately, our service isn’t available in your area yet. We’re expanding soon!',
            textAlign: TextAlign.center, // Center-align the text if desired
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white), // Adjust font size as needed
          ),
        ),
      ),
    );
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




