import 'package:flutter/material.dart';
import 'package:test1/page-1/booking_history.dart';
import 'package:test1/page-1/payment_history.dart';
import '../config.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class artist_home extends StatefulWidget {
  @override
  State<artist_home> createState() => _artist_home();
}

final storage = FlutterSecureStorage();



Future<String?> _getid() async {
  return await storage.read(key: 'id'); // Assuming you stored the token with key 'id'
}

Future<String?> _getKind() async {
  return await storage.read(key: 'selected_value'); // Assuming you stored the token with key 'selected_value'
}
class _artist_home extends State<artist_home> {
  bool? isAvailable;
  int? status;
  String? name;
  String? imageUrl;
  String? artist_id;
  bool loading = true; // Add a loading state

  Future<void> fetchDataFromBackend() async {
    String? id = await _getid();
    String? kind = await _getKind();

    String apiUrl;
    if (kind == 'solo_artist') {
      apiUrl = '${Config().apiDomain}/artist/info/$id';
    } else if (kind == 'team') {
      apiUrl = '${Config().apiDomain}/artist/team_info/$id';
    } else {
      return;
    }

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);


        setState(() {
          name = kind == 'solo_artist'
              ? responseData['data']['attributes']['name']
              : responseData['data']['attributes']['team_name'];
          artist_id = responseData['data']['id'];

          status = responseData['data']['attributes']['booked_status'];
          isAvailable = status == 0;

          String baseUrl = '${Config().baseDomain}/storage/';
          imageUrl =
          '$baseUrl/${responseData['data']['attributes']['profile_photo']}';

          loading = false; // Set loading to false once data is fetched
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        setState(() {
          loading = false; // Also stop loading if there's an error
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        loading = false; // Stop loading on error as well
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromBackend();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor:Color(0xFF121217),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Center(
            child: Text(
              'Home',
              style: TextStyle(
                fontSize: 20 * fem,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFF121217),
      ),
      body: SafeArea(
          child: Container(
            color: Color(0xFF121217),
            width: double.infinity,
            child: loading
                ? Center(
                child: CircularProgressIndicator()) // Show loading animation
                : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 18),
                if (imageUrl != null)
        Container(
        width: 170 * fem,
        height: 200 * fem,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF9E9EB8),
            width: 3.50, // Adjust the thickness of the border
          ),
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

                    child: Padding(
                      padding: EdgeInsets.all(4.0),

                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,

                      ),
                    ),
                  ),
                SizedBox(height: 18 * fem),
                if (name != null)
                  Text(
                    'Hi,  $name',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Be Vietnam Pro',
                      fontSize: 22 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.25 * ffem / fem,
                      letterSpacing: -0.33 * fem,
                      color: Colors.white,
                    ),
                  ),
                SizedBox(height: 30 * fem),
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
                                      visible: isAvailable!,
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
                                      visible: !isAvailable!,
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
                                  value: isAvailable!,
                                  onChanged: (value) {
                                    setState(() {
                                      isAvailable = value;
                                    });
                                    _updateBookingstatus();
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
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => booking_history(artist_id :artist_id!)));
                              // Navigate to Booking History
                            },
                            child: Container(
                              width: double.infinity,
                              height: 75 * fem, // Adjust the height
                              padding: EdgeInsets.all(16 * fem),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
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
                                  Icon(Icons.arrow_forward_ios, size: 24 * fem,
                                      color: Colors.grey),
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
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => payment_history(artist_id :artist_id!)));
                              // Navigate to Payment History
                            },
                            child: Container(
                              width: double.infinity,
                              height: 75 * fem, // Adjust the height
                              padding: EdgeInsets.all(16 * fem),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
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
                                  Icon(Icons.arrow_forward_ios, size: 24 * fem,
                                      color: Colors.grey),
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
          )

      ),
    );
  }

  void _updateBookingstatus() async {

    final storage = FlutterSecureStorage();

    String? id = await storage.read(key: 'id');
    print(id);
    String? kind = await storage.read(key: 'selected_value');

    if (id == null || kind == null) {
      print('Error: User id or kind is null');
      return;
    }

    String apiUrl;
    if (kind == 'solo_artist') {
      apiUrl = '${Config().apiDomain}/artist/info/$id';
    } else if (kind == 'team') {
      apiUrl = '${Config().apiDomain}/artist/team_info/$id';
    } else {
      print('Error: Unrecognized kind');
      return;
    }

    Map<String, dynamic> booked_status = {
      'booked_status': isAvailable == true ? 0 : 1,
    };
    print( booked_status);

    try {
      var response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
        body: jsonEncode(booked_status),
      );

      if (response.statusCode == 200) {
        print('booked_status saved successfully');
        print('Response: ${response.body}');
      } else {
        print('Failed to save booked_status. Status code: ${response
            .statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (e) {
      print('Error saving booked_status: $e');
    }
  }
}

