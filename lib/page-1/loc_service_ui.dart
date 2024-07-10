import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'location_provider.dart';
import 'bottom_nav.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() {
//   runApp(ServiceCheckerApp());
// }

class ServiceCheckerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationProvider(),
      child: MaterialApp(
        title: 'Service Checker App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ServiceCheckerPage(),
      ),
    );
  }
}

class ServiceCheckerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Checker'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await context.read<LocationProvider>().checkLocationAndService();
              bool serviceAvailable = context.read<LocationProvider>().serviceAvailable;
              print(serviceAvailable);
              sendLocationToBackend();
              if (serviceAvailable) {
                // Call your function here
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNav()),
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
          },
          child: Text('Check Location and Service'),
        ),
      ),
    );
  }
  final storage = FlutterSecureStorage();


  // Define your function here
  Future<void> sendLocationToBackend() async {



    Future<String?> _getId() async {
      return await storage.read(key: 'id'); // Assuming you stored the token with key 'token'
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
    print(requestBody);
    String serverUrl = 'http://192.0.0.2:8000/api/info/$id';

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



