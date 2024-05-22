import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/page-1/skills_artist.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class artist_cred extends StatefulWidget {
  @override
  _artist_credState createState() => _artist_credState();
}

class _artist_credState extends State<artist_cred> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();



  Color _nameBorderColor = Color(0xffeac6d3);
  Color _ageBorderColor = Color(0xffeac6d3);
  Color _phoneBorderColor = Color(0xffeac6d3);
  Color _addressBorderColor = Color(0xffeac6d3);

  File? _imageFile;



  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign up',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 19 * ffem,
            fontWeight: FontWeight.w700,
            height: 1.25 * ffem / fem,
            letterSpacing: -0.8000000119 * fem,
            color: Color(0xff1e0a11),
          ),
        ),
        backgroundColor: Color(0xffffffff),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Container(
            width: double.infinity,
            height: 984 * fem,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
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
                        color: Color(0xff1c0c11),
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
                              border: Border.all(color: Color(0xffeac6d3)),
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
                              suffixIcon: Icon(Icons.account_circle_outlined, color: Color(0xffeac6d3)),
                              hintText: 'What\'s Your Name',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12 * fem),
                                borderSide: BorderSide(width: 1.25, color: _nameBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12 * fem),
                                borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                              ),
                            ),
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
                              suffixIcon: Icon(Icons.cake_outlined, color: Color(0xffeac6d3)),
                              hintText: 'Your Age',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12 * fem),
                                borderSide: BorderSide(width: 1.25, color: _ageBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12 * fem),
                                borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16 * fem),
                        Container(
                          width: double.infinity,
                          height: 56 * fem,
                          child: TextField(
                            controller: _phoneController,
                            onChanged: (value) {
                              setState(() {
                                _phoneBorderColor = value.isEmpty ? Colors.red : Color(0xffeac6d3);
                              });
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.phone_enabled_outlined, color: Color(0xffeac6d3)),
                              hintText: 'Your Phone No.',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12 * fem),
                                borderSide: BorderSide(width: 1.25, color: _phoneBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12 * fem),
                                borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16 * fem),
                        Container(
                          width: double.infinity,
                          height: 100 * fem,
                          child: TextField(
                            controller: _addressController,
                            onChanged: (value) {
                              setState(() {
                                _addressBorderColor = value.isEmpty ? Colors.red : Color(0xffeac6d3);
                              });
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.home_outlined, color: Color(0xffeac6d3)),
                              hintText: 'Address',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12 * fem),
                                borderSide: BorderSide(width: 1.25, color: _addressBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12 * fem),
                                borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16 * fem),
                        ElevatedButton(
                          onPressed: () async {
                            if (_nameController.text.isEmpty ||
                                _ageController.text.isEmpty ||
                                _phoneController.text.isEmpty ||
                                _addressController.text.isEmpty) {
                              // Show a snackbar indicating that all fields are required
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('All fields are required.'),
                                ),
                              );
                            } else {
                              // Store _ageController.text using SharedPreferences
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('age', _ageController.text);
                              prefs.setString('name',_nameController.text);
                              prefs.setString('phone_number',_phoneController.text);
                              prefs.setString('address',_addressController.text);
                              // prefs.setString('address',_imageFile);
                              prefs.setString('profile_photo', _imageFile!.path);


                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArtistCredentials2(
                                    // name: _nameController.text,
                                    // age: _ageController.text,
                                    // phoneNumber: _phoneController.text,
                                    // address: _addressController.text,
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
                            minimumSize: Size(double.infinity, 14 * fem),
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
      ),
    );
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

