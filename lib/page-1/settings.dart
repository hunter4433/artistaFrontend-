
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test1/page-1/account_managment.dart';
import 'package:test1/page-1/artist_info_edit.dart';
import 'package:test1/page-1/customer_support.dart';

import 'package:test1/page-1/edit_team_members.dart';
import 'package:test1/page-1/edit_user_info.dart';
import 'package:test1/page-1/legal.dart';
import 'package:test1/page-1/phone_varification.dart';
import 'package:test1/page-1/review.dart';

import 'package:test1/page-1/sign_in.dart';
import 'package:test1/page-1/skjs.dart';

import '../config.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import'page1.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
   String? userName;
   String? teamName;
   late final Future<Map<String, String?>> futureUserData;
  List<TeamMember> TeamMembers = [
    // TeamMember(
    //   name: 'John Doe',
    //   email: 'john.doe@example.com',
    //   role: 'Designer',
    //   profilePictureUrl: 'https://via.placeholder.com/150', // Dummy profile picture URL
    // ),
    // TeamMember(
    //   name: 'Jane Smith',
    //   email: 'jane.smith@example.com',
    //   role: 'Developer',
    //   profilePictureUrl: 'https://via.placeholder.com/150', // Dummy profile picture URL
    // ),
    // TeamMember(
    //   name: 'Alice Johnson',
    //   email: 'alice.johnson@example.com',
    //   role: 'Marketing Manager',
    //   profilePictureUrl: 'https://via.placeholder.com/150', // Dummy profile picture URL
    // ),
  ];

   @override
   void initState() {
     super.initState();


   }
  //conflict was found here
  final storage = FlutterSecureStorage();

  Future<String?> getSelectedValue() async {
    return await storage.read(key: 'selected_value');
  }

  Future<String?> _getid() async {
    return await storage.read(key: 'artist_id'); // Assuming you stored the token with key 'token'
  }
   Future<String?> _getUserid() async {
     return await storage.read(key: 'user_id'); // Assuming you stored the token with key 'token'
   }
  Future<String?> _getTeamid() async {
    return await storage.read(key: 'team_id'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getKind() async {
    return await storage.read(key: 'selected_value'); // Assuming you stored the token with key 'token'
  }


   Future<Map<String, String?>> fetchArtistInformation() async {
     String? id = await _getid();
     String? team_id = await _getTeamid();
     String? kind = await _getKind();
     String? user=await _getUserid();

     String apiUrl;
     if (kind == 'solo_artist') {
       apiUrl = '${Config().apiDomain}/artist/info/$id';
     } else if (kind == 'team') {
       apiUrl = '${Config().apiDomain}/artist/team_info/$team_id';
     } else {
       apiUrl = '${Config().apiDomain}/info/$user';
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
         // Parse the response JSON
         Map<String, dynamic> userData = json.decode(response.body);
print(' data is $userData');
         String? userName ;
         String? teamName ;
         String? profile_photo;
         // Extract relevant data
         if (kind=='hire'){
           String firstName = userData['first_name'] ?? '';
           String lastName = userData['last_name'] ?? '';
           userName = '$firstName $lastName'.trim();
         }
         else {
           userName = userData['data']['attributes']['name'];
            teamName = userData['data']['attributes']['team_name'];
            profile_photo = userData['data']['attributes']['profile_photo'];
         }

         // Return as a map
         return {'userName': userName, 'teamName': teamName, 'profile_photo': profile_photo };
       } else {
         print('Failed to fetch user information. Status code: ${response.body}');
         return {}; // Return empty map on failure
       }
     } catch (e) {
       print('Error fetching user information: $e');
       return {}; // Return empty map on exception
     }
   }


  Future<bool> logout() async {
    try {

      final String logoutUrlArtist = '${Config().apiDomain}/artist/logout';
      final String logoutUrlHire = '${Config().apiDomain}/logout';

      var kind = await getSelectedValue();
      print(kind);

      // Make the API call to logout
      if (kind == 'hire') {
        final response = await http.post(
          Uri.parse(logoutUrlHire),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            // 'Authorization': 'Bearer $token', // Include the token in the header
          },
        );


        // Check if the request was successful (status code 200)
        if (response.statusCode == 200) {
          await storage.write(key: 'authorised', value: 'false');
          print('successs: ${response.body}');
          return true;
          // Handle successful logout (e.g., navigate to login screen)
        } else {
          // Handle errors (e.g., show error message)
          print('Error: ${response.body}');
        }
        return false;
      }
      if(kind=='team' || kind=='solo_artist'){
        final response = await http.post(
          Uri.parse(logoutUrlArtist),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            // Include the token in the header
          },
        );


        // Check if the request was successful (status code 200)
        if (response.statusCode == 200) {
          await storage.write(key: 'authorised', value: 'false');
          print('successs: ${response.body}');
          return true;
          // Handle successful logout (e.g., navigate to login screen)
        } else {
          // Handle errors (e.g., show error message)
          print('Error: ${response.body}');
        }
        return false;
      }
      } catch (e) {
      // Handle exceptions (e.g., connection errors)
      print('Exception: $e');
    }
    return false;

  }
   // Demo data for testing



  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    Future<void> _showLogoutConfirmationDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF121217), // Change background color of dialog
            title: Text('Logout', style: TextStyle(color: Colors.white)), // Change color of dialog title
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Are you sure you want to log out?',
                    style: TextStyle(color: Colors.white,fontSize: 16), // Change color of dialog content text
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white,fontSize: 17), // Change color of "Cancel" button text
                ),
              ),
              TextButton(
                onPressed: () async {
                  bool flag= await logout();
                  if (flag) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Scene1()),
                    );
                  }else{
                    // You can also show a snackbar or dialog here to notify the user of the error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('something went wrong')),
                    );
                  }
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Color(0xffe5195e),fontSize: 17), // Change color of "Yes" button text
                ),
              ),
            ],
          );
        },
      );
    }


    return Scaffold(  backgroundColor: Color(0xFF121217),
      body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Container(
          // galileodesignh11 (16:2430)
          width: double.infinity,
          height: 844*fem,
          decoration: BoxDecoration (
            color: Color(0xFF121217),
          ),
          child: Container(
            // depth0frame0qN7 (16:2431)
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration (
              color:Color(0xFF121217),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // depth1frame0ZJ7 (16:2432)
                  padding: EdgeInsets.fromLTRB(16*fem, 6*fem, 16*fem, 6*fem),
                  width: double.infinity,
                  height: 72*fem,
                  decoration: BoxDecoration (
                    color: Color(0xFF121217)
                    ,
                  ),
                  child: Container(
                    // depth4frame0WsZ (16:2440)
                    margin: EdgeInsets.fromLTRB(0*fem, 0.75*fem, 0*fem, 0.75*fem),
                    height: double.infinity,
                    child: Center(
                      child: Text(
                        'Settings',
                        style: SafeGoogleFont (
                          'Be Vietnam Pro',
                          fontSize: 22*ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.25*ffem/fem,
                          letterSpacing: -0.2700000107*fem,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),



          FutureBuilder<Map<String, String?>>(
            future: fetchArtistInformation(), // Fetch user data from backend
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Loading state
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Error state
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No User Data Available')); // No data state
              }

              // Extract user details from the fetched data
              final userName = snapshot.data!['userName'];
              final teamName = snapshot.data!['teamName'];
              final imageUrl = snapshot.data!['profile_photo']; // Image URL from backend

              return InkWell(
                onTap: () async {
                  String? kind = await _getKind();
                  if (kind=='hire') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserInformation()),
                    );
                  }
                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()),
                    );
                  }

                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 0),
                  width: double.infinity,
                  height: 136 * fem,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.15),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile icon or image
                      Container(
                        width: 74 * fem,
                        height: 74 * fem,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[500], // Background color if no image
                          image: imageUrl != null && imageUrl.isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover, // Fit the image within the circle
                          )
                              : null, // If no image, show icon
                        ),
                        child: imageUrl == null || imageUrl.isEmpty
                            ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        )
                            : null, // Show icon only if imageUrl is empty
                      ),
                      SizedBox(width: 12 * fem),

                      // User information
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? teamName ?? 'Complete Profile',
                              style: TextStyle(
                                fontSize: 18 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4 * fem),
                            const Text(
                              "Name, mobile no, and more",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                height: 1.2,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Arrow icon for navigation
                      SizedBox(
                        width: 64 * fem,
                        height: 44 * fem,
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

            InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>account_managment()),
                    );
                  },
                  child: Container(
                    // depth1frame5N8P (16:2494)
                    padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                    width: double.infinity,
                    height: 56 * fem,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Specify the border color here
                          width: 0.25, // Specify the border width here
                        ),),
                      // Add decoration as needed
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Account',
                            style: SafeGoogleFont(
                              'Be Vietnam Pro',
                              fontSize: 17 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(

                          // depth2frame1MPD (19:2920)
                          width: 64 * fem,
                          height: 44 * fem,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded, color: Colors.white
                            ,// Different icon
                            // Color of the icon
                            // Size of the icon
                          ),
                        ),
                      ],
                    ),
                  ),
                ),




                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>AccountManagementPage1()),
                    );
                  },
                  child: Container(
                    // depth1frame5N8P (16:2494)
                    padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                    width: double.infinity,
                    height: 56 * fem,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Specify the border color here
                          width: 0.25, // Specify the border width here
                        ),),
                      // Add decoration as needed
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Legal',
                            style: SafeGoogleFont(
                              'Be Vietnam Pro',
                              fontSize: 17 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(

                          // depth2frame1MPD (19:2920)
                          width: 64 * fem,
                          height: 44 * fem,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded, color: Colors.white
                            ,// Different icon
                            // Color of the icon
                            // Size of the icon
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SupportScreen()),
                    );
                  },
                  child: Container(
                    // depth1frame5N8P (16:2494)
                    padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                    width: double.infinity,
                    height: 56 * fem,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Specify the border color here
                          width: 0.25, // Specify the border width here
                        ),),
                      // Add decoration as needed
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(

                            // depth3frame02ij (16:2496)
                            child: Text(
                              'Cusromer Support',
                              style: SafeGoogleFont(
                                'Be Vietnam Pro',
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(

                          // depth2frame1MPD (19:2920)
                          width: 64 * fem,
                          height: 44 * fem,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded, color: Colors.white,// Different icon
                            // Color of the icon

                            // Size of the icon
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(

                  child: Container(
                    // depth1frame5N8P (16:2494)
                    padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                    width: double.infinity,
                    height: 56 * fem,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Specify the border color here
                          width: 0.25, // Specify the border width here
                        ),),
                      // Add decoration as needed
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(

                            // depth3frame02ij (16:2496)
                            child: Text(
                              'App Version',
                              style: SafeGoogleFont(
                                'Be Vietnam Pro',
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 44,
                          width: 94,

                          // depth2frame1MPD (19:2920)

                          child:Center(
                            child: const Text('1.0.0',
                              style: TextStyle(color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w300,
                              )

                              ),
                          ),

                          ),

                      ],
                    ),
                  ),
                ),

                 GestureDetector(
                   onTap: ()async {
                     // Call the logout function when the container is tapped
                     _showLogoutConfirmationDialog();


      },
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 10, 6, 10),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.25,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Be Vietnam Pro',
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Color(0xffe5195e),


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
            ),
    ),);
  }
}