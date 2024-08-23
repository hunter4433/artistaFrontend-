import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/bottom_nav.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/page0.dart';

class Signup_user extends StatefulWidget {
  @override
  _Signup_userState createState() => _Signup_userState();
}

class _Signup_userState extends State<Signup_user> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();

  Color _nameBorderColor = Colors.grey;
  Color _lastNameBorderColor = Colors.grey;
  Color _phoneBorderColor = Colors.grey;
  Color _addressBorderColor = Colors.grey;
  Color _cityBorderColor = Colors.grey;
  Color _stateBorderColor = Colors.grey;
  Color _pinCodeBorderColor = Colors.grey;

  final storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token'); // Assuming you stored the token with key 'token'
  }

  Future<void> _sendDataToBackend() async {
    String? token = await _getToken();
    print (token);

    // Check if token is not null
    if (token != null) {
      // Prepare data to send to the backend
      Map<String, String> userData = {
        'first_name': _nameController.text,
        'last_name': _lastNameController.text,
        'phone_no': _phoneController.text,
        'house_no_building': _addressController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'pin': _pinCodeController.text,
      };

      // Convert data to JSON format
      String jsonData = json.encode(userData);

      // Example URL, replace with your actual API endpoint
      String apiUrl = 'http://127.0.0.1:8000/api/info';

      try {
        // Make POST request to the API
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            'Authorization': 'Bearer $token', // Include the token in the header
          },
          body: jsonData,
        );

        // Check if request was successful (status code 200)
        if (response.statusCode == 201) {
          // Data sent successfully, handle response if needed
          print('Data sent successfully');
          // Example response handling
          print('Response: ${response.body}');

          Map<String, dynamic> responseData = jsonDecode(response.body);
          String id = responseData['data']['id'];
          await storage.write(key: 'id', value: id);
          print(id);
        } else {
          // Request failed, handle error
          print('Failed to send data. Status code: ${response.statusCode}');
          // Example error handling
          print('Error response: ${response.body}');
        }
      } catch (e) {
        // Handle network errors
        print('Error sending data: $e');
      }
    } else {
      // Handle the case where token is null, perhaps by showing an error message
      print("Token is null");
    }
  }

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
          style: GoogleFonts.beVietnamPro(
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
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: 730 * fem,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 5 * fem),
                    padding: EdgeInsets.fromLTRB(16 * fem, 8 * fem, 16 * fem, 8 * fem),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                                child: Text(
                                  'Name',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 56 * fem,
                                child: TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.account_circle_outlined, color: Color(0xffeac6d3)),
                                    hintText: 'Enter Your Name',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _nameBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _nameBorderColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                width: double.infinity,
                                height: 56 * fem,
                                child: TextField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.account_circle_outlined, color: Color(0xffeac6d3)),
                                    hintText: 'Enter Your Last Name',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _lastNameBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _lastNameBorderColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                                child: Text(
                                  'Phone No',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 56 * fem,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.phone_enabled_outlined, color: Color(0xffeac6d3)),
                                    hintText: 'Your Phone No.',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _phoneBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _phoneBorderColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                                child: Text(
                                  'Address',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 56 * fem,
                                child: TextField(
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.house_outlined, color: Color(0xffeac6d3)),
                                    hintText: 'House No and Building',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _addressBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _addressBorderColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 12 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                width: double.infinity,
                                height: 56 * fem,
                                child: TextField(
                                  controller: _cityController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.location_city_outlined, color: Color(0xffeac6d3)),
                                    hintText: 'Your City',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _cityBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _cityBorderColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                width: double.infinity,
                                height: 56 * fem,
                                child: TextField(
                                  controller: _stateController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.area_chart_outlined, color: Color(0xffeac6d3)),
                                    hintText: 'Your State',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _stateBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _stateBorderColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                                child: Text(
                                  'Pin Code',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 56 * fem,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _pinCodeController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.location_on_outlined, color: Color(0xffeac6d3)),
                                    hintText: 'Pin Code',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _pinCodeBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(width: 1.25, color: _pinCodeBorderColor),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Reset border colors
                          _nameBorderColor = Colors.grey;
                          _lastNameBorderColor = Colors.grey;
                          _phoneBorderColor = Colors.grey;
                          _addressBorderColor = Colors.grey;
                          _cityBorderColor = Colors.grey;
                          _stateBorderColor = Colors.grey;
                          _pinCodeBorderColor = Colors.grey;

                          // Check if any field is empty
                          if (_nameController.text.isEmpty) _nameBorderColor = Colors.red;
                          if (_lastNameController.text.isEmpty) _lastNameBorderColor = Colors.red;
                          if (_phoneController.text.isEmpty) _phoneBorderColor = Colors.red;
                          if (_addressController.text.isEmpty) _addressBorderColor = Colors.red;
                          if (_cityController.text.isEmpty) _cityBorderColor = Colors.red;
                          if (_stateController.text.isEmpty) _stateBorderColor = Colors.red;
                          if (_pinCodeController.text.isEmpty) _pinCodeBorderColor = Colors.red;

                          // Navigate only if all fields are filled
                          if (_nameController.text.isNotEmpty &&
                              _lastNameController.text.isNotEmpty &&
                              _phoneController.text.isNotEmpty &&
                              _addressController.text.isNotEmpty &&
                              _cityController.text.isNotEmpty &&
                              _stateController.text.isNotEmpty &&
                              _pinCodeController.text.isNotEmpty) {
                            // Call function to send data to backend
                            _sendDataToBackend();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => BottomNav(data: {},)),
                                  (route) => false,
                            );
                          }
                          else{
                            print('all field are required to be filled');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('all field are required to be filled'),
                                duration: Duration(seconds: 1), // Adjust the duration as needed
                              ),
                            );
                          }
                        });
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
                          'Finish',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.5 * ffem / fem,
                            letterSpacing: 0.2399999946 * fem,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
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
}
