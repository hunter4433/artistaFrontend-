
import 'package:flutter/material.dart';
import 'package:test1/page-1/artist_booking.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


class TeamProfile extends StatefulWidget {
  @override
  _TeamProfileState createState() => _TeamProfileState();
}

class _TeamProfileState extends State<TeamProfile> {


  final storage = FlutterSecureStorage();
  String? artistName;
  String? artistRole;
  String? artistPrice;
  String? artistRatings;
  String? artistAboutText;
  String? artistSpecialMessage;
  late String profilePhoto='';
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  List<String> imagePathsFromBackend = []; // List to store image URLs


  Future<String?> _getToken() async {
    return await storage.read(key: 'token'); // Assuming you stored the token with key 'token'
  }

  Future<String?> _getId() async {
    return await storage.read(key: 'id'); // Assuming you stored the token with key 'id'
  }

  Future<String?> _getKind() async {
    return await storage.read(key: 'selected_value'); // Assuming you stored the token with key 'selected_value'
  }

  @override
  void initState() {
    super.initState();
    fetchArtistWorkInformation(); // Fetch profile data when screen initializes
  }

  Future<void> fetchArtistWorkInformation() async {
    // String baseUrl = 'http://127.0.0.1:8000/storage/';
    String? token = await _getToken();
    String? id = await _getId();
    String? kind = await _getKind();

    print(token);
    print(id);
    print(kind);

    // Initialize API URLs for different kinds
    String apiUrl;

    apiUrl = 'http://127.0.0.1:8000/api/featured/team/$id';

// Declare a variable to store the name outside the loop

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
          // 'Authorization': 'Bearer $token',
        },
      );
