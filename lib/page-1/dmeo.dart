import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/artist_showcase.dart';
import 'package:test1/page-1/team_showcase.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import '../config.dart';



class Home_user extends StatefulWidget {
  @override
  _Home_userState createState() => _Home_userState();
}

class _Home_userState extends State<Home_user> {
  final storage = FlutterSecureStorage();

  // Dummy data for testing. Replace it with actual data from your backend.
  final List<Map<String, dynamic>> categories = [

  ];

  final List<Map<String, dynamic>> featuredArtists = [
    // Add more data as needed
  ];

  final List<Map<String, dynamic>> bestArtists = [];

  @override
  void initState() {
    super.initState();
    fetchFeaturedArtists();
    // fetchFeaturedTeams();
    // fetchAssets();
  }

  Future<void> fetchFeaturedArtists() async {
// <<<<<<< HEAD
//     for (int index = 0; index < categories.length; index++) {
//       String? source = categories[index]['source'] as String?;
//       if (source != null) {
//         print('Source at index $index: $source');
//       } else {
//         print('Source at index $index is null');
//       }
// =======
    Future<String?> _getLatitude() async {
      return await storage.read(key: 'latitude'); // Assuming you stored the token with key 'token'
    }
    Future<String?> _getLongitude() async {
      return await storage.read(key: 'longitude'); // Assuming you stored the token with key 'token'
// >>>>>>> 7351e5c0eb3d956ca9c6894a0710f105a9f2df77
    }

    String? latitude = await _getLatitude();
    String? longitude = await _getLongitude();


    try {
// <<<<<<< HEAD
//       String apiUrl = 'http://127.0.0.1:8000/api/home/featured';
// =======
      String apiUrl = '${Config().apiDomain}/home/featured?lat=$latitude&lng=$longitude';
      // Make the HTTP GET request
// >>>>>>> 7351e5c0eb3d956ca9c6894a0710f105a9f2df77
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          featuredArtists.clear();


          for (var item in data) {
            featuredArtists.add({
              'id': item['id'],
              'name': item['name'],

              'image': '${Config().baseDomain}/storage/${item['profile_photo']}',
              // 'rating': item['rating'].toString(),

              'skill': item['skills'],
            });
          }
        });

