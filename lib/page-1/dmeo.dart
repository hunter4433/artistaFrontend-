import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/artist_showcase.dart';
import 'package:test1/page-1/searched_artist.dart';
import 'package:test1/page-1/team_showcase.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import '../config.dart';
import 'package:visibility_detector/visibility_detector.dart';



class Home_user extends StatefulWidget {
  @override
  _Home_userState createState() => _Home_userState();
}

class _Home_userState extends State<Home_user> {
  final storage = FlutterSecureStorage();
  late VideoPlayerController _controller;

  // Dummy data for testing. Replace it with actual data from your backend.
  final List<Map<String, dynamic>> categories = [

  ];

  final List<Map<String, dynamic>> featuredArtists = [
    // Add more data as needed
  ];

  final List<Map<String, dynamic>> bestArtists = [
    {

      'name':'Infuse your gathering with the singer.',
      'type': 'video',
      'url': 'assets/page-1/images/newmarraige.mov'
    },
    {
      'name': 'Treat your elite guests to culinary perfection.',
      'type': 'video',
      'url': 'assets/page-1/images/homestage2.mov'

    },
    {
      'name': 'Make your little one’s birthday magical.',
      'type': 'video',
      'url': 'assets/page-1/images/mehandi.mov'

    },
  ];

  @override
  void initState() {
    super.initState();
    fetchFeaturedArtists();

    // fetchFeaturedTeams();
    // fetchAssets();
  }


  // Future<Map<String, dynamic>> fetchCombinedData() async {
  //   // Call both fetchAssets and fetchFeaturedArtists in parallel
  //   final responses = await Future.wait([fetchAssets(), fetchFeaturedArtists()]);
  //
  //   // Combine the results into a single map
  //   return {
  //     'assets': responses[0], // The result of fetchAssets
  //     // 'featuredArtists': responses[1], // The result of fetchFeaturedArtists
  //   };
  // }

