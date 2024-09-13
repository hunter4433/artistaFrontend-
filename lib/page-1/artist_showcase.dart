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



class ArtistProfile extends StatefulWidget {
     late String  artist_id;
     String? isteam;
   ArtistProfile( {required this.artist_id, this.isteam});


  @override
  _ArtistProfileState createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  final List<String> demoSkills = ['Guitar', 'Singing', 'Piano',]; // replace with backend data
  final String experience = '5 years'; // replace with backend data (can be '3 months', '2 years', etc.)
  final bool hasSoundSystem = true; // replace with backend data
  final storage = FlutterSecureStorage();
  String? artistName;
  String? artistRole;
  String? artistPrice;
  String? artistRatings;
  String? artistAboutText;
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



  Future<String?> _getKind() async {
    return await storage.read(key: 'selected_value'); // Assuming you stored the token with key 'selected_value'
  }

  @override
  void initState() {
    super.initState();
    fetchArtistWorkInformation(widget.artist_id); // Fetch profile data when screen initializes
  }

  Future<void> fetchArtistWorkInformation(String artist_id) async {
    // String baseUrl = 'http://127.0.0.1:8000/storage/';


    String? kind = await _getKind();

    String apiUrl;

      apiUrl = '${Config().apiDomain}/featured/artist_info/$artist_id';

// Declare a variable to store the name outside the loop

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',

        },
      );
// Declare a variable to store the name outside the loop
String baseUrl='http://192.0.0.2:8000/storage';

      if (response.statusCode == 200) {
        // Map<String, dynamic> userData = json.decode(response.body);
        List<dynamic> artistDataList = json.decode(response.body);
        // print(artistDataList);

        // Inside fetchArtistWorkInformation method
        for (var artistData in artistDataList) {
          // artist_id = artistData['id'].toString();
          artistName = artistData['name'];
          artistRole=artistData['skills'];
          artistPrice=artistData['price_per_hour'];
          artistAboutText=artistData['about_yourself'];
          artistSpecialMessage=artistData['special_message'];
          profilePhoto = '${artistData['profile_photo']}';
          image1 = '${artistData['image1']}';
          image2 = '${artistData['image2']}';
          image3 = '${artistData['image3']}';
          image4 = '${artistData['image4']}';
          video1= '${artistData['video1']}';
          video2= '${artistData['video2']}';
          video3= '${artistData['video3']}';
          video4= '${artistData['video4']}';

          // Add non-null image URLs to the list
          if (image1 != null) imagePathsFromBackend.add(image1!);
          if (image2 != null) imagePathsFromBackend.add(image2!);
          if (image3 != null) imagePathsFromBackend.add(image3!);
          if (image4 != null) imagePathsFromBackend.add(image4!);
          if (video1 != null) VideoPathsFromBackend.add(video1!);
          if (video2 != null) VideoPathsFromBackend.add(video2!);
          if (video3 != null) VideoPathsFromBackend.add(video3!);
          if (video4 != null) VideoPathsFromBackend.add(video4!);
        }
        print(video1);


        print(VideoPathsFromBackend);
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
                                    artistName ?? '', // Use the artistName variable directly
                                    style: TextStyle(
                                      fontSize: 20 * ffem,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),


                                  // FutureBuilder to fetch and display role (e.g., Artist)
                                  Text(
                                    artistRole ?? '', // Use the artistRole variable directly
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
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),


                      SizedBox(height: 15 * fem),

                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 15, bottom: 25),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>booking_artist(artist_id : widget.artist_id)));
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
                      Container(

                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 5*fem),
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
                              Text(
                                'Good At: ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8.0),

                              Expanded(
                                child: Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: demoSkills.map((skill) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xfff5e1e5) ,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        skill,
                                        style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),
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
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              // Display Experience from backend
                              Text(
                                experience,
                                style: TextStyle(fontWeight: FontWeight.w400,
                                  fontSize: 18.0,
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
                                'Has Sound System?: ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              // Display Yes/No for Sound System
                              Text(
                                hasSoundSystem ? 'Yes' : 'No',
                                style: TextStyle(fontWeight: FontWeight.w400,
                                  fontSize: 19.0,
                                  color: hasSoundSystem ? Colors.green : Colors.red,
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

                      Text(
                        'Reviews',
                        style: SafeGoogleFont (
                          'Epilogue',
                          fontSize: 22*ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.25*ffem/fem,
                          letterSpacing: -0.3300000131*fem,
                          color: Color(0xff1c0c11),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>booking_artist(artist_id: widget.artist_id)));
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
                // Rating Bar
                // SizedBox(height: 20), // Add space above the rating bar
                // PanableRatingBar.builder(
                //   initialRating: _currentRating,
                //   minRating: 1,
                //   direction: Axis.horizontal,
                //   allowHalfRating: true,
                //   itemCount: 5,
                //   itemSize: 40.0, // Size of each star
                //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                //   itemBuilder: (context, _) => Icon(
                //     Icons.star,
                //     color: Colors.amber,
                //   ),
                //   onRatingUpdate: (rating) {
                //     setState(() {
                //       _currentRating = rating;
                //     });
                //     print("Rating: $rating");
                //   },
                // ),
                //
                // // "See All Reviews" Button
                // SizedBox(height: 16), // Add space above the button
                // TextButton(
                //   onPressed: () {
                //     // Navigate to the all reviews page
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => AllReviewsPage(),
                //       ),
                //     );
                //   },
                //   child: Text(
                //     'See All Reviews',
                //     style: TextStyle(color: Colors.blue),
                //   ),
                // ),
                //

              ],
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

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isError = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    Uri videoUri = Uri.parse(widget.url); // Convert String to Uri
    _controller = VideoPlayerController.networkUrl(videoUri)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        setState(() {
          _isError = true;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

    return _controller.value.isInitialized
        ? Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        if (!_isPlaying)
          IconButton(
            icon: Icon(Icons.play_arrow, size: 64, color: Colors.white),
            onPressed: _togglePlayPause,
          ),
        if (_isPlaying)
          IconButton(
            icon: Icon(Icons.pause, size: 64, color: Colors.white),
            onPressed: _togglePlayPause,
          ),
      ],
    )
        : Container(
      color: Colors.black,
      child: Center(child: CircularProgressIndicator()),
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