        print(featuredArtists);
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
                'image': '${Config().baseDomain}/storage/${item['item_data']}',
              });
            }
          } else if (section['section_name'] == 'Categories') {


            for (var item in section['items']) {
              categories.add({
                // 'id': item['item_id'],
                'name': item['item_name'],
                'type': 'image',
                'image': '${Config().baseDomain}/storage/${item['item_data']}',
              });
            }
            }
            else if (section['section_name'] == 'Seasonal') {
            seasonal.add({
              'section_name':section['section_name'],
            });
              for (var item in section['items']) {
                seasonal.add({
                  // 'id': item['item_id'],
                  'name': item['item_name'],
                  // 'type': 'image',
                  'image': '${Config().baseDomain}/storage/${item['item_data']}',
                });
              }
          }
        }


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

      String apiUrl = '${Config().apiDomain}/home/featured/team';
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

        setState(() {
          bestArtists.clear();
          // String baseUrl = 'http://192.0.0.2:8000/storage/';

          for (var item in data) {
            if (item != null) {
              String? name = item['team_name'];
              String? profilePhoto = item['profile_photo'];
              String? skills = item['skill_category'];

              if (name != null && profilePhoto != null && item['id'] != null) {
                String id = item['id'].toString();
                bestArtists.add({
                  'id': id,
                  'name': name,
                  'image': '${Config().baseDomain}/storage/$profilePhoto',
                  'skill': skills,
                });
              }
            }
          }
        });

        print(bestArtists);
      } else {
        print('Failed to load data: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  final List<Map<String, dynamic>> seasonal = [
    // {
    //   'name': 'Alpin Band',
    //   'image': 'assets/page-1/images/2d51a82294e0fd051de11eaa0b0c0678.jpg'
    // },
    // {
    //   'name': 'Tech House',
    //   'image': 'assets/page-1/images/Oxygen-Band-1024x768.jpg'
    // },
    // {
    //   'name': 'Trance',
    //   'image': 'assets/page-1/images/music-of-dhwani-1.jpg'
    // },
  ];

  final List<Map<String, dynamic>> recommended = [
    // {
    //   'subheading': 'Feel the Air',
    //   'name':'Infuse your gathering with the vocals of a premier singer.',
    //   'type': 'image',
    //   'url': 'assets/page-1/images/music-of-dhwani-1.jpg'
    // },
    // {
    // 'subheading': 'Let the aroma flow',
    // 'name': 'Treat your elite guests to culinary perfection.',
    // 'type': 'video',
    // 'url': 'assets/videos/df4a85b2902ddaa7e688b63d4d1c60ba.mp4'
    //
    // },
    // {
    //   'subheading': 'Magical touch',
    //   'name': 'Make your little one’s birthday magical.',
    //   'type': 'image',
    //   'url': 'assets/page-1/images/Oxygen-Band-1024x768.jpg'
    //
    // },
  ];

  final List<Map<String, dynamic>> best = [
    {
      'subheading': 'Feel the Air',
      'name':'Infuse your gathering with the vocals of a premier singer.',
      'type': 'image',
      'url': 'assets/page-1/images/2d51a82294e0fd051de11eaa0b0c0678.jpg'
    },
    {
      'subheading': 'Let the aroma flow',
      'name': 'Treat your elite guests to culinary perfection.',
      'type': 'video',
      'url': 'assets/videos/df4a85b2902ddaa7e688b63d4d1c60ba.mp4'

    },
    {
      'subheading': 'Magical touch',
      'name': 'Make your little one’s birthday magical.',
      'type': 'image',
      'url': 'assets/page-1/images/Oxygen-Band-1024x768.jpg'

    },
  ];

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Text(
            'Home',
            style: TextStyle(
              fontSize: 18 * fem,
              fontWeight: FontWeight.w600,
              color: Colors.white,
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
              // Once the data is fetched, build your UI
              // var data = snapshot.data;
              // if (data == null || data.isEmpty) {
              //   return Center(
              //     child: Text('No data found'), // Display no data found message
              //   );
              // }
              // print(data);
              return Container(
                color: Color(0xFF121217),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(15 * fem, 10 * fem,
                              0 * fem, 18 * fem),
                          child: Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 18 * ffem,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 2.0,
                          ),
                          itemCount: categories?.length,
                          itemBuilder: (context, index) {
                            final category = categories?[index];
                            return Container(
                              height: 83.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                              ),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  margin: EdgeInsets.all(16),
                                  child: Text(
                                    category['name'],
                                    style: GoogleFonts.getFont(
                                      'Be Vietnam Pro',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      height: 1.3,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(12 * fem, 50 * fem,
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
                                width: 305 * fem,
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
                                            : VideoWidget(
                                            url: recommended?[index]['image']),
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
                          padding: EdgeInsets.fromLTRB(15 * fem, 38 * fem,
                              0 * fem, 0 * fem),
                          child: Text(
                            'Featured Artists',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 340,
                          // Set a specific height for the Container
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: featuredArtists.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 0 * fem),
                                width: 160 * fem,
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

                                        // Navigate to the ArtistProfile screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ArtistProfile(
                                                  artist_id: id.toString(),),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 12 * fem),
                                        width: 160 * fem,
                                        height: 213 * fem,
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
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5 * ffem / fem,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Text(
                                          ' ${featuredArtists[index]['skill']}',
                                          style: TextStyle(
                                            fontSize: 14 * ffem,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF9E9EB8),
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 16, 0),
                                          child: Text(
                                            ' ${featuredArtists[index]['rating']}/5',
                                            style: TextStyle(
                                              fontSize: 14 * ffem,
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
                          padding: EdgeInsets.fromLTRB(15 * fem, 0 * fem,
                              0 * fem, 0 * fem),
                          child: Text(
                            'Seasonal',
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
                                width: 160 * fem,
                                padding: EdgeInsets.fromLTRB(
                                    12 * fem, 16 * fem, 0 * fem, 0 * fem),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 12 * fem),
                                      width: 160 * fem,
                                      height: 213 * fem,
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
                          padding: EdgeInsets.fromLTRB(25 * fem, 0 * fem,
                              25 * fem, 18 * fem),
                          child: Text(
                            'Best Teams',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 495,
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: PageView.builder(
                            controller: PageController(viewportFraction: 0.99),
                            // Set viewport fraction for partial visibility of side images
                            scrollDirection: Axis.horizontal,
                            itemCount: best.length,
                            itemBuilder: (context, index) {
                              final artist = best[index];
                              if (artist == null) {
                                return SizedBox(); // Return an empty SizedBox if the artist is null
                              }
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 6 * fem),
                                // Add margin for spacing between items
                                child: GestureDetector(
                                  onTap: () async {
                                    String team_id = artist['id'];

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TeamProfile(),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 330 * fem,
                                        // Set the desired width for the image container
                                        height: 495 * fem,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              12 * fem),
                                          child: Image.network(
                                            artist['image'] ?? '',
                                            // Provide a default value if image is null
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 30 * fem,
                                        left: 16 * fem,
                                        right: 34 * fem,
                                        child: Text(
                                          artist['name'] ?? '',
                                          // Provide a default value if name is null
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
                                ),
                              );
                            },
                          ),
                        ),


                        Container(
                          padding: EdgeInsets.fromLTRB(15 * fem, 40 * fem,
                              0 * fem, 0 * fem),
                          child: Text(
                            'Seasonal',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 310 * fem,
                          // Set a specific height for the Container

                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: seasonal?.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 160 * fem,
                                padding: EdgeInsets.fromLTRB(
                                    12 * fem, 16 * fem, 0 * fem, 0 * fem),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 12 * fem),
                                      width: 160 * fem,
                                      height: 213 * fem,
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
                          padding: EdgeInsets.fromLTRB(15 * fem, 0 * fem,
                              0 * fem, 0 * fem),
                          child: Text(
                            'Seasonal',
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
                                width: 160 * fem,
                                padding: EdgeInsets.fromLTRB(
                                    12 * fem, 16 * fem, 0 * fem, 0 * fem),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 12 * fem),
                                      width: 160 * fem,
                                      height: 213 * fem,
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
                          padding: EdgeInsets.fromLTRB(25 * fem, 0 * fem,
                              0 * fem, 18 * fem),
                          child: Text(
                            'Best Teams',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 495,
                          // Set a specific height for the Container
                          child: PageView.builder(
                            controller: PageController(viewportFraction: 0.87),
                            // Set viewport fraction for partial visibility of side images
                            scrollDirection: Axis.horizontal,
                            itemCount: best.length,
                            itemBuilder: (context, index) {
                              final artist = best[index];
                              if (artist == null) {
                                return SizedBox(); // Return an empty SizedBox if the artist is null
                              }
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 6 * fem),
                                // Add margin for spacing between items
                                child: GestureDetector(
                                  onTap: () async {
                                    String bestTeam_id = artist['id'];

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TeamProfile(),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 350 * fem,
                                        // Set the desired width for the image container
                                        height: 495 * fem,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              12 * fem),
                                          child: Image.network(
                                            artist['image'] ?? '',
                                            // Provide a default value if image is null
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 30 * fem,
                                        left: 16 * fem,
                                        right: 24 * fem,
                                        child: Text(
                                          artist['name'] ?? '',
                                          // Provide a default value if name is null
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
                                ),
                              );
                            },
                          ),
                        ),
                        Container(padding: EdgeInsets.fromLTRB(0, 80, 0, 80),
                          child:
                          Center(
                            child: Text('HomeStage',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 38
                              ),),
                          ),
                        )
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


class VideoWidget extends StatefulWidget {
  final String url;

  VideoWidget({required this.url});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

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
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url)); // Use network instead of asset
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
      _controller.setLooping(true);
      _controller.setVolume(0.0); // Mute the video
      _controller.play();
    } catch (e) {
      print("Error initializing video: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Center(child: CircularProgressIndicator());
  }
}