  Future<void> fetchFeaturedArtists() async {

    Future<String?> _getLatitude() async {
      return await storage.read(key: 'latitude'); // Assuming you stored the token with key 'token'
    }
    Future<String?> _getLongitude() async {
      return await storage.read(key: 'longitude');
    }

    String? latitude = await _getLatitude();
    String? longitude = await _getLongitude();


    try {
      String apiUrl = '${Config().apiDomain}/home/featured?lat=$latitude&lng=$longitude';

      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
// print(data);
        setState(() {
          featuredArtists.clear();


          for (var item in data) {
            featuredArtists.add({
              'id': item['id'],
              'name': item['name'],

              'image': '${item['profile_photo']}',
              // 'rating': item['rating'].toString(),

              'skill': item['skills'],
            });
          }

        });

        fetchFeaturedTeams();

        // print('fetauredartist rae as follows:$featuredArtists');
      } else {
        print('Failed to load data: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  // final List<Map<String, dynamic>> categories = [];

  Future<Map<String, List<dynamic>>> fetchAssets() async {

    try {


      String apiUrl = '${Config().apiDomain}/sections';

      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // List<Map<String, String>> categories = [];
        // List<Map<String, String>> recommended = [];
        recommended.clear();
        categories.clear();
        seasonal.clear();

        for (var section in data) {
          if (section['section_name'] == 'Recommended') {

            for (var item in section['items']) {
              List<String> parts = item['item_name'].split('/');

              String subheading = parts.isNotEmpty ? parts[0].trim() : '';
              String name = parts.length > 1 ? parts[1].trim() : '';
              String type = parts.length > 2 ? parts[2].trim() : 'image';

              recommended.add({
                // 'id': item['item_id'],
                'subheading': subheading,
                'name': name,
                'type': type,
                'image': '${item['item_data']}',
              });
            }
          } else if (section['section_name'] == 'Categories') {


            for (var item in section['items']) {
              categories.add({
                // 'id': item['item_id'],
                'name': item['item_name'],
                'type': 'image',
                'image': '${item['item_data']}',
              });
            }
            }
            else if (section['section_name'] == 'Seasonal') {

              for (var item in section['items']) {
                seasonal.add({
                  // 'id': item['item_id'],
                  'name': item['item_name'],
                  // 'type': 'image',
                  'image': '${item['item_data']}',
                });

              }

          }

        }
        print('seasonal is very  coomon $seasonal');


        return {
          'categories': categories,
          'recommended': recommended,
          'seasonal':seasonal,
        };


      } else {
        print('Failed to load data: ${response.body}');
        return {};
      }
    } catch (error) {
      print('Error fetching data: $error');
      return {};
    }
  }



  Future<void> fetchFeaturedTeams() async {
    try {
      Future<String?> _getLatitude() async {
        return await storage.read(key: 'latitude'); // Assuming you stored the token with key 'token'
      }
      Future<String?> _getLongitude() async {
        return await storage.read(key: 'longitude'); // Assuming you stored the token with key 'token'
// >>>>>>> 7351e5c0eb3d956ca9c6894a0710f105a9f2df77
      }

      String? latitude = await _getLatitude();
      String? longitude = await _getLongitude();

      String apiUrl = '${Config().apiDomain}/home/featured/team?lat=$latitude&lng=$longitude';
      // Make the HTTP GET request

      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // print(data);
        setState(() {
          // featuredArtists.clear();


          for (var item in data) {
            featuredArtists.add({
              'id': item['id'],
              'name': item['team_name'],

              'image': '${item['profile_photo']}',
              // 'rating': item['rating'].toString(),

              'skill': item['skill_category'],
              'team': 'true',
            });
          }

        });


        // print('team artista are $featuredArtists');
      } else {
        print('Failed to load datasssssss: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  final List<Map<String, dynamic>> seasonal = [

  ];

  final List<Map<String, dynamic>> recommended = [

  ];

  final List<Map<String, dynamic>> best = [
    {

      'name':'Experience Unforgettable Entertainment for Your Grand Wedding',
      'type': 'video',
      'url': 'assets/page-1/images/newmarraige.mov'
    },
    {
      'name': 'Exclusive Haldi Entertainment to Complement Your Traditional Celebration',
      'type': 'video',
      'url': 'assets/page-1/images/homestage2.mov'

    },
    {

      'name': 'Enhance Your Mehndi Event with Exquisite Talent and Elegant Performances',
      'type': 'video',
      'url': 'assets/page-1/images/mehandi.mov'

    },
  ];

  Future<String?> _getLatitude() async {
    return await storage.read(key: 'latitude');
  }

  Future<String?> _getLongitude() async {
    return await storage.read(key: 'longitude');
  }

  Future<List<Map<String, dynamic>>> searchArtists(String searchTerm) async {
    String? latitude = await _getLatitude();
    String? longitude = await _getLongitude();

    final String apiUrl1 = '${Config().apiDomain}/artist/search';
    final String apiUrl2 = '${Config().apiDomain}/team/search'; // Second API endpoint

    final Uri uri1 = Uri.parse(apiUrl1).replace(queryParameters: {
      'skill': searchTerm,
      'lat': latitude,
      'lng': longitude,
    });

    final Uri uri2 = Uri.parse(apiUrl2).replace(queryParameters: {
      'skill': searchTerm, // Modify query parameters as needed for the second endpoint
      'lat': latitude,
      'lng': longitude,
    });

    try {
      // Call both API endpoints simultaneously
      final responses = await Future.wait([
        http.get(uri1, headers: {
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        }),
        http.get(uri2, headers: {
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        })
      ]);

      final response1 = responses[0];
      final response2 = responses[1];

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        // Parse both responses
        List<dynamic> data1 = jsonDecode(response1.body);
        List<dynamic> data2 = jsonDecode(response2.body);

        // Merge the data
        List<Map<String, dynamic>> mergedData = [
          ...List<Map<String, dynamic>>.from(data1.map((artist) {
            artist['profile_photo'] = artist['profile_photo'];
            artist['isTeam'] = 'false';
            return artist;
          })),
          ...List<Map<String, dynamic>>.from(data2.map((artist) {
            artist['profile_photo'] = artist['profile_photo'];
            artist['isTeam'] = 'true';
            return artist;
          })),
        ];
        print(mergedData);
        return mergedData;
      } else {
        print('Failed to load artists');
        print(response1.body);
        print(response2.body);
        return [];
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 8*fem, 0),
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
      body: FutureBuilder(
          future: fetchAssets(), // Replace with your actual API call
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(), // Display a loading indicator
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                    'Error: ${snapshot.error}'), // Display an error message
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              var categories = snapshot.data!['categories'];
              var recommended = snapshot.data!['recommended'];
              var seasonal = snapshot.data!['seasonal'];
              return Container(
                color: Color(0xFF121217),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(12 * fem, 10 * fem,
                              0 * fem, 18 * fem),
                          child: Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GridView.builder(
                          padding: EdgeInsets.fromLTRB(12 * fem, 0 * fem, 12 * fem, 30 * fem),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15.0*fem,
                            mainAxisSpacing: 15.0*fem,
                            childAspectRatio: 2.5*fem,
                          ),
                          itemCount: categories?.length,
                          itemBuilder: (context, index) {
                            final category = categories?[index];
// <<<<<<< HEAD

                            return GestureDetector(
                              onTap: () async {
                                List<Map<String, dynamic>> filteredData =
                                    await searchArtists(category['name']);
                                // Navigate to a new page on tap, passing the category data if needed
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchedArtist(filteredArtistData: filteredData),
                                  ),
                                );
                              },
                              child: Container(
                                height: 83.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment(0, 1),
                                    end: Alignment(0, -1),
                                    colors: <Color>[
                                      Color(0x66000000),
                                      Color(0x00000000),
                                      Color(0x1A000000),
                                      Color(0x00000000),
                                    ],
                                    stops: <double>[0, 1, 1, 1],
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(category['image']),
                                  ),
// =======
//                             return Container(
//                               height: 83.0*fem,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: LinearGradient(
//                                   begin: Alignment(0, 1),
//                                   end: Alignment(0, -1),
//                                   colors: <Color>[
//                                     Color(0x66000000),
//                                     Color(0x00000000),
//                                     Color(0x1A000000),
//                                     Color(0x00000000),
//                                   ],
//                                   stops: <double>[0, 1, 1, 1],
// >>>>>>> 7843d0fd9f9f56e19be3ee78285dd0192d2cb138
                                ),
// <<<<<<< HEAD
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    margin: EdgeInsets.all(16),
                                    child: Text(
                                      category['name'],
                                      style: GoogleFonts.getFont(
                                        'Be Vietnam Pro',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        height: 1.3,
                                        color: Color(0xFFFFFFFF),
                                      ),
// =======
//                                 image: DecorationImage(
//                                   fit: BoxFit.cover,
//                                   image: NetworkImage(category['image']),
//                                 ),
//                               ),
//                               child: Align(
//                                 alignment: Alignment.bottomLeft,
//                                 child: Container(
//                                   margin: EdgeInsets.all(16*fem),
//                                   child: Text(
//                                     category['name'],
//                                     style: GoogleFonts.getFont(
//                                       'Be Vietnam Pro',
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 16*fem,
//                                       height: 1.3,
//                                       color: Color(0xFFFFFFFF),
// >>>>>>> 9e3f3a1ad3317a5838219c59acad554d7748e289
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),



                        Stack(
                          children: [
                            // Background image with semi-transparent overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/page-1/images/bulbs.jpg'), // Replace with your background image path
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  color: Colors.black.withOpacity(0.7), // Semi-transparent overlay, adjust opacity here
                                ),
                              ),
                            ),

                            // Content stacked on top of the background and overlay
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(16 * fem, 50 * fem, 0 * fem, 18 * fem),
                                  alignment: Alignment.centerLeft,  // Align the text to the left
                                  child: Text(
                                    'Wedding Special',
                                    style: TextStyle(
                                      fontSize: 22 * ffem,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 575*fem,
                                  margin: EdgeInsets.zero,
                                  child: PageView.builder(
                                    controller: PageController(viewportFraction: 0.87),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: best.length,
                                    itemBuilder: (context, index) {
                                      final artist = best[index];
                                      if (artist == null) {
                                        return SizedBox(); // Return an empty SizedBox if the artist is null
                                      }
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 6*fem),
                                        child: GestureDetector(
                                          onTap: () async {
                                            String team_id = artist['id']; // Use artist ID if needed
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TeamProfile(),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              // Main image or video
                                              Container(
                                                width: 330*fem,
                                                height: 495*fem,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: artist['type'] == 'image'
                                                      ? Image.asset(
                                                    artist['url'] ?? '', // Image from assets
                                                    fit: BoxFit.cover,
                                                  )
                                                      : CustomVideoPlayer(
                                                    source: artist['url'] ?? '', // Video from assets
                                                    isAsset: true,
                                                  ),
                                                ),
                                              ),
                                              // Semi-transparent overlay on individual cards
                                              Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.1), // Adjust transparency for individual items
                                                    borderRadius: BorderRadius.circular(10*fem),
                                                  ),
                                                ),
                                              ),
                                              // Artist name text
                                              Positioned(
                                                bottom: 100*fem,
                                                left: 16*fem,
                                                right: 16*fem,
                                                child: Text(
                                                  artist['name'] ?? '',
                                                  style: TextStyle(
                                                    fontSize: 18*fem,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),






                        Container(
                          padding: EdgeInsets.fromLTRB(15 * fem, 38 * fem,
                              0 * fem, 0 * fem),
                          child: Text(
                            'Featured Talent',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 350*fem,
                          // Set a specific height for the Container
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: featuredArtists.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 0 * fem),
                                width: 180 * fem,
                                padding: EdgeInsets.fromLTRB(
                                    12 * fem, 16 * fem, 0 * fem, 10 * fem),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        // Get the id of the selected artist
                                        String id = featuredArtists[index]['id']
                                            .toString(); // Convert id to String
                                       String isteam= featuredArtists[index]['team'] ?? '';
                                       print('isteam $isteam');
                                        // Navigate to the ArtistProfile screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ArtistProfile(
                                                  artist_id: id.toString(), isteam : isteam ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 12 * fem),
                                        width: 175 * fem,
                                        height: 223 * fem,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              12 * fem),
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
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 3*fem),
                                    Row(
                                      children: [
                                        Text(
                                          '${featuredArtists[index]['skill']}',
                                          style: TextStyle(
                                            fontSize: 16 * ffem,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF9E9EB8),
                                          ),
                                        ),
                                        Spacer(),

                                        Padding(
                                          padding:  EdgeInsets.fromLTRB(
                                              0, 0, 5*fem, 0),
                                          child: Text(
                                            ' ${featuredArtists[index]['rating']}/5',
                                            style: TextStyle(
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF9E9EB8),
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
                          padding: EdgeInsets.fromLTRB(12 * fem, 20 * fem,
                              0 * fem, 0 * fem),
                          child: Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 430 * fem,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommended?.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 300 * fem,
                                padding: EdgeInsets.fromLTRB(
                                    12 * fem, 16 * fem, 0 * fem, 16 * fem),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 12 * fem),
                                      width: 305 * fem,
                                      height: 313 * fem,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            8 * fem),
                                        child: recommended?[index]['type'] ==
                                            'image'
                                            ? Image.network(
                                          recommended?[index]['image'],
                                          fit: BoxFit.cover,
                                        )
                                            : CustomVideoPlayer(
                                            source: recommended?[index]['image'],
                                            isAsset: false ),
                                      ),
                                    ),
                                    Text(
                                      recommended?[index]['subheading'],
                                      style: TextStyle(
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xFF9E9EB8),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: 260 * fem,
                                      // Set the desired width here
                                      child: Text(
                                        recommended?[index]['name'],
                                        style: TextStyle(
                                          fontSize: 18 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.3625 * ffem / fem,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.fromLTRB(15 * fem, 40 * fem,
                              0 * fem, 0 * fem),
                          child: Text(
                            'Artists Around You',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 330 * fem,
                          // Set a specific height for the Container

                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: seasonal?.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 180 * fem,
                                padding: EdgeInsets.fromLTRB(
                                    12 * fem, 16 * fem, 0 * fem, 0 * fem),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 12 * fem),
                                      width: 175 * fem,
                                      height: 223 * fem,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            10 * fem),
                                        child: Image.network(
                                          seasonal?[index]['image'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      seasonal?[index]['name'],
                                      style: TextStyle(
                                        fontSize: 17 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15 * fem, 0 * fem,
                              0 * fem, 0 * fem),
                          child: Text(
                            'Best in Bands',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 330 * fem,
                          // Set a specific height for the Container

                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: seasonal?.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 180 * fem,
                                padding: EdgeInsets.fromLTRB(
                                    12 * fem, 16 * fem, 0 * fem, 0 * fem),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 12 * fem),
                                      width: 175 * fem,
                                      height: 223 * fem,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            12 * fem),
                                        child: Image.network(
                                          seasonal?[index]['image'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      seasonal?[index]['name'],
                                      style: TextStyle(
                                        fontSize: 17 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5 * ffem / fem,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),


                        Container(
                          height: 790*fem, // Full height for the container
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/page-1/images/party.jpg'), // Background image
                              fit: BoxFit.cover, // Adjust image to cover the container
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Semi-transparent overlay over the entire container
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7), // Control opacity here
                                  ),
                                ),
                              ),
                              // "Best Teams" title at the top
                              Positioned(
                                top: 65*fem, // Adjust top padding as needed
                                left: 25*fem, // Adjust left padding as needed
                                child: Text(
                                  'Best Teams',
                                  style: TextStyle(
                                    fontSize: 22 * ffem,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // PageView for videos or images
                              Positioned(
                                top: 110*fem, // Position this below the "Best Teams" title
                                left: 0,
                                right: 0,
                                child: Container(
                                  width: 330*fem,
                                  height: 495*fem,// Full height for PageView to match the container
                                  child: PageView.builder(
                                    controller: PageController(viewportFraction: 0.87),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: bestArtists.length,
                                    itemBuilder: (context, index) {
                                      final artist = bestArtists[index];
                                      if (artist == null) {
                                        return SizedBox(); // Return an empty SizedBox if the artist is null
                                      }
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 6),
                                        child: GestureDetector(
                                          onTap: () async {
                                            String team_id = artist['id']; // Use artist ID if needed
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TeamProfile(),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              // Main image or video
                                              Container(
                                                width: 330*fem,
                                                height: 495*fem,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: artist['type'] == 'image'
                                                      ? Image.asset(
                                                    artist['url'] ?? '', // Image from assets
                                                    fit: BoxFit.cover,
                                                  )
                                                      : CustomVideoPlayer(
                                                    source: artist['url'] ?? '', // Video from assets
                                                    isAsset: true,
                                                  ),
                                                ),
                                              ),
                                              // Semi-transparent overlay on each video/image
                                              Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.2), // Adjust transparency
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                              // Artist name text on each image/video
                                              Positioned(
                                                bottom: 30*fem, // Position near the bottom of each video/image
                                                left: 16*fem,
                                                right: 34*fem,
                                                child: Text(
                                                  artist['name'] ?? '',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // HomeStage text at the bottom
                              Positioned(
                                bottom: 60*fem, // Position the text 30 pixels from the bottom
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Text(
                                    'HOMESTAGE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 40*fem,
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
                ),
              );
            }
           else {
              return Center(
                child: Text('No data found'), // Handle empty data case
              );
            }
          }
      ),
    );
  }

}


// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String source;
  final bool isAsset; // Set to true for assets, false for URLs

  CustomVideoPlayer({required this.source, this.isAsset = false});

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = widget.isAsset
          ? VideoPlayerController.asset(widget.source)
          : VideoPlayerController.networkUrl(Uri.parse(widget.source));

      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
      _controller.setLooping(true);
    } catch (e) {
      print("Error initializing video: $e");
    }
  }

  void _playPauseVideo(bool visible) {
    if (visible && !_isPlaying) {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    } else if (!visible && _isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.source),
      onVisibilityChanged: (visibilityInfo) {
        // Play video only when more than 50% of it is visible
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        _playPauseVideo(visiblePercentage > 50);
      },
      child: _isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}