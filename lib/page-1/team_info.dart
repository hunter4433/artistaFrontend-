import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/page-1/team1.dart';
import 'package:test1/page-1/team2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../utils.dart';
import 'location_service.dart';

import 'location_service.dart';

class team_info extends StatefulWidget {
  @override
  _artist_credState createState() => _artist_credState();
}

class _artist_credState extends State<team_info> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _alternatephoneController = TextEditingController();

  double? _latitude;
  double? _longitude;
  late Position _currentPosition;
  bool isLoading = false;
  String? _address;

  Color _nameBorderColor = Color(0xffeac6d3);
  Color _phoneBorderColor = Color(0xffeac6d3);
  Color _addressBorderColor = Color(0xffeac6d3);


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




  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        title: Text(
          'Sign Up',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 21 * ffem,
            fontWeight: FontWeight.w500,
            height: 1.25 * ffem / fem,
            letterSpacing: -0.8000000119 * fem,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF121217),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0 * fem, 10 * fem, 0 * fem, 10 * fem),
                  constraints: BoxConstraints(
                    maxWidth: 333 * fem,
                  ),
                  child: Text(
                    'Be your own boss, choose your working hours and prices.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.25 * ffem / fem,
                      letterSpacing: -0.8000000119 * fem,
                      color: Colors.white,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(16 * fem, 25 * fem, 16 * fem, 20 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _getImage();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12 * fem), // Ensures the image gets clipped to the border radius
                          child: Container(
                            width: 190 * fem,
                            height: 220 * fem,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF9E9EB8)),
                              borderRadius: BorderRadius.circular(12 * fem),
                            ),
                            child: _imageFile != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(12 * fem), // Ensures the image follows the same border radius
                              child: Image.file(
                                _imageFile!,
                                width: 190 * fem,
                                height: 200 * fem,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Icon(
                              Icons.add_photo_alternate,
                              size: 50 * fem,
                              color: Color(0xFF9E9EB8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40 * fem),
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
                            suffixIcon: Icon(Icons.account_circle_outlined, color: Color(0xFF9E9EB8)),
                            hintText: 'Team Name',
                            hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * fem),
                              borderSide: BorderSide(width: 1.25, color:Color(0xFF9E9EB8)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * fem),
                              borderSide: BorderSide(width: 1.25, color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),

                      SizedBox(height: 18 * fem),
                      Container(
                        width: double.infinity,
                        height: 56 * fem,
                        child: TextField(
                          controller: _alternatephoneController,
                          onChanged: (value) {
                            setState(() {
                              _phoneBorderColor = value.isEmpty ? Colors.red : Color(0xffeac6d3);
                            });
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.phone_enabled_outlined, color: Color(0xFF9E9EB8)),
                            hintText: 'Alternate Phone No.',
                            hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * fem),
                              borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * fem),
                              borderSide: BorderSide(width: 1.25, color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                      SizedBox(height: 18 * fem),
                      Container(
                        width: double.infinity,
                        height: 80 * fem,
                        child: GestureDetector(
                          onTap: () {
                            _showLocationDialog(context);
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: _addressController,
                              onChanged: (value) {
                                setState(() {
                                  _addressBorderColor = value.isEmpty ? Colors.red : Color(0xffeac6d3);
                                });
                              },
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.home_outlined, color: Color(0xFF9E9EB8)),
                                hintText: 'Address',
                                hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                  borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                  borderSide: BorderSide(width: 1.25, color: Colors.white),
                                ),
                              ),
                              style: TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 19 * fem),
                      ElevatedButton(
                        onPressed: () async {
                          if (_nameController.text.isEmpty ||
                              _addressController.text.isEmpty ||
                              _alternatephoneController.text.isEmpty) {
                            // Show a snackbar indicating that all fields are required
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('All fields are required.'),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => team2signup(
                                profilePhoto: _imageFile,) ),
                            );
                            // Store _ageController.text using SharedPreferences
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('alt_phone_number', _alternatephoneController.text);
                            prefs.setString('name',_nameController.text);
                            prefs.setString('phone_number',_phoneController.text);
                            prefs.setString('address',_addressController.text);
                            prefs.setString('profile_photo', _imageFile!.path);

                            // String artist_name = _nameController.text;
                            // print('name of artist= $artist_name ');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffe5195e),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10 * fem),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 18 * fem,
                            vertical: 12 * fem,
                          ),
                          minimumSize: Size(double.infinity, 14 * fem),
                        ),
                        child: Center(
                          child: Text(
                            'Tell Us About Your Skills',
                            style: TextStyle(
                              fontSize: 18 * ffem,
                              fontWeight: FontWeight.w500,
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
        return AlertDialog(backgroundColor:Color(0xfffff5f8) ,
          title: Text('Address'),
          content: isLoading
              ? Center(child: CircularProgressIndicator())
              : Text('How would you like to enter your Address?',style: TextStyle(fontSize: 17,color: Colors.black),),
          actions: isLoading
              ? []
              : [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showManualEntryDialog(context);
              },
              child: Text('Enter Manually',style: TextStyle(fontSize: 16, color: Colors.black),),
            ),
            ElevatedButton(
              onPressed: () async {
                _useCurrentLocation();
                // Close the dialog after fetching the location
                Navigator.of(context).pop();
              },
              child: Text('Use Current Location',style: TextStyle(fontSize: 16, color: Colors.black),),
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
          backgroundColor: Color(0xfffff5f8),
          title: Text(
            'Enter Address',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // House No / Apartment TextField
                TextField(
                  controller: flatController,
                  decoration: InputDecoration(
                    hintText: 'House No/Apartment, Building',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink), // Focused line color
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Unfocused line color
                    ),
                  ),
                ),
                // Landmark / Street TextField
                TextField(
                  controller: areaController,
                  decoration: InputDecoration(
                    hintText: 'Landmark, Street, Sector',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                // City TextField
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: 'City',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                // State TextField
                TextField(
                  controller: stateController,
                  decoration: InputDecoration(
                    hintText: 'State',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                // Pincode TextField
                TextField(
                  controller: pincodeController,
                  decoration: InputDecoration(
                    hintText: 'Pincode',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addressController.text =
                "${flatController.text}, ${areaController.text}, ${cityController.text}, ${stateController.text}, ${pincodeController.text}";
                convertAddressToLatLng(pincodeController.text);
                Navigator.of(context).pop();
              },
              child: Text(
                'Enter',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
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
