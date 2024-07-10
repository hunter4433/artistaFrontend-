import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc; // Use alias for location package
import 'package:geocoding/geocoding.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final loc.Location locationController = loc.Location(); // Use alias
  static const GooglePlex = LatLng(37.4223, -122.0848);

  LatLng? currentPosition;
  String? currentAddress;
  StreamSubscription<loc.LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Google Map Page'),
    ),
    body: currentPosition == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
      children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: GooglePlex,
              zoom: 13,
            ),
            onTap: _onMapTapped,
            markers: {
              if (currentPosition != null)
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: currentPosition!,
                  onTap: () {
                    _showMarkerSelectionDialog(context, currentPosition!);
                  },
                ),
            },
          ),
        ),
        if (currentAddress != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Current Address: $currentAddress',
              style: const TextStyle(fontSize: 16),
            ),
          ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Icon(Icons.exit_to_app),
    ),
  );

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    locationSubscription = locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        final newPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        _updatePosition(newPosition);
        _getAddressFromLatLng(newPosition);
      }
    });
  }

  void _updatePosition(LatLng newPosition) {
    if (mounted) {
      setState(() {
        currentPosition = newPosition;
      });
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (mounted) {
          setState(() {
            currentAddress =
            '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}';
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _showMarkerSelectionDialog(BuildContext context, LatLng position) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Location'),
        content: Text('Do you want to select this location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context, {
                'coordinates': position,
                'address': currentAddress ?? 'Address not found'
              }); // Return the position and address
            },
            child: Text('Select'),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng tappedPosition) {
    _updatePosition(tappedPosition);
    _getAddressFromLatLng(tappedPosition);
  }
}
