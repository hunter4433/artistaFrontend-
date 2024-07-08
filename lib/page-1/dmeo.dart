import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/artist_showcase.dart';
import 'package:test1/page-1/team_showcase.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
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
      'type': 'image',
      'source': 'assets/page-1/images/50ae5f0488eec597224d33e1c944b203.jpg'
    },
    {
      'name': 'Chef',
      'type': 'image',
      'source': 'assets/page-1/images/a348ad2eb041aba8f0fe461e5023b0cb.jpg'
    },
    {
      'name': 'Magician',
      'type': 'image',
      'source': 'assets/page-1/images/2715fd5e2b75cf7ac53ba44d6abc4124.jpg'
    },
    // Add more data as needed
  ];

  final List<Map<String, dynamic>> featuredArtists = [
    // Add more data as needed
  ];

  final List<Map<String, dynamic>> bestArtists = [];

  @override
  void initState() {
    super.initState();
    fetchFeaturedArtists();
    fetchFeaturedTeams();
  }

  Future<void> fetchFeaturedArtists() async {
    for (int index = 0; index < categories.length; index++) {
      String? source = categories[index]['source'] as String?;
      if (source != null) {
        print('Source at index $index: $source');
      } else {
        print('Source at index $index is null');
      }
    }

    try {
      String apiUrl = 'http://127.0.0.1:8000/api/home/featured';
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
          String baseUrl = 'http://127.0.0.1:8000/storage/';

          for (var item in data) {
            featuredArtists.add({
              'id': item['id'],
              'name': item['name'],
              'image': 'http://127.0.0.1:8000/storage/${item['profile_photo']}',
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

  Future<void> fetchFeaturedTeams() async {
    try {
      String apiUrl = 'http://127.0.0.1:8000/api/home/featured/team';
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
          String baseUrl = 'http://127.0.0.1:8000/storage/';

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
                  'image': 'http://127.0.0.1:8000/storage/$profilePhoto',
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
    {
      'name': 'Alpin Band',
      'image': 'assets/page-1/images/2d51a82294e0fd051de11eaa0b0c0678.jpg'
    },
    {
      'name': 'Tech House',
      'image': 'assets/page-1/images/Oxygen-Band-1024x768.jpg'
    },
    {
      'name': 'Trance',
      'image': 'assets/page-1/images/music-of-dhwani-1.jpg'
    },
  ];

  final List<Map<String, dynamic>> recommended = [
    {
      'subheading': 'Feel the Air',
      'name':'Infuse your gathering with the vocals of a premier singer.',
      'type': 'image',
      'url': 'assets/page-1/images/music-of-dhwani-1.jpg'
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
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Text(
            'Home',
            style: TextStyle(fontSize: 18*fem,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color(0xFF121217)
        ,
        // You can change the app bar background color if needed
        // You can change the app bar text color if needed
      ),
      body:


      Container(
        color: Color(0xFF121217),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15 * fem, 10 * fem, 0 * fem, 18 * fem),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18 * ffem,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container( margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      height: 83.0, // Specify the exact height to match the first container
                      width: 180.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment(0, 1),
                            end: Alignment(0, -1),
                            colors: <Color>[
                              Color(0x66000000),
                              Color(0x00000000),
                              Color(0x1A000000),
                              Color(0x00000000)
                            ],
                            stops: <double>[0, 1, 1, 1],
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/page-1/images/3bca549aee2c634c84076c3a1f5944d9 2.jpg'),
                          ),
                        ),
                        height: 97.3,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: EdgeInsets.all(16),
                            child: Text(
                              'Musician',
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
                      ),
                    ),
                    Container( margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      height: 83.0, // Specify the exact height to match the first container
                      width: 180.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment(0, 1),
                          end: Alignment(0, -1),
                          colors: <Color>[
                            Color(0x66000000),
                            Color(0x00000000),
                            Color(0x1A000000),
                            Color(0x00000000)
                          ],
                          stops: <double>[0, 1, 1, 1],
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/page-1/images/2311a65bd19841a7b43287a3bceb3ba7.jpg'),
                        ),
                      ),

                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.all(16),
                          child: Text(
                            'Chef',
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
                    ),
                  ],
                ),
                SizedBox(height: 11.7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container( margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      height: 83.0, // Specify the exact height to match the first container
                      width: 180.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment(0, 1),
                            end: Alignment(0, -1),
                            colors: <Color>[
                              Color(0x66000000),
                              Color(0x00000000),
                              Color(0x1A000000),
                              Color(0x00000000)
                            ],
                            stops: <double>[0, 1, 1, 1],
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/page-1/images/d8571702a0022c1c6eb3797303031b36.jpg'),
                          ),
                        ),
                        height: 97.3,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: EdgeInsets.all(16),
                            child: Text(
                              'Comedian',
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
                      ),
                    ),
                    Container( margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      height: 83.0, // Specify the exact height to match the first container
                      width: 180.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment(0, 1),
                          end: Alignment(0, -1),
                          colors: <Color>[
                            Color(0x66000000),
                            Color(0x00000000),
                            Color(0x1A000000),
                            Color(0x00000000)
                          ],
                          stops: <double>[0, 1, 1, 1],
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/page-1/images/3e713ef0834aece14d6d0a9e76012120.jpg'),
                        ),
                      ),

                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.all(16),
                          child: Text(
                            'Dancer',
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
                    ),
                  ],
                ),
          SizedBox(height: 11.7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container( margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 83.0, // Specify the exact height to match the first container
                width: 180.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment(0, 1),
                      end: Alignment(0, -1),
                      colors: <Color>[
                        Color(0x66000000),
                        Color(0x00000000),
                        Color(0x1A000000),
                        Color(0x00000000)
                      ],
                      stops: <double>[0, 1, 1, 1],
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/page-1/images/afa961efda24e49580cfe2cc7af69508.jpg'),
                    ),
                  ),
                  height: 97.3,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Text(
                        'Singer',
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
                ),
              ),],),

                Container(
                  padding: EdgeInsets.fromLTRB(12 * fem, 50 * fem, 0 * fem, 0 * fem),
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
                    itemCount: recommended.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 305 * fem,
                        padding: EdgeInsets.fromLTRB(12 * fem, 16 * fem, 0 * fem, 16 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 12 * fem),
                              width: 305 * fem,
                              height: 313 * fem,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8 * fem),
                                child: recommended[index]['type'] == 'image'
                                    ? Image.asset(
                                  recommended[index]['url'],
                                  fit: BoxFit.cover,
                                )
                                    : VideoWidget(url: recommended[index]['url']),
                              ),
                            ),
                            Text(
                              recommended[index]['subheading'],
                              style: TextStyle(
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5 * ffem / fem,
                                color: Color(0xFF9E9EB8),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 260 * fem, // Set the desired width here
                              child: Text(
                                recommended[index]['name'],
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
                  padding: EdgeInsets.fromLTRB(15 * fem, 38 * fem, 0 * fem, 0 * fem),
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
                  height: 340, // Set a specific height for the Container
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredArtists.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 0 * fem),
                        width: 160 * fem,
                        padding: EdgeInsets.fromLTRB(12 * fem, 16 * fem, 0 * fem, 10 * fem),
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
                                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
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
                  padding: EdgeInsets.fromLTRB(15 * fem, 0 * fem, 0 * fem, 0 * fem),
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
                  height: 330*fem, // Set a specific height for the Container

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seasonal.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 160 * fem,
                        padding: EdgeInsets.fromLTRB(12 * fem, 16 * fem, 0 * fem, 0 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 12 * fem),
                              width: 160 * fem,
                              height: 213 * fem,
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
                  padding: EdgeInsets.fromLTRB(25 * fem, 0 * fem, 25 * fem, 18 * fem),
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
                    controller: PageController(viewportFraction: 0.99), // Set viewport fraction for partial visibility of side images
                    scrollDirection: Axis.horizontal,
                    itemCount: best.length,
                    itemBuilder: (context, index) {
                      final artist = best[index];
                      if (artist == null) {
                        return SizedBox(); // Return an empty SizedBox if the artist is null
                      }
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 6 * fem), // Add margin for spacing between items
                        child: GestureDetector(
                          onTap: () async {
                            String id = artist['id'];
                            // Write the id to storage
                            await storage.write(key: 'id', value: id);
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
                                width: 330 * fem, // Set the desired width for the image container
                                height: 495 * fem,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12 * fem),
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
                  padding: EdgeInsets.fromLTRB(15 * fem, 40 * fem, 0 * fem, 0 * fem),
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
                  height: 310*fem, // Set a specific height for the Container

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seasonal.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 160 * fem,
                        padding: EdgeInsets.fromLTRB(12 * fem, 16 * fem, 0 * fem, 0 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 12 * fem),
                              width: 160 * fem,
                              height: 213 * fem,
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
                  padding: EdgeInsets.fromLTRB(15 * fem, 0 * fem, 0 * fem, 0 * fem),
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
                  height: 330*fem, // Set a specific height for the Container

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seasonal.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 160 * fem,
                        padding: EdgeInsets.fromLTRB(12 * fem, 16 * fem, 0 * fem, 0 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 12 * fem),
                              width: 160 * fem,
                              height: 213 * fem,
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
                  padding: EdgeInsets.fromLTRB(25 * fem, 0 * fem, 0 * fem, 18 * fem),
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
                  height: 495, // Set a specific height for the Container
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.87), // Set viewport fraction for partial visibility of side images
                    scrollDirection: Axis.horizontal,
                    itemCount: best.length,
                    itemBuilder: (context, index) {
                      final artist = best[index];
                      if (artist == null) {
                        return SizedBox(); // Return an empty SizedBox if the artist is null
                      }
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 6 * fem), // Add margin for spacing between items
                        child: GestureDetector(
                          onTap: () async {
                            String id = artist['id'];
                            // Write the id to storage
                            await storage.write(key: 'id', value: id);
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
                                width: 350 * fem, // Set the desired width for the image container
                                height: 495 * fem,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12 * fem),
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
                      color:Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 38
                    ),),
                  ),
                )
              ],
            ),
          ),
        ),
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

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.url);
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
      _controller.setLooping(true);
      _controller.play();
    } catch (e) {
      print("Error initializing video: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
