import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/artist_showcase.dart';
import 'package:test1/page-1/booking_artis.dart';
import 'package:test1/page-1/team_showcase.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:video_player/video_player.dart';


import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:video_player/video_player.dart';

class Home_user extends StatefulWidget {
  @override
  _Home_userState createState() => _Home_userState();
}

class _Home_userState extends State<Home_user> {
  final storage = FlutterSecureStorage();

  // Dummy data for testing. Replace it with actual data from your backend.
  final List<Map<String, dynamic>> categories = [

    {
      'name': 'Musician',
      'type': 'image',
      'source': 'assets/page-1/images/48ef3e31f4c4f2957aeaf2cf55f0b7aa.jpg'
    },
    {
      'name': 'Regional',
      'type': 'image',
      'source': 'assets/page-1/images/06fedd40378f3490fc8916b4938f8d69.jpg'
    },
    {
      'name': 'Comedian',
      'type': 'image',
      'source': 'assets/page-1/images/6cc6919ddd22db21477c6e25eb8c5b26.jpg'
    },
    {
      'name': 'DJ',
      'type': 'image',
      'source': 'assets/page-1/images/c925aa5a1455c2d4c115abae915a5fbf.jpg'
    },
    {
      'name': 'Visual Artist',
      'type': 'image',
      'source': 'assets/page-1/images/514f5c2e851363191bb1b020237eec7b.jpg'
    },
    {
      'name': 'Dancer',
      'type': 'image', // indicating it's a video
      'source': 'assets/page-1/images/50ae5f0488eec597224d33e1c944b203.jpg' // path to the video asset
    },
    {
      'name': 'Chef',
      'type': 'image', // indicating it's a video
      'source': 'assets/page-1/images/a348ad2eb041aba8f0fe461e5023b0cb.jpg' // path to the video asset
    },
    {
      'name': 'Magician',
      'type': 'image',
      'source': 'assets/page-1/images/2715fd5e2b75cf7ac53ba44d6abc4124.jpg'
    },

    // Add more data as needed
  ];

  //videoplayer

  final List<Map<String, dynamic>> featuredArtists = [
    // Add more data as needed
  ];

  final List<Map<String, dynamic>> bestArtists = [];

  @override
  void initState() {
    super.initState();
    // Call the function to fetch data when the widget is initialized
    fetchFeaturedArtists();
    fetchFeaturedTeams();
  }

  // Function to make the API call
  Future<void> fetchFeaturedArtists() async {
    Future<String?> _getLatitude() async {
      return await storage.read(key: 'latitude'); // Assuming you stored the token with key 'token'
    }
    Future<String?> _getLongitude() async {
      return await storage.read(key: 'longitude'); // Assuming you stored the token with key 'token'
    }

    String? latitude = await _getLatitude();
    String? longitude = await _getLongitude();

    // for (int index = 0; index < categories.length; index++) {
    //   String? source = categories[index]['source'] as String?;
    //   if (source != null) {
    //     // Here you can use the 'source' variable
    //     print('Source at index $index: $source');
    //   } else {
    //     // Handle cases where 'source' is null
    //     print('Source at index $index is null');
    //   }
    // }

    try {
      String apiUrl = 'http://192.0.0.2:8000/api/home/featured?lat=$latitude&lng=$longitude';
      // Make the HTTP GET request
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
          // 'Authorization': 'Bearer $token', // Include the token in the header
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response
        List<dynamic> data = jsonDecode(response.body);

        // Clear the existing list
        setState(() {
          featuredArtists.clear();
          String baseUrl = 'http://192.0.0.2:8000/storage/';

          // Populate the featuredArtists list with the response data
          for (var item in data) {
            featuredArtists.add({
              'id': item['id'],
              'name': item['name'],
              'image': 'http://192.0.0.2:8000/storage/${item['profile_photo']}',
              // 'rating': item['rating'].toString(),
              'skill': item['skills'],
            });
          }
        });

        // Map<String, dynamic> responseData = jsonDecode(response.body);

        print(featuredArtists);
      } else {
        // Handle the error
        print('Failed to load data: ${response.body}');
      }
    } catch (error) {
      // Handle any exceptions
      print('Error fetching data: $error');
    }
  }

  //apicall for team
  Future<void> fetchFeaturedTeams() async {
    try {
      String apiUrl = 'http://192.0.0.2:8000/api/home/featured/team';
      // Make the HTTP GET request
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
          // 'Authorization': 'Bearer $token', // Include the token in the header
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response
        List<dynamic> data = jsonDecode(response.body);

        // Clear the existing list
        setState(() {
          bestArtists.clear();
          String baseUrl = 'http://192.0.0.2:8000/storage/';

          // Populate the featuredArtists list with the response data
          for (var item in data) {
            // Check if item is not null before accessing its properties
            if (item != null) {
              String? name = item['team_name'];
              String? profilePhoto = item['profile_photo'];
              String? skills = item['skill_category'];

              // Check if name and profilePhoto are not null before adding to bestArtists
              if (name != null && profilePhoto != null && item['id'] != null) {
                String id = item['id'].toString(); // Convert id to String
                bestArtists.add({
                  'id': id,
                  'name': name,
                  'image': 'http://192.0.0.2:8000/storage/$profilePhoto',
                  'skill': skills,
                });

              }

            }
          }
        });

        print(bestArtists);
      } else {
        // Handle the error
        print('Failed to load data: ${response.body}');
      }
    } catch (error) {
      // Handle any exceptions
      print('Error fetching data: $error');
    }
  }

  final List<Map<String, dynamic>> seasonal = [
    {
      'name': 'Alpin Band',
      'image': 'assets/page-1/images/music-of-dhwani-1.jpg'
    },
    {
      'name': 'Tech House',
      'image': 'assets/page-1/images/Oxygen-Band-1024x768.jpg'
    },
    {
      'name': 'Trance',
      'image': 'assets/page-1/images/music-of-dhwani-1.jpg'
    },
    // Add more data as needed
  ];

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Text(
            'HomeStage',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xff1c0c11),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        // You can change the app bar background color if needed
        // You can change the app bar text color if needed
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories List
                Container(
                  padding: EdgeInsets.fromLTRB(15 * fem, 10 * fem, 0 * fem, 12 * fem),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24 * ffem,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1c0c11),
                    ),
                  ),
                ),
                Container(
                  height: 320,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 240 * fem,
                        padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 0 * fem, 0 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 12 * fem),
                              width: 240 * fem,
                              height: 240 * fem,
                              child: categories[index]['type'] == 'image'
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(12 * fem),
                                child: Image.asset(
                                  categories[index]['source'],
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : categories[index]['type'] == 'video' && categories[index]['source'] != null
                                  ? AspectRatio(
                                aspectRatio: 1.0,
                                child: VideoPlayerWidget(
                                  videoSource: categories[index]['source']!,
                                ),
                              )
                                  : SizedBox(), // Placeholder for cases where 'type' is not 'image' or 'video' or 'source' is null
                            ),
                            Text(
                              categories[index]['name'],
                              style: TextStyle(
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff1c0c11),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Featured Artists List
                Container(
                  padding: EdgeInsets.fromLTRB(15 * fem, 22 * fem, 0 * fem, 12 * fem),
                  child: Text(
                    'Featured Artists',
                    style: TextStyle(
                      fontSize: 24 * ffem,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1c0c11),
                    ),
                  ),
                ),
                Container(
                  height: 350, // Set a specific height for the Container
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredArtists.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 0 * fem),
                        width: 179 * fem,
                        padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 0 * fem, 10 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // Get the id of the selected artist
                                String id = featuredArtists[index]['id'].toString(); // Convert id to String

                                // Store the id in shared preferences
                                await storage.write(key: 'id', value: id);

                                // Navigate to the ArtistProfile screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArtistProfile(),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12 * fem),
                                width: 160 * fem,
                                height: 213 * fem,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                  child: Image.network(
                                    featuredArtists[index]['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              featuredArtists[index]['name'],
                              style: TextStyle(
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff1c0c11),
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  ' ${featuredArtists[index]['skill']}',
                                  style: TextStyle(
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff1c0c11),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Text(
                                    ' ${featuredArtists[index]['rating']}/5',
                                    style: TextStyle(
                                      fontSize: 16 * ffem,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff1c0c11),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15 * fem, 0 * fem, 0 * fem, 12 * fem),
                  child: Text(
                    'Recommended',
                    style: TextStyle(
                      fontSize: 24 * ffem,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1c0c11),
                    ),
                  ),
                ),
                Container(
                  height: 320, // Set a specific height for the Container
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seasonal.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 240 * fem,
                        padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 0 * fem, 16 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 12 * fem),
                              width: 240 * fem,
                              height: 240 * fem,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12 * fem),
                                child: Image.asset(
                                  seasonal[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              seasonal[index]['name'],
                              style: TextStyle(
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff1c0c11),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15 * fem, 30 * fem, 0 * fem, 12 * fem),
                  child: Text(
                    'Best Teams',
                    style: TextStyle(
                      fontSize: 24 * ffem,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1c0c11),
                    ),
                  ),
                ),
                Container(
                  height: 350, // Set a specific height for the Container
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bestArtists.length,
                    itemBuilder: (context, index) {
                      final artist = bestArtists[index];
                      if (artist == null) {
                        return SizedBox(); // Return an empty SizedBox if the artist is null
                      }
                      return Container(
                        margin: EdgeInsets.only(right: 0 * fem),
                        width: 179 * fem,
                        padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 0 * fem, 16 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String id = artist['id'];
                                // Write the id to storage
                                await  storage.write(key: 'id', value: id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeamProfile(),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12 * fem),
                                width: 160 * fem,
                                height: 213 * fem,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                  child: Image.network(
                                    artist['image'] ?? '',
                                    // Provide a default value if image is null
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              artist['name'] ?? '',
                              // Provide a default value if name is null
                              style: TextStyle(
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff1c0c11),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  artist['skill'] ?? '',
                                  // Provide a default value if skill is null
                                  style: TextStyle(
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff1c0c11),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Text(
                                    '${artist['rating'] ?? '4.3'}/5',
                                    // Provide a default value if rating is null
                                    style: TextStyle(
                                      fontSize: 16 * ffem,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff1c0c11),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoSource;

  const VideoPlayerWidget({Key? key, required this.videoSource}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.asset(widget.videoSource);
    print(_controller);
    _controller.addListener(() {
      if (!_controller.value.isPlaying && !_controller.value.isBuffering) {
        throw VideoPlayerFailedToPlayException('Video failed to play');
      }
    });
    _controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class VideoPlayerFailedToPlayException implements Exception {
  final String message;

  VideoPlayerFailedToPlayException(this.message);

  @override
  String toString() {
    return 'VideoPlayerFailedToPlayException: $message';
  }
}
