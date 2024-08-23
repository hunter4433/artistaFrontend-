import 'package:flutter/material.dart';
import 'package:test1/page-1/artist_booking.dart';
import 'package:video_player/video_player.dart';
import '../config.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


class ArtistProfile extends StatefulWidget {
     late String  artist_id;
   ArtistProfile( {required this.artist_id});


  @override
  _ArtistProfileState createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {

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
          artist_id = artistData['artist_id'].toString();
          artistName = artistData['name'];
          artistRole=artistData['skills'];
          artistPrice=artistData['price_per_hour'];
          artistAboutText=artistData['about_yourself'];
          artistSpecialMessage=artistData['special_message'];
          profilePhoto = '$baseUrl/${artistData['profile_photo']}';
          image1 = '$baseUrl/${artistData['image1']}';
          image2 = '$baseUrl/${artistData['image2']}';
          image3 = '$baseUrl/${artistData['image3']}';
          image4 = '$baseUrl/${artistData['image4']}';
          video1= '$baseUrl/${artistData['video1']}';
          video2= '$baseUrl/${artistData['video2']}';
          video3= '$baseUrl/${artistData['video3']}';
          video4= '$baseUrl/${artistData['video4']}';

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
                                margin: EdgeInsets.fromLTRB(20*fem, 5*fem, 0*fem, 15*fem),
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


                        SizedBox(height: 15 * fem),

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
                margin: EdgeInsets.fromLTRB(16 * fem, 30, 16 * fem, 0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video Samples',
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
                      itemCount: VideoPathsFromBackend.length, // Total count including placeholders
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12 * fem,
                        crossAxisSpacing: 12 * fem,
                        childAspectRatio: 1, // Aspect ratio of each grid item
                      ),
                      itemBuilder: (context, index) {
                        if (index < VideoPathsFromBackend.length) {
                          // If index is within the number of actual videos
                          return GestureDetector(
                            onTap: () {
                              // Navigate to fullscreen view
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenVideoView(
                                    videoUrl: VideoPathsFromBackend[index],
                                  ),
                                ),
                              );
                            },
                            child: VideoPlayerWidget(url: VideoPathsFromBackend[index]),
                          );
                        } else {
                          // If index exceeds actual videos, return empty containers
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
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
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 23.5 * fem),
                          child: Text(
                            'Special Message for the Host',
                            style: SafeGoogleFont(
                              'Epilogue',
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.25 * ffem / fem,
                              letterSpacing: -0.3300000131 * fem,
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