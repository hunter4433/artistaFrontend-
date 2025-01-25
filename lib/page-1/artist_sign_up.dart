import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  // LatLng? _selectedCoordinates;
   double? _latitude;
   double? _longitude;
  late Position _currentPosition;
  bool isLoading = false;
  String? _address;
  final List<String> _cities = ['Chandigarh (Tricity)', 'Delhi', 'Mumbai', 'Bangalore','Gurugram'];
  final List<String> _selectedCities = [];




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
    return Scaffold(backgroundColor:  Color(0xFF0D0D0F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Center(
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 22 * fem,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFF0D0D0F),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            // height: double.infinity,
            decoration: BoxDecoration(
              color:  Color(0xFF0D0D0F),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  padding: EdgeInsets.fromLTRB(16 * fem, 20 * fem, 16 * fem, 10 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10 * fem), // Apply rounded corners here
                        child: GestureDetector(
                          onTap: () {
                            _getImage();
                          },
                          child: Container(
                            width: 185 * fem,
                            height: 205 * fem,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF9E9EB8),
                              ),
                              borderRadius: BorderRadius.circular(10 * fem), // Apply rounded corners to the container
                            ),
                            child: _imageFile != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(10 * fem), // Ensure the image inside also has rounded corners
                              child: Image.file(
                                _imageFile!,
                                width: 185 * fem,
                                height: 205 * fem,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Icon(
                              Icons.add_photo_alternate,
                              size: 50 * fem,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 28 * fem),
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
                              borderRadius: BorderRadius.circular(10 * fem),
                              borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8),),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * fem),
                              borderSide: BorderSide(width: 1.25, color: Colors.white),
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
                            suffixIcon: Icon(Icons.phone, color: Color(0xFF9E9EB8),),
                            hintText: 'Alternate PhoneNumber',
                            hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * fem),
                              borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8),),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * fem),
                              borderSide: BorderSide(width: 1.25, color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16 * fem),

                      // GestureDetector(
                      //   onTap: () {
                      //     _showLocationDialog(context);
                      //   },
                      //   child: AbsorbPointer(
                      //     absorbing: true, // Prevents the TextField from receiving touch events
                      //     child: Container(
                      //       width: double.infinity,
                      //       child: TextField(
                      //         controller: _addressController,
                      //         minLines: 1, // Minimum number of lines (1 by default)
                      //         maxLines: null, // Allow it to expand as needed
                      //         decoration: InputDecoration(
                      //           suffixIcon: Icon(
                      //             Icons.home_outlined,
                      //             color: Color(0xFF9E9EB8),
                      //           ),
                      //           hintText: 'Enter Your Address',
                      //           hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                      //           enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10 * fem),
                      //             borderSide: BorderSide(
                      //               width: 1.25,
                      //               color: Color(0xFF9E9EB8),
                      //             ),
                      //           ),
                      //           focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10 * fem),
                      //             borderSide: BorderSide(
                      //               width: 1.25,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         ),
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 16 * fem),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose the cities for most of your bookings. Accommodation won’t be provided here.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16, // Adjust as needed
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8 * fem), // Space between text and dropdown
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setModalState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              'Select Cities',
                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView(
                                              children: _cities.map((city) {
                                                return CheckboxListTile(
                                                  title: Text(
                                                    city,
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  value: _selectedCities.contains(city),
                                                  activeColor: Colors.white,
                                                  checkColor: Colors.black,
                                                  onChanged: (bool? value) {
                                                    setModalState(() {
                                                      if (value == true) {

                                                        _selectedCities.add(city);

                                                        // Check if Chandigarh is selected and convert to lat/long
                                                        if (city == 'Chandigarh (Tricity)') {
                                                          convertAddressToLatLng('Chandigarh');
                                                        }
                                                      } else {
                                                        _selectedCities.remove(city);
                                                      }
                                                    });
                                                    setState(() {}); // Update UI after selection
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 0), // Adjusted the space here
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:  Color(0xffe5195e), // Changed to green for example
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                minimumSize: Size(200, 50), // Shortened width
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('OK', style: TextStyle(color: Colors.white,fontSize: 17*fem)),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 56 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10 * fem),
                                border: Border.all(width: 1.25, color: Color(0xFF9E9EB8)),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12 * fem), // Adjust padding
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _selectedCities.isEmpty ? 'Select Cities' : _selectedCities.join(', '),
                                      style: TextStyle(
                                        color: _selectedCities.isEmpty ? Color(0xFF9E9EB8) : Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E9EB8)), // Arrow on the right side
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),


                      SizedBox(height: 30 * fem),

                      ElevatedButton(
                        onPressed: () async {
                          if (_nameController.text.isEmpty ||
                              _ageController.text.isEmpty ||
                              _selectedCities.isEmpty) {
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
                            prefs.setString('address',_selectedCities.join(','));
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
                            borderRadius: BorderRadius.circular(10 * fem),
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



