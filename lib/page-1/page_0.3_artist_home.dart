import 'package:flutter/material.dart';
import 'package:test1/page-1/booking_history.dart';
import 'package:test1/page-1/payment_history.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class artist_home extends StatefulWidget {
  @override
  State<artist_home> createState() => _artist_home();
}

final storage = FlutterSecureStorage();

Future<String?> _getToken() async {
  return await storage.read(key: 'token'); // Assuming you stored the token with key 'token'
}

Future<String?> _getid() async {
  return await storage.read(key: 'id'); // Assuming you stored the token with key 'id'
}

Future<String?> _getKind() async {
  return await storage.read(key: 'selected_value'); // Assuming you stored the token with key 'selected_value'
}

class _artist_home extends State<artist_home> {
  bool isAvailable = true;

  Future<String> getNameFromBackend() async {
    String? token = await _getToken();
    String? id = await _getid();
    String? kind = await _getKind();
    // Assuming the API endpoint returns the name
    String apiUrl;
    if (kind == 'solo_artist') {
      apiUrl = 'http://127.0.0.1:8000/api/artist/info/$id';
    } else if (kind == 'team') {
      apiUrl = 'http://127.0.0.1:8000/api/artist/team_info/$id';
    } else {
      // Handle the case where kind is not recognized
      return 'hi';
    }

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = json.decode(response.body);
        // Assuming the name is in the 'name' field of the response
        if (kind == 'solo_artist') {
          return responseData['data']['attributes']['name'];
        } else if (kind == 'team') {
          return responseData['data']['attributes']['team_name'];
        }
      } else {
        print('Failed to fetch name. Status code: ${response.statusCode}');
        return 'hi';
      }
    } catch (e) {
      print('Error fetching name: $e');
      return "hi";
    }
    return 'hi';
  }

  Future<String> getImageUrlFromBackend() async {
    String baseUrl = 'http://127.0.0.1:8000/storage/';
    String? token = await _getToken();
    String? id = await _getid();
    String? kind = await _getKind();

    String apiUrl;
    if (kind == 'solo_artist') {
      apiUrl = 'http://127.0.0.1:8000/api/artist/info/$id';
    } else if (kind == 'team') {
      apiUrl = 'http://127.0.0.1:8000/api/artist/team_info/$id';
    } else {
      return 'hi';
    }

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);
        String profile_photo = '$baseUrl/${userData['data']['attributes']['profile_photo']}';
        return profile_photo;
      } else {
        print('Failed to fetch image URL. Status code: ${response.statusCode}');
        return 'bi';
      }
    } catch (e) {
      print('Error fetching image URL: $e');
      return 'bi';
    }
  }

  @override
  void initState() {
    super.initState();
    getImageUrlFromBackend();
    getNameFromBackend();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'HOMESTAGE',
          textAlign: TextAlign.center,
          style: SafeGoogleFont(
            'Be Vietnam Pro',
            fontSize: 22 * ffem,
            fontWeight: FontWeight.w700,
            height: 1.25 * ffem / fem,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF121217),
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xFF121217),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 18),
              Container(
                margin: EdgeInsets.fromLTRB(1 * fem, 0, 1 * fem, 28.5 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 140 * fem,
                      height: 140 * fem,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.grey.shade300, Colors.grey.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: FutureBuilder<String>(
                            future: getImageUrlFromBackend(),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.data != null) {
                                String imageUrl = snapshot.data!;
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(64 * fem),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return Center(child: Text('No image URL available'));
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18 * fem),
                    Container(
                      margin: EdgeInsets.fromLTRB(1 * fem, 0, 0, 28.5 * fem),
                      width: double.infinity,
                      child: Column(
                        children: [
                          FutureBuilder<String>(
                            future: getNameFromBackend(),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                String name = snapshot.data ?? 'Artist';
                                return Text(
                                  'Hi, $name',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Be Vietnam Pro',
                                    fontSize: 22 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.25 * ffem / fem,
                                    letterSpacing: -0.33 * fem,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16 * fem),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 16 * fem),
                        color: Color(0xFF292938),
                        child: Container(
                          width: double.infinity,
                          height: 90 * fem, // Adjust the height
                          padding: EdgeInsets.all(16 * fem),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Availability',
                                    style: SafeGoogleFont(
                                      'Be Vietnam Pro',
                                      fontSize: 18.5 * ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5 * ffem / fem,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Visibility(
                                    visible: isAvailable,
                                    child: Text(
                                      'I\'m available for bookings !',
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5714285714 * ffem / fem,
                                        color: Color(0xffd0fd3e),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !isAvailable,
                                    child: Text(
                                      'I\'m unavailable!',
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5714285714 * ffem / fem,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: isAvailable,
                                onChanged: (value) {
                                  setState(() {
                                    isAvailable = value;
                                  });
                                },
                                activeTrackColor: Color(0xffd0fd3e),
                                inactiveTrackColor: Colors.redAccent,
                                activeColor: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 16 * fem),
                        color: Color(0xFF292938),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => booking_history()));
                            // Navigate to Booking History
                          },
                          child: Container(
                            width: double.infinity,
                            height: 75 * fem, // Adjust the height
                            padding: EdgeInsets.all(16 * fem),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Booking History',
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5 * ffem / fem,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'View',
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xFF9E9EB8),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, size: 24 * fem, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 16 * fem),
                        color: Color(0xFF292938),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => payment_history()));
                            // Navigate to Payment History
                          },
                          child: Container(
                            width: double.infinity,
                            height: 75 * fem, // Adjust the height
                            padding: EdgeInsets.all(16 * fem),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Payment History',
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5 * ffem / fem,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'View',
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xFF9E9EB8),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, size: 24 * fem, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
