import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/page-1/skills_artist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../utils.dart';
import 'location_service.dart';


class artist_cred extends StatefulWidget {
  @override
  _artist_credState createState() => _artist_credState();
}

class _artist_credState extends State<artist_cred> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  LatLng? _selectedCoordinates;
   double? _latitude;
   double? _longitude;
  late Position _currentPosition;
  bool isLoading = false;
  String? _address;


  Color _nameBorderColor = Color(0xffeac6d3);
  Color _ageBorderColor = Color(0xffeac6d3);
  Color _phoneBorderColor = Color(0xffeac6d3);
  Color _addressBorderColor = Color(0xffeac6d3);

  File? _imageFile;

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

  }



  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        title: Text(
          'Sign up',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 19 * ffem,
            fontWeight: FontWeight.w700,
            height: 1.25 * ffem / fem,
            letterSpacing: -0.8000000119 * fem,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF121217),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Color(0xFF9E9EB8),),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            // height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF121217),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 10 * fem),
                  constraints: BoxConstraints(
                    maxWidth: 333 * fem,
                  ),
                  child: Text(
                    'Be your own boss, choose your working hours and prices.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.25 * ffem / fem,
                      letterSpacing: -0.8000000119 * fem,
                      color: Colors.white,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(16 * fem, 1 * fem, 16 * fem, 10 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _getImage();
                        },
                        child: Container(
                          width: 190 * fem,
                          height: 220 * fem,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF9E9EB8),),
                            borderRadius: BorderRadius.circular(12 * fem),
                          ),
                          child: _imageFile != null
                              ? Image.file(
                            _imageFile!,
                            width: 190 * fem,
                            height: 220 * fem,
                            fit: BoxFit.cover,
                          )
                              : Icon(
                            Icons.add_photo_alternate,
                            size: 50 * fem,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 16 * fem),
                      Container(
                        width: double.infinity,
                        height: 56 * fem,
                        child: TextField(
                          controller: _nameController,
                          onChanged: (value) {
                            setState(() {
                              _nameBorderColor = value.isEmpty ? Colors.red : Color(0xffeac6d3);
                            });
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.account_circle_outlined, color: Color(0xFF9E9EB8),),
                            hintText: 'What\'s Your Name',
                            hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * fem),
                              borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8),),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * fem),
                              borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                            ),
                          ),

                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16 * fem),
                      Container(
                        width: double.infinity,
                        height: 56 * fem,
                        child: TextField(
                          controller: _ageController,

                          onChanged: (value) {
                            setState(() {
                              _ageBorderColor = value.isEmpty ? Colors.red : Color(0xffeac6d3);
                            });
                          },

                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.cake_outlined, color: Color(0xFF9E9EB8),),
                            hintText: 'Your Age',
                            hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * fem),
                              borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8),),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * fem),
                              borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16 * fem),
                      GestureDetector(
                        onTap: () {
                          _showLocationDialog(context);
                        },
                        child: AbsorbPointer(
                          absorbing: true, // Prevents the TextField from receiving touch events
                          child: Container(
                            width: double.infinity,
                            height: 56 * fem,
                            child: TextField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.home_outlined,
                                  color: Color(0xFF9E9EB8),
                                ),
                                hintText: 'Address',
                                hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                  borderSide: BorderSide(
                                    width: 1.25,
                                    color: Color(0xFF9E9EB8),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                  borderSide: BorderSide(
                                    width: 1.25,
                                    color: Color(0xffe5195e),
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16 * fem),
                      ElevatedButton(
                        onPressed: () async {
                          if (_nameController.text.isEmpty ||
                              _ageController.text.isEmpty ||
                              _addressController.text.isEmpty) {
                            // Show a snackbar indicating that all fields are required
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('All fields are required.'),
                              ),
                            );
                          } else {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('age', _ageController.text);
                            prefs.setString('name',_nameController.text);
                            prefs.setString('address',_addressController.text);
                            prefs.setDouble('latitude',_latitude!);
                            prefs.setDouble('longitude',_longitude!);
                            prefs.setString('profile_photo', _imageFile!.path);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArtistCredentials2(

                                  profilePhoto: _imageFile,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffe5195e),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12 * fem),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * fem,
                            vertical: 12 * fem,
                          ),
                          // minimumSize: size(double.infinity, 14 * fem),
                        ),
                        child: Center(
                          child: Text(
                            'Tell Us About Your Skills',
                            style: TextStyle(
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.5 * ffem / fem,
                              letterSpacing: 0.24 * fem,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //location dialog box
  void _showLocationDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Address'),
          content: isLoading
              ? Center(child: CircularProgressIndicator())
              : Text('How would you like to enter your Address?'),
          actions: isLoading
              ? []
              : [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showManualEntryDialog(context);
              },
              child: Text('Enter Manually'),
            ),
            TextButton(
              onPressed: () async {
                _useCurrentLocation();
                // Close the dialog after fetching the location
                Navigator.of(context).pop();
              },
              child: Text('Use Current Location'),
            ),
          ],
        );
      },
    );
  }

  //manual entry dialog box
  void _showManualEntryDialog(BuildContext context) {
    TextEditingController flatController = TextEditingController();
    TextEditingController areaController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController stateController = TextEditingController();
    TextEditingController pincodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Address Manually'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: flatController,
                  decoration: InputDecoration(hintText: 'Flat, House No, Building, Apartment'),
                ),
                TextField(
                  controller: areaController,
                  decoration: InputDecoration(hintText: 'Area, Street, Sector'),
                ),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(hintText: 'City'),
                ),
                TextField(
                  controller: stateController,
                  decoration: InputDecoration(hintText: 'State'),
                ),
                TextField(
                  controller: pincodeController,
                  decoration: InputDecoration(hintText: 'Pincode'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addressController.text =
                "${flatController.text}, ${areaController.text}, ${cityController.text}, ${stateController.text}, ${pincodeController.text}";
                convertAddressToLatLng(pincodeController.text);
                Navigator.of(context).pop();
                },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // usecurrent location function
  Future<void> _useCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    LocationService _locationService = LocationService();
    _currentPosition = await _locationService.getCurrentLocation();
    print(_currentPosition);
    _latitude=_currentPosition!.latitude;
    _longitude=_currentPosition!.longitude;


    if (_currentPosition != null) {
      print('Latitude is : ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}');
      _address = await MyCustomScrollBehavior.getAddressFromLatLng(_currentPosition!);
      print(_address);

      if (_address != null) {
        _addressController.text = _address!;
      }
    }

    setState(() {
      isLoading = false;
    });


  }

  //pincode to latLng
  Future<void> convertAddressToLatLng(String textEditingController) async {
    try {
      LocationService locationService = LocationService();
      Position position = await locationService.getLocationFromAddress(textEditingController);
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      _latitude=position.latitude;
      _longitude=position.longitude;

    } catch (e) {
      print('Error converting address to coordinates: $e');
      // Handle error accordingly
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}