// Declare a variable to store the name outside the loop
      String baseUrl='http://127.0.0.1:8000/storage';

      if (response.statusCode == 200) {
        // Map<String, dynamic> userData = json.decode(response.body);
        List<dynamic> artistDataList = json.decode(response.body);
        // print(artistDataList);

        // Inside fetchArtistWorkInformation method
        for (var artistData in artistDataList) {
          artistName = artistData['team_name'];
          artistRole=artistData['skill_category'];
          artistPrice=artistData['price_per_hour'];
          artistAboutText=artistData['about_team'];
          artistSpecialMessage=artistData['special_message'];
          profilePhoto = '$baseUrl/${artistData['profile_photo']}';
          image1 = '$baseUrl/${artistData['image1']}';
          image2 = '$baseUrl/${artistData['image2']}';
          image3 = '$baseUrl/${artistData['image3']}';
          image4 = '$baseUrl/${artistData['image4']}';

          // Add non-null image URLs to the list
          if (image1 != null) imagePathsFromBackend.add(image1!);
          if (image2 != null) imagePathsFromBackend.add(image2!);
          if (image3 != null) imagePathsFromBackend.add(image3!);
          if (image4 != null) imagePathsFromBackend.add(image4!);
        }
        // print(imagePathsFromBackend);

        // String profilePhoto = 'http://127.0.0.1:8000/storage/${userData['data']['attributes']['profile_photo']}';
        //
        // setState(() {
        //   _profileUrl = profilePhoto;
        // });
        // print( _profileUrl);
        setState(() {});
        print(artistRole);
      } else {
        print('Failed to fetch user information. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user information: $e');
    }
    // Now you can access the artistName variable outside the loop
    // print('Artist name: $artistName');
    // print(profilePhoto);
  }



  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    // Simulated list of team members fetched from backend
    final List<Map<String, String>> teamMembersFromBackend = [
      {
        'name': 'Abhishek',
        'role': 'Guitarist',
        'image': 'assets/page-1/images/73B2F1E9-1299-4004-B064-82304F34142F.jpeg',
      },
      {
        'name': 'Dipanshu',
        'role': 'Singer',
        'image': 'assets/page-1/images/B4C057E3-E5F2-4599-ABFF-628BB8EFB49D_1_105_c.jpeg',
      },
      {
        'name': 'Sujan',
        'role': 'Pianist',
        'image': 'assets/page-1/images/7407D34E-D8FE-427F-8817-99990E5517E9_1_105_c.jpeg',
      },
      // {
      //   'name': 'Jane Smith Abhishek Sheoran',
      //   'role': 'creator',
      //   'image': 'assets/page-1/images/7407D34E-D8FE-427F-8817-99990E5517E9_1_105_c.jpeg',
      // },
      // Add more team members as needed
    ];



    // Simulated list of image paths from backend


    // Simulated list of image paths from backend
    String profileImagePathFromBackend = 'profile_image_url_from_backend';

    // Simulated data fetched from backend
    Future<String> fetchName() async {
      // Fetch name from the backend
      return Future.delayed(Duration(seconds: 1), () => 'Carla');
    }

    Future<String> fetchRole() async {
      // Fetch role from the backend
      return Future.delayed(Duration(seconds: 1), () => 'Artist');
    }

    Future<String> fetchRatings() async {
      // Fetch ratings from the backend
      return Future.delayed(Duration(seconds: 1), () => '4.5/5');
    }

    Future<String> fetchPrice() async {
      // Fetch price per hour from the backend
      return Future.delayed(Duration(seconds: 1), () => '200');
    }


    Future<String> fetchAboutText() async {
      // Simulated delay to mimic network request
      await Future.delayed(Duration(seconds: 1));

      // Simulated data fetched from the backend
      String aboutText = 'My work is inspired by nature and the human form. I specialize in murals and paintings.';

      // Return the fetched about text
      return aboutText;
    }

    // Function to fetch the special message from the backend
    Future<String> fetchSpecialMessage() async {
      // Simulated delay to mimic network request
      await Future.delayed(Duration(seconds: 2));

      // Simulated data fetched from the backend
      String specialMessage = 'Thank you for hosting! We are excited to be part of your event.';

      // Return the fetched special message
      return specialMessage;
    }

    Future<String> fetchAvailabilityStatus() async {
      // Simulated delay to mimic network request
      await Future.delayed(Duration(seconds: 2));

      // Simulated data fetched from the backend
      // You can replace this with your actual backend logic to fetch availability status
      return 'Available for Booking'; // Example status fetched from backend
    }

    Widget buildAvailabilityText(String status) {
      Color lightColor;
      switch (status) {
        case 'Available for Booking':
          lightColor = Colors.green;
          break;
        case 'Booked For Today':
          lightColor = Colors.orange;
          break;
        case 'Not Available':
          lightColor = Colors.red;
          break;
        default:
          lightColor = Colors.transparent;
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 8),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightColor,
              boxShadow: [
                BoxShadow(
                  color: lightColor.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      );
    }




    return Scaffold(
      appBar: AppBar(title: Text('Artista'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Use Navigator.pop() to close the current screen (Scene2) and go back to the previous screen (Scene1)
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Container(
            // galileodesignDQb (15:2110)
            width: double.infinity,
            height: 1950*fem,
            decoration: BoxDecoration (
              color: Color(0xffffffff),
            ),
            child: Container(
              // depth0frame0wLb (15:2111)
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration (

              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(
                      // autogroupw2njBkj (JkS1Ti6a5oTyiELwzGW2nj)
                      padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 25*fem, 11.5*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 128 * fem,
                                    height: 128 * fem,
                                    color: Colors.grey[200], // Placeholder color
                                    child: Image.network(
                                      profilePhoto,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20*fem, 5*fem, 0*fem, 3*fem),
                                  // depth4frame1YUo (15:2131)
                                  width: 200*fem,
                                  height: 130*fem,
                                  child: Column(  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // FutureBuilder to fetch and display name
                                      Text(
                                        artistName ?? '', // Use the artistName variable directly
                                        style: TextStyle(
                                          fontSize: 22 * ffem,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff1c0c11),
                                        ),
                                      ),


                                      // FutureBuilder to fetch and display role (e.g., Artist)
                                      Text(
                                        artistRole ?? '', // Use the artistRole variable directly
                                        style: TextStyle(
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff964f66),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),

                                      // FutureBuilder to fetch and display ratings
                                      Row(
                                        children: [
                                          Text(
                                            'Rating: 4.57/5', // Static text
                                            style: TextStyle(
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff1c0c11),
                                            ),
                                          ),
                                          Text(
                                            artistRatings ?? '', // Use the artistRatings variable directly
                                            style: TextStyle(
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff1c0c11),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),


                                      // FutureBuilder to fetch and display price per hour
                                      Row(
                                        children: [
                                          Text(
                                            'Price Per Hour:₹', // Static text
                                            style: TextStyle(
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff1c0c11),
                                            ),
                                          ),
                                          Text(
                                            artistPrice ?? '', // Use the artistPrice variable directly
                                            style: TextStyle(
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff1c0c11),
                                            ),
                                          ),
                                        ],
                                      ),


                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Availability status
                          FutureBuilder<String>(
                            future: fetchAvailabilityStatus(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                if (snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0),
                                    child: buildAvailabilityText(snapshot.data!),
                                  );
                                } else {
                                  return Text(
                                    'Error fetching availability status',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),

                          SizedBox(height: 10 * fem),

                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>booking_artist()));
                                // Handle button press
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
                                  'Book Artist',
                                  style: SafeGoogleFont(
                                    'Be Vietnam Pro',
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

                          // Team members section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0 * fem),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Our Team',
                                  style: TextStyle(
                                    fontSize: 20 * ffem,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff1c0c11),
                                  ),
                                ),
                                SizedBox(height: 12 * fem),
                                // List of team members
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: teamMembersFromBackend.length,
                                  itemBuilder: (context, index) {
                                    // Fetch team member data
                                    final member = teamMembersFromBackend[index];
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 8 * fem),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10 * fem),
                                            child: Container(
                                              width: 56 * fem,
                                              height: 75 * fem,
                                              color: Colors.grey[200],
                                              child: Image.asset(
                                                member['image']!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12 * fem),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                member['name']!,
                                                style: TextStyle(
                                                  fontSize: 16 * ffem,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff1c0c11),
                                                ),
                                              ),
                                              SizedBox(height: 4 * fem),
                                              Text(
                                                member['role']!,
                                                style: TextStyle(
                                                  fontSize: 14 * ffem,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xff1c0c11),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15 * fem),


                          Container(

                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                            child: Text(
                              'About',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 22*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.25*ffem/fem,
                                letterSpacing: -0.3300000131*fem,
                                color: Color(0xff1c0c11),
                              ),
                            ),
                          ),
                          Container(

                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 28*fem),
                            width: 2222*fem,
                            height: 100,
                            child: artistAboutText != null
                                ? Text(
                              artistAboutText!,
                              style: TextStyle(
                                fontSize: 16 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff1c0c11),
                              ),
                            )
                                : Text(
                              'Error fetching about data',
                              style: TextStyle(
                                fontSize: 16 * ffem,
                                fontWeight: FontWeight.w400,
                                color: Colors.red,
                              ),
                            ),


                          ),
                          Text(
                            // audiosamplesxKZ (15:2148)
                            'Audio Sample',
                            style: SafeGoogleFont (
                              'Be Vietnam Pro',
                              fontSize: 22*ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.25*ffem/fem,
                              letterSpacing: -0.3300000131*fem,
                              color: Color(0xff1c0c11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // depth1frame55uy (15:2149)
                      width: double.infinity,
                      height: 80*fem,
                      decoration: BoxDecoration (
                        color: Color(0xffffffff),
                      ),
                      child: Container(
                        // depth2frame024X (15:2150)
                        padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration (
                          color: Color(0xfff2e8ea),
                          borderRadius: BorderRadius.circular(12*fem),
                        ),
                        child: Container(
                          // depth3frame0MMh (15:2151)
                          width: double.infinity,
                          height: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // depth4frame0JGw (15:2152)
                                width: 56*fem,
                                height: 56*fem,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8*fem),
                                  child: Image.asset(
                                    'assets/page-1/images/depth-4-frame-0-bao.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(16*fem, 7.5*fem, 0*fem, 7.5*fem),
                                height: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // depth4frame2v3R (15:2153)
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                      width: 230*fem,
                                      height: double.infinity,
                                      child: Container(
                                        width: 270*fem,
                                        height: 20*fem,
                                        child: Text(
                                          'Nature Inspiration',
                                          style: SafeGoogleFont (
                                            'Be Vietnam Pro',
                                            fontSize: 17*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.25*ffem/fem,
                                            color: Color(0xff1c0c11),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // depth4frame3A6B (15:2160)
                                      width: 40*fem,
                                      height: 40*fem,
                                      child: Image.asset(
                                        'assets/page-1/images/depth-4-frame-3-oFu.png',
                                        width: 40*fem,
                                        height: 40*fem,
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
                    Container(
                      margin: EdgeInsets.fromLTRB(16 * fem, 30, 16 * fem, 0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gallery',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff1c0c11),
                            ),
                          ),
                          SizedBox(height: 12 * fem),
                          // GridView builder for the gallery
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: imagePathsFromBackend.length , // Total count including placeholders
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12 * fem,
                              crossAxisSpacing: 12 * fem,
                              childAspectRatio: 1, // Aspect ratio of each grid item
                            ),
                            itemBuilder: (context, index) {
                              if (index < imagePathsFromBackend.length) {
                                // If index is within the number of actual images
                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to fullscreen view
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullScreenView(
                                          imagePath: imagePathsFromBackend[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    imagePathsFromBackend[index], // Network image path
                                    fit: BoxFit.cover, // Fit the image within the container
                                  ),
                                );

                              } else {
                                // If index exceeds actual images, return empty containers
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12 * fem),
                                    color: Colors.grey[200], // Placeholder color
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),



                    Container(
                      // autogroupcvhmtnB (JkS2cgAzEk6pkAMGDjcvHm)
                      padding: EdgeInsets.fromLTRB(16*fem, 40*fem, 16*fem, 11.5*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // specialmessageforthehost2dV (15:2210)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 23.5*fem),
                            child: Text(
                              'Special Message for the Host',
                              style: SafeGoogleFont (
                                'Epilogue',
                                fontSize: 22*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.25*ffem/fem,
                                letterSpacing: -0.3300000131*fem,
                                color: Color(0xff1c0c11),
                              ),
                            ),
                          ),
                          Container(
                            // depth5frame06dM (15:2215)
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 32 * fem),
                            width: double.infinity,
                            height: 144 * fem,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffe8d1d6)),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(12 * fem),
                            ),
                            child: artistSpecialMessage != null
                                ? Padding(
                              padding: EdgeInsets.all(16 * fem), // Adjust padding as needed
                              child: Text(
                                artistSpecialMessage!,
                                style: TextStyle(
                                  fontSize: 16 * ffem,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff964f66),
                                ),
                              ),
                            )
                                : Text(
                              'Error fetching special message',
                              style: TextStyle(
                                fontSize: 16 * ffem,
                                fontWeight: FontWeight.w400,
                                color: Colors.red,
                              ),
                            ),
                          ),

                          Text(
                            // reviewsZ19 (15:2222)
                            'Reviews',
                            style: SafeGoogleFont (
                              'Epilogue',
                              fontSize: 22*ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.25*ffem/fem,
                              letterSpacing: -0.3300000131*fem,
                              color: Color(0xff1c0c11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // depth1frame15grT (15:2223)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 14*fem),
                      padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 16*fem, 1*fem),
                      width: double.infinity,
                      height: 209*fem,
                      decoration: BoxDecoration (
                        color: Color(0xffffffff),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 45),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>booking_artist()));
                          // Handle button press
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
                            'Book Artist',
                            style: SafeGoogleFont(
                              'Be Vietnam Pro',
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
      ),);
  }
}
// Fullscreen view for images
class FullScreenView extends StatelessWidget {
  final String imagePath;

  FullScreenView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate back when tapped
            Navigator.pop(context);
          },
          child: Image.network(imagePath), // Use Image.network for network images
        ),
      ),
    );
  }
}