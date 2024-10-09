import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/page-1/artist_booking.dart';
import 'package:test1/page-1/reviews.dart';
import 'package:video_player/video_player.dart';
import '../config.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';



class ArtistProfile extends StatefulWidget {
     late String  artist_id;
// <<<<<<< HEAD
     String? isteam;
// =======
//       String?  isteam;
// >>>>>>> 7843d0fd9f9f56e19be3ee78285dd0192d2cb138
   ArtistProfile( {required this.artist_id, this.isteam});


  @override
  _ArtistProfileState createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  final List<String> demoSkills = ['Guitar', 'Singing', 'Piano']; // replace with backend data
   String? experience ; // replace with backend data (can be '3 months', '2 years', etc.)
  // final bool hasSoundSystem = true; // replace with backend data
  final storage = FlutterSecureStorage();
  String? artistName;
  String? teamName;
  String? artistRole;
  String? teamRole;
  int? hasSoundSystem;
  String? artistPrice;
  String? artistRatings;
  String? artistAboutText;
  String? teamAbout;
  String? artistSpecialMessage;
  String? artist_id;
  late String profilePhoto='';
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? video1;
  String? video2;
  String? video3;
  String? video4;
  List<String> imagePathsFromBackend = [];
  List<String> VideoPathsFromBackend = [];// List to store image URLs
  double? avg;
  double? four;
  double? five;
  double? three;
  double? two;
  double? one;
  int? count;
  late Future<List<dynamic>> _teamMembersFuture;
  late Future<String> _availabilityStatusFuture;

  bool _isLoading = true;


  Future<String?> _getKind() async {
    return await storage.read(key: 'selected_value'); // Assuming you stored the token with key 'selected_value'
  }

  @override
  void initState() {
    super.initState();
    // Call the single initialization function
    initializeData();
    rating();

  }

  // Single function to handle multiple tasks
  void initializeData() {
    // Fetch profile data when screen initializes
    fetchArtistWorkInformation(widget.artist_id);

    // Cache the team members API call if the condition is met
    if (widget.isteam == 'true') {
      _teamMembersFuture = teamMembersFromBackend();
    }

    // Cache the availability status API call
    _availabilityStatusFuture = fetchAvailabilityStatus();
  }



  Future<void> fetchArtistWorkInformation(String artistId) async {
    String apiUrl;

    // Choose the correct API URL based on whether it's a team or an individual artist
    if (widget.isteam == 'true') {
      apiUrl = '${Config().apiDomain}/featured/team/$artistId';
    } else {
      apiUrl = '${Config().apiDomain}/featured/artist_info/$artistId';
    }

    String baseUrl = 'http://192.0.0.2:8000/storage'; // Your base URL

    try {
      // Making the GET request
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> artistDataList = json.decode(response.body);
        print(artistDataList);

        // Clear existing paths to avoid duplicates
        imagePathsFromBackend.clear();
        VideoPathsFromBackend.clear();

        // Process each artist's data
        for (var artistData in artistDataList) {
          setState(() {
            artistName = artistData['name'] ;
            teamName = artistData['team_name'] ;
            artistRole = artistData['skills'] ;
            teamRole = artistData['skill_category'] ;
            artistPrice = artistData['price_per_hour']?.toString() ?? '';
            artistAboutText = artistData['about_yourself'] ;
            teamAbout = artistData['about_team'] ;
            artistSpecialMessage = artistData['special_message'] ?? '';
            profilePhoto = artistData['profile_photo'] ?? '';

            hasSoundSystem = artistData['sound_system'] ?? false;

            // Image and video URLs
            image1 = artistData['image1'];
            image2 = artistData['image2'];
            image3 = artistData['image3'];
            image4 = artistData['image4'];
            video1 = artistData['video1'];
            video2 = artistData['video2'];
            video3 = artistData['video3'];
            video4 = artistData['video4'];

            // Add non-null image URLs to the list
            if (image1 != null) imagePathsFromBackend.add(image1!);
            if (image2 != null) imagePathsFromBackend.add(image2!);
            if (image3 != null) imagePathsFromBackend.add(image3!);
            if (image4 != null) imagePathsFromBackend.add(image4!);

            // Add non-null video URLs to the list
            if (video1 != null) VideoPathsFromBackend.add(video1!);
            if (video2 != null) VideoPathsFromBackend.add(video2!);
            if (video3 != null) VideoPathsFromBackend.add(video3!);
            if (video4 != null) VideoPathsFromBackend.add(video4!);
          });
        }
      } else {
        print('Failed to fetch artist information. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching artist information: $e');
    }
  }

  Future<void> rating() async {
    String apiUrl = '${Config().apiDomain}/artist/${widget.artist_id}/average-rating';
    print(apiUrl);
    print('artist_id is ${widget.artist_id}');

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
          _isLoading = false;

         avg = responseData['average_rating'];
         count= responseData['total_ratings'];
         four= responseData['four_star_ratings']/count;
         five= responseData['five_star_ratings']/count;
          three= responseData['three_star_ratings']/count;
          two= responseData['two_star_ratings']/count;
          one= responseData['one_star_ratings']/count;

      });


      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        // return 'Error fetching availability status';
      }
    } catch (e) {
      print('Error fetching data: $e');
      // return 'Error fetching availability status';
    }
  }


  Future<String> fetchAvailabilityStatus() async {
    String apiUrl = '${Config().apiDomain}/artist/info/${widget.artist_id}';
    print(apiUrl);

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

        int status = responseData['data']['attributes']['booked_status'];

        if (status == 0) {
          return 'Available for Bookings';
        } else   {
          return 'Not Available';
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return 'Error fetching availability status';
      }
    } catch (e) {
      print('Error fetching data: $e');
      return 'Error fetching availability status';
    }
  }

  Future<List<dynamic>> teamMembersFromBackend() async {
    String apiUrl = '${Config().apiDomain}/artist/team_member/${widget.artist_id}';
    // print(apiUrl);

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        print('team members aress $responseData');


        // Assuming responseData contains a list of team members
        // List<dynamic> teamMembers = responseData['data']['team_members'];
        return responseData;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return []; // Return an empty list if there's an error
      }
    } catch (e) {
      print('Error fetching data: $e');
      return []; // Return an empty list in case of an exception
    }
  }


  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;



    // Function to fetch the special message from the backend
    Future<String> fetchSpecialMessage() async {
      // Simulated delay to mimic network request
      await Future.delayed(Duration(seconds: 2));

      // Simulated data fetched from the backend
      String specialMessage = 'Thank you for hosting! We are excited to be part of your event.';

      // Return the fetched special message
      return specialMessage;
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
            width: 12*fem,
            height: 12*fem,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightColor,
              boxShadow: [
                BoxShadow(
                  color: lightColor.withOpacity(0.5),
                  spreadRadius: 3*fem,
                  blurRadius: 7*fem,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 16*fem,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      );
    }



    return Scaffold(
      appBar: AppBar(title: Text('Artist Profile',style:
        TextStyle(color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 21*fem),),
        leading: IconButton(color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
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
          width: double.infinity,
          height: 1950*fem,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  // autogroupw2njBkj (JkS1Ti6a5oTyiELwzGW2nj)
                  margin: EdgeInsets.fromLTRB(16*fem, 16*fem, 5*fem, 11.5*fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 12 * fem),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9.0), // Set the radius to make the corners round
                              child: Container(
                                width: 115 * fem,
                                height: 150 * fem,
                                color: Colors.grey[200], // Placeholder color
                                child: Image.network(
                                  profilePhoto,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20*fem,0*fem, 0*fem, 10*fem),
                              padding: EdgeInsets.fromLTRB(0*fem, 20*fem, 0*fem, 0*fem),
                              // depth4frame1YUo (15:2131)
                              width:220*fem,
                              height: 150*fem,
                              child: Column(  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // FutureBuilder to fetch and display name
                                  Text(
                                    artistName ?? teamName ?? '', // Use the artistName variable directly
                                    style: TextStyle(
                                      fontSize: 20 * ffem,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),


                                  // FutureBuilder to fetch and display role (e.g., Artist)
                                  Text(
                                    artistRole ?? teamRole ?? '', // Use the artistRole variable directly
                                    style: TextStyle(
                                      fontSize: 17 * ffem,
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
                                          fontSize: 17 * ffem,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        artistRatings ?? '', // Use the artistRatings variable directly
                                        style: TextStyle(
                                          fontSize: 17 * ffem,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
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
                                        'Price Per Hour: ₹ ', // Static text
                                        style: TextStyle(
                                          fontSize: 17 * ffem,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        artistPrice ?? '', // Use the artistPrice variable directly
                                        style: TextStyle(
                                          fontSize: 17 * ffem,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
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
                    FutureBuilder<String>(
                      future: _availabilityStatusFuture, // Use the cached future
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show loading indicator
                        } else if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: buildAvailabilityText(snapshot.data!), // Use the fetched availability status
                          );
                        } else {
                          return Text(
                            'Error fetching availability status',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          );
                        }
                      },
                    ),

                      SizedBox(height: 15 * fem),

                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 15, bottom: 25),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>booking_artist(artist_id : widget.artist_id, isteam: widget.isteam )));
                            // Handle button press
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffe5195e),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9 * fem),
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
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5 * ffem / fem,
                                letterSpacing: 0.2399999946 * fem,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.isteam =='true')
                      // Team members section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Team Members:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1c0c11),
                                ),
                              ),
                              SizedBox(height: 12),
                              // FutureBuilder for fetching team members
                              FutureBuilder<List<dynamic>>(
                                future: _teamMembersFuture, // Use cached future
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator(); // Show a loading indicator while waiting
                                  } else if (snapshot.hasError) {
                                    return Text('Error fetching team members'); // Handle any error
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Text('No team members available'); // Handle case when no data is returned
                                  }

                                  List<dynamic> teamMembers = snapshot.data!; // Extract team members from snapshot

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: teamMembers.length, // Use the length of team members list
                                    itemBuilder: (context, index) {
                                      final member = teamMembers[index];
                                      return Container(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Container(
                                                width: 70,
                                                height: 85,
                                                color: Colors.grey[200],
                                                child: member['profile_photo'] != null
                                                    ? Image.network(
                                                  member['profile_photo'],
                                                  fit: BoxFit.cover,
                                                )
                                                    : Icon(Icons.person), // Fallback if no image is available
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  member['member_name'] ?? 'Unknown',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff1c0c11),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  member['role'] ?? 'Unknown role',
                                                  style: TextStyle(
                                                    fontSize: 15,
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
                                  );
                                },
                              ),
                            ],
                          ),
                        ),



                      Container(

                        margin: EdgeInsets.fromLTRB(0*fem, 20*fem, 0*fem, 4*fem),
                        child: Text(
                          'About',
                          style: SafeGoogleFont (
                            'Be Vietnam Pro',
                            fontSize: 22*ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.25*ffem/fem,
                            letterSpacing: -0.3300000131*fem,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 12*fem,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row for Skills
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [



                              Expanded(
                                child: Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: demoSkills.map((skill) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 9.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xfff5e1e5) ,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        skill,
                                        style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),

                          // Row for Experience
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Subheading for Experience
                              Text(
                                'Experience: ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              // Display Experience from backend
                              Text(
                                experience ?? teamAbout ?? '',
                                style: TextStyle(fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),

                          // Row for Sound System
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Subheading for Sound System
                              Text(
                                'Has Sound System?:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8.0*fem),
                              // Display Yes/No for Sound System
                              Text(
                                hasSoundSystem != null ? 'Yes' :'Will be arranged by\n Homestage',
                                style: TextStyle(fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: hasSoundSystem != null ? Colors.green : Colors.pink,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),



              // Container(
              //
              //           margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 28*fem),
              //           width: 2222*fem,
              //           height: 100,
              //           child: artistAboutText != null
              //               ? Text(
              //             artistAboutText!,
              //             style: TextStyle(
              //               fontSize: 16 * ffem,
              //               fontWeight: FontWeight.w400,
              //               height: 1.5 * ffem / fem,
              //               color: Color(0xff1c0c11),
              //             ),
              //           )
              //               : Text(
              //             'Error fetching about data',
              //             style: TextStyle(
              //               fontSize: 16 * ffem,
              //               fontWeight: FontWeight.w400,
              //               color: Colors.red,
              //             ),
              //           ),
              //
              //         ),

                    ],
                  ),
                ),


                Container(
                  margin: EdgeInsets.fromLTRB(15 * fem, 15, 16 * fem, 0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 22 * ffem,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12 * fem),
                      // GridView builder for the gallery
                  SizedBox(
                    height: 200 * fem,

                    child:ListView.builder(
                        scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
                        itemCount: imagePathsFromBackend.length, // Total count
                        itemBuilder: (context, index) {
                          if (index < imagePathsFromBackend.length) {
                            // Display images in the carousel
                            return GestureDetector(
                              onTap: () {
                                // Navigate to fullscreen view on image tap
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenView(
                                      imagePath: imagePathsFromBackend[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 150 * fem, // Set width of each item in the carousel
                                margin: EdgeInsets.symmetric(horizontal: 5.5 * fem), // Add margin between items
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9 * fem), // Example border radius
                                  child: Image.network(
                                    imagePathsFromBackend[index], // Network image path
                                    fit: BoxFit.cover, // Fit the image within the container
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // Placeholder when index exceeds the image list
                            return Container(
                              width: 150 * fem, // Placeholder width
                              margin: EdgeInsets.symmetric(horizontal: 5.5 * fem), // Placeholder margin
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9 * fem), // Example border radius
                                color: Colors.grey[200], // Placeholder color
                              ),
                            );
                          }
                        },
                      ),
                  ),
                    ],
                  ),
                ),
                //VideoPathsFromBackend.length
            Container(
              margin: EdgeInsets.fromLTRB(15 * fem, 25*fem, 16 * fem, 0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Video Samples',
                    style: TextStyle(
                      fontSize: 22 * ffem,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12 * fem),
                  // GridView builder for the gallery
              SizedBox(
                height: 200 * fem, // Set a fixed height for the carousel
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
                  itemCount: VideoPathsFromBackend.length, // Total count
                  itemBuilder: (context, index) {
                    if (index < VideoPathsFromBackend.length) {
                      // Display video player in the carousel
                      return GestureDetector(
                        onTap: () {
                          // Navigate to fullscreen video view on tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenVideoView(
                                videoUrl: VideoPathsFromBackend[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150 * fem, // Set width of each item in the carousel
                          margin: EdgeInsets.symmetric(horizontal: 5.0 * fem), // Add margin between items
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9 * fem), // Example border radius
                            child: VideoPlayerWidget(url: VideoPathsFromBackend[index]),
                          ),
                        ),
                      );
                    } else {
                      // Placeholder when index exceeds the video list
                      return Container(
                        width: 150 * fem, // Placeholder width
                        margin: EdgeInsets.symmetric(horizontal: 5.5 * fem), // Placeholder margin
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9 * fem), // Example border radius
                          color: Colors.grey[200], // Placeholder color
                        ),
                      );
                    }
                  },
                ),
              ),
                ],
              ),
            ),





                Container(
                  padding: EdgeInsets.fromLTRB(16*fem, 30*fem, 16*fem, 11.5*fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 23.5 * fem),
                        child: Text(
                          'Message for the Host',
                          style: SafeGoogleFont(
                            'Be Vietnam Pro',
                            fontSize: 22 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.25 * ffem / fem,
                            letterSpacing: -0.3300000131 * fem,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 32 * fem),
                        width: double.infinity,
                        height: 38 * fem,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffe8d1d6)),
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(12 * fem),
                        ),
                        child: artistSpecialMessage != null
                            ? Padding(
                          padding: EdgeInsets.all(16 * fem),
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

// Reviews section heading
                      Text(
                        'Reviews',
                        style: SafeGoogleFont(
                          'Epilogue',
                          fontSize: 22 * ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.25 * ffem / fem,
                          letterSpacing: -0.3300000131 * fem,
                          color: Color(0xff1c0c11),
                        ),
                      ),
                  SizedBox(
                    height: 10*fem,
                  ),


// Add the ReviewsSection widget here
                      _isLoading
                          ? Center(
                        child: CircularProgressIndicator(), // Show loader while fetching data
                      )
                      :ReviewsSection(
                        averageRating: avg!, // Replace with dynamic data
                        totalReviews: count!, // Replace with dynamic data
                        ratingDistribution: {
                          5: five!,  // 70% of reviews are 5 stars
                          4: four!,  // 20% of reviews are 4 stars
                          3: three!, // 5% of reviews are 3 stars
                          2: two!, // 3% of reviews are 2 stars
                          1: one!, // 2% of reviews are 1 star
                        },
                      ),

                Padding(
                  padding: EdgeInsets.only(left: 5*fem,top: 20*fem, right: 5*fem, bottom: 45*fem),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>booking_artist(artist_id: widget.artist_id, isteam: widget.isteam )));
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
        ],),
            ),
    ),),),);
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

class VideoPlayerWidget extends StatefulWidget {
  final String url; // Video URL (could be .mp4 or .m3u8)

  const VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isError = false;
  bool _isBuffering = true;

  @override
  void initState() {
    super.initState();

    // Initialize the VideoPlayerController
    _videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            autoPlay: false, // Disable autoplay for lazy loading
            looping: false,
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Text(
                  'Error loading video',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          );
          _isBuffering = false;
        });
      }).catchError((error) {
        setState(() {
          _isError = true;
          _isBuffering = false;
        });
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Error handling UI
    if (_isError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Text(
            'Error loading video',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Show loader while the video is buffering or not initialized
    if (_isBuffering || _chewieController == null) {
      return Container(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Video player widget with Chewie
    return Chewie(
      controller: _chewieController!,
    );
  }
}

class FullScreenVideoView extends StatelessWidget {
  final String videoUrl;

  FullScreenVideoView({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Video'),
      ),
      body: Center(
        child: VideoPlayerWidget(url: videoUrl),
      ),
    );
  }
}



class ReviewsSection extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, double> ratingDistribution; // Star rating and its percentage

  ReviewsSection({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390; // Your base width for scaling
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Average Rating Row
        Row(
          children: [
            Icon(Icons.star, color: Color(0xFFFFB300), size: 30 * fem), // Scaled icon size
            SizedBox(width: 8 * fem),
            Text(
              averageRating.toStringAsFixed(1),
              style: TextStyle(fontSize: 24 * fem, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8 * fem),
            Text(
              " ($totalReviews reviews)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17 * fem,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 16 * fem),

        // Rating Distribution (5-star, 4-star, etc.)
        Column(
          children: List.generate(5, (index) {
            int starCount = 5 - index;
            return _buildRatingLine(starCount, ratingDistribution[starCount] ?? 0.0, fem);
          }),
        ),

        SizedBox(height: 16 * fem),

        // Button to see all reviews
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigate to a page that shows all reviews
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllReviewsPage(),
                ),
              );
            },
            child: Text(
              "See All Reviews",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16 * fem,
              ),
            ),
          ),
        ),
      ],
    );
  }

// Helper function to build rating lines
  Widget _buildRatingLine(int starCount, double percentage, double fem) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5.0 * fem, 0, 0, 0),
          child: Text(
            "$starCount star",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18 * fem, // Scale the font size
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8 * fem),
        Padding(
          padding: EdgeInsets.fromLTRB(12.0 * fem, 0, 0, 0),
          child: Container(
            width: 270 * fem, // Scale the width
            height: 9 * fem,  // Scale the height
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5 * fem), // Scale border radius
              child: LinearProgressIndicator(
                value: percentage, // Percentage of reviews for this star
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe5195e)),
              ),
            ),
          ),
        ),
      ],
    );
  }}

  class AllReviewsPage extends StatefulWidget {
    // Simulating reviews fetched from backend
    @override
    _AllReviewsPageState createState() => _AllReviewsPageState();

  }

class _AllReviewsPageState extends State<AllReviewsPage>{



    List<Map<String, dynamic>> reviews = [
    // {
    //   'profilePicture': 'https://via.placeholder.com/150', // Placeholder image URL
    //   'name': 'John Doe',
    //   'rating': 4,
    //   'heading': 'Great performance!',
    //   'review': 'The artist was amazing, truly talented and professionalghghghghghghghghghjgh'
    //       'ghgghghjghvghgjghghgfgkkkhj.'
    // },
    // {
    //   'profilePicture': 'https://via.placeholder.com/150',
    //   'name': 'Jane Smith',
    //   'rating': 5,
    //   'heading': 'Incredible!',
    //   'review': 'Best performance I’ve ever seen! Highly recommend.'
    // },
    // Add more reviews...
  ];
  @override
  void initState() {
    super.initState();
    // Call the single initialization function

    rating();

  }


Future<void> rating() async {
      String apiUrl = '${Config().apiDomain}/review/';
      print(apiUrl);


      try {
        var response = await http.get(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
          },
        );

        if (response.statusCode == 200) {
           // List<Map<String, dynamic>> reviews = json.decode(response.body);
           List<dynamic> rawReviews = json.decode(response.body);
           setState(() {
             // Decode the response as a List<dynamic>


             // Cast each item in the list to Map<String, dynamic>
              reviews = rawReviews.cast<Map<String, dynamic>>();

             // Now you can work with `reviews` as a List of maps
           });
           
           // String user_id=reviews['user_id'].toString() ;

            print(reviews);


          print(reviews);


        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
          // return 'Error fetching availability status';
        }
      } catch (e) {
        print('Error fetching data: $e');
        // return 'Error fetching availability status';
      }
    }



  // Star rating widget
  Widget buildStarRating(int rating) {
    double baseWidth = 390;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Color(0xFFFFB300),
          size: 22,
        );
      }),
    );
  }

  // Single review item widget
  Widget buildReviewItem(Map<String, dynamic> review, double fem, double ffem) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15 * fem, horizontal: 16 * fem),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular profile picture
          // Circular profile picture or default grey icon
          CircleAvatar(
            radius: 26 * fem,
            backgroundColor: Colors.grey[200], // Grey background
            child: ClipOval(
              child: review['photo'] != null && review['photo'].isNotEmpty
                  ? Image.network(
                review['photo'],
                width: 52 * fem, // Size should match the radius
                height: 52 * fem,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to default icon if image fails to load
                  return Icon(
                    Icons.account_circle,
                    size: 52 * fem,
                    color: Colors.grey[400],
                  );
                },
              )
                  : Icon(
                Icons.account_circle,
                size: 52 * fem, // Matching size
                color: Colors.grey[400],
              ),
            ),
          ),

          SizedBox(width: 12 * fem),

          // Review content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review['rating'].toString(),
                      style: TextStyle(
                        fontSize: 17 * ffem,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    buildStarRating(review['rating']),
                  ],
                ),
                SizedBox(height: 4 * fem),

                // Heading
                Text(
                  review['rating'].toString(),
                  style: TextStyle(
                    fontSize: 15 * ffem,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4 * fem),

                // Review text
                Text(
                  review['review_text'],
                  style: TextStyle(
                    fontSize: 15 * ffem,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double fem = MediaQuery.of(context).size.width / 390;
    double ffem = fem * 0.97;



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'All Reviews',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            // Use Navigator.pop() to close the current screen (Scene2) and go back to the previous screen (Scene1)
            Navigator.pop(context);
          },
        ),
      ),
      body: reviews.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show a loader if reviews are not yet fetched
          : ListView.builder(
        itemCount: reviews.length, // Number of reviews from the backend
        itemBuilder: (context, index) {
          return buildReviewItem(reviews[index], fem, ffem);
        },
      ),
    );


    // // Function to build each review item
    // Widget buildReviewItem(Map<String, dynamic> review, double fem, double ffem) {
    //   return Card(
    //     margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    //     child: Padding(
    //       padding: EdgeInsets.all(16.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Row(
    //             children: [
    //               CircleAvatar(
    //                 backgroundImage: NetworkImage(review['profilePicture']),
    //               ),
    //               SizedBox(width: 10),
    //               Text(
    //                 review['name'],
    //                 style: TextStyle(
    //                   fontSize: 16 * ffem,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           SizedBox(height: 10),
    //           Row(
    //             children: [
    //               Icon(Icons.star, color: Colors.yellow, size: 16 * fem),
    //               SizedBox(width: 4),
    //               Text('${review['rating']} stars'),
    //             ],
    //           ),
    //           SizedBox(height: 10),
    //           Text(
    //             review['heading'],
    //             style: TextStyle(
    //               fontSize: 14 * ffem,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           SizedBox(height: 8),
    //           Text(review['review']),
    //         ],
    //       ),
    //     ),
    //   );
  }


}
