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
  return await storage.read(key: 'id'); // Assuming you stored the token with key 'token'
}
Future<String?> _getKind() async {
  return await storage.read(key: 'selected_value'); // Assuming you stored the token with key 'token'
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
      return
        ('hi');
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
        return ('hi');
      }
    } catch (e) {
      print('Error fetching name: $e');
      return ("hi");
    }
    return ('hi');
  }

  Future<String> getImageUrlFromBackend() async {
    String baseUrl = 'http://127.0.0.1:8000/storage/';
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
      return
        ('hi');
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

        // Construct complete URLs for image// Replace with your actual base URL

        String profile_photo = '$baseUrl/${userData['data']['attributes']['profile_photo']}';
        // Update the state with the fetched image URL
        // setState(() {
        //   // Assuming imageUrl is a variable in your stateful widget
        // });
        return profile_photo;
      } else {
        print('Failed to fetch image URL. Status code: ${response.statusCode}');
        return ('bi');
      }
    } catch (e) {
      print('Error fetching image URL: $e');
      return ('bi');
    }

  }
  @override
  void initState() {
    super.initState();
    getImageUrlFromBackend();
    getNameFromBackend();// Fetch profile data when screen initializes
  }

  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: Text( 'ARTISTA',
          textAlign: TextAlign.center,
          style: SafeGoogleFont(
            'Be Vietnam Pro',
            fontSize: 22 * ffem,
            fontWeight: FontWeight.w700,
            height: 1.25 * ffem / fem,
            color: Color(0xffa53a5e),
          ),),
        backgroundColor: Color(0xffffffff),

        // Add a back arrow in the top-left corner to go back to the previous screen

      ),
      body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Container(

          width: double.infinity,
          height: 844*fem,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            SizedBox(
              height: 18,
            ),
              Container(
                // depth3frame0GvB (19:2886)
                margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 1*fem, 28.5*fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 128 * fem,
                      height: 128 * fem,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey, // Placeholder color until the image is loaded
                      ),
                      child:FutureBuilder<String>(
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
                    SizedBox(
                      height: 18*fem,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 28.5 * fem),
                      width: double.infinity,
                      child: Column(

                        children: [
                          FutureBuilder<String>(
                            future: getNameFromBackend(), // Function to fetch name from backend
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                String name = snapshot.data ?? 'Artist'; // Fallback to a default name if no data received
                                return Text(
                                  'Hi, $name',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Be Vietnam Pro',
                                    fontSize: 22 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.25 * ffem / fem,
                                    letterSpacing: -0.3300000131 * fem,
                                    color: Color(0xff1e0a11),
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
              Container(
                // depth1frame2SiB (19:2893)
                padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
                width: double.infinity,
                height: 72*fem,
                decoration: BoxDecoration (
                  color: Color(0xffffffff),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth2frame0A8P (19:2894)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 45.53*fem, 0*fem),
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // depth3frame0VwM (19:2895)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                            width: 48*fem,
                            height: 48*fem,
                            child: Image.asset(
                              'assets/page-1/images/depth-3-frame-0-Y6K.png',
                              width: 48*fem,
                              height: 48*fem,
                            ),
                          ),
                          Container(
                            // depth3frame1DcT (19:2900)
                            margin: EdgeInsets.fromLTRB(0*fem, 1.5*fem, 0*fem, 1.5*fem),
                            width: 180.47*fem,
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // depth4frame0kMV (19:2901)
                                  width: 182*fem,
                                  height: 24*fem,

                                    child: Text(
                                      'Availability',
                                      style: SafeGoogleFont (
                                        'Be Vietnam Pro',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5*ffem/fem,
                                        color: Color(0xff1e0a11),

                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: isAvailable, // Show this text if switch is on
                                  child: Container(
                                    // depth4frame1rQX (19:2904)
                                    width: double.infinity,
                                    child: Text(
                                      'I\'m Available for Bookings',
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xffa53a5e),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !isAvailable, // Show this text if switch is off
                                  child: Container(
                                    // depth4frame1rQX (19:2904)
                                    width: double.infinity,
                                    child: Text(
                                      'I\'ll be back soon',
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xffa53a5e),
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
                    Switch(
                      value: isAvailable, // Set initial value of the switch
                      onChanged: (value) {
                        setState(() {
                          isAvailable= value;

                        });
                        // Handle switch value change
                      },
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.redAccent,
                      inactiveThumbColor: Colors.white,
                    ),

                  ],
                ),
              ),
              Container(
                // depth1frame3tc7 (19:2911)
                margin: EdgeInsets.fromLTRB(0*fem, 30*fem, 0*fem, 4*fem),
                padding: EdgeInsets.fromLTRB(16*fem, 13*fem, 18*fem, 14*fem),
                width: double.infinity,
                height: 72*fem,
                decoration: BoxDecoration (

                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth3frame0bFd (19:2913)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 4.27*fem, 0*fem),
                      width: 317.73*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0j6w (19:2914)
                            width: 133*fem,
                            height: 24*fem,
                            child: Center(
                              child: Text(
                                'Payment history',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff1e0a11),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => payment_history()),
                              );

                          } ,
                            child: Container(
                              // depth4frame1qfm (19:2917)
                              width: 43*fem,
                              height: 21*fem,

                                child: Text(
                                  'View',
                                  style: SafeGoogleFont (
                                    'Be Vietnam Pro',
                                    fontSize: 14*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5*ffem/fem,
                                    color: Color(0xffa53a5e),
                                  ),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // depth2frame1MPD (19:2920)

                      width: 34*fem,
                      height: 62*fem,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => payment_history()),
                          );

                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_sharp, // Different icon
                          // Color of the icon
                          // Size of the icon
                        ),


                      ),

                    ),
                  ],
                ),
              ),


              Container(
                padding: EdgeInsets.fromLTRB(16*fem, 13*fem, 0*fem, 14*fem),
                width: double.infinity,
                height: 72*fem,
                decoration: BoxDecoration (
                  color: Color(0xffffffff),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth3frame0VQs (19:2946)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 188.84*fem, 0*fem),
                      width: 132.16*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0d1H (19:2947)
                            width: 145*fem,
                            child: Text(
                              'Booking History',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: Color(0xff1e0a11),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => booking_history()),
                              );

                            },
                            child: Container(
                              // depth4frame1Ye3 (19:2950)
                              width: 135*fem,
                              height: 21*fem,

                                child: Text(
                                  'View all bookings',
                                  style: SafeGoogleFont (
                                    'Plus Jakarta Sans',
                                    fontSize: 14*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5*ffem/fem,
                                    color: Color(0xffa53a5e),

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => booking_history()),
                        );

                        // Handle buttonn press
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp, // Different icon
                         // Color of the icon
                         // Size of the icon
                      ),


                    ),

                      // depth2frame1GK9 (19:2953)

                      width: 34*fem,
                      height: 62*fem,

                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
            ),
    ),);
  }
}