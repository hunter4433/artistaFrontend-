import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/artist_showcase.dart';
import 'package:test1/page-1/booking_artis.dart';
import 'package:test1/page-1/team_showcase.dart';

class Home_user extends StatelessWidget {
  // Dummy data for testing. Replace it with actual data from your backend.
  final List<Map<String, dynamic>> categories = [
    {'name': 'Bass House', 'image': 'assets/page-1/images/depth-4-frame-0-3ZR.png'},
    {'name': 'Tech House', 'image': 'assets/page-1/images/depth-4-frame-0-CB1.png'},
    {'name': 'Trance', 'image': 'assets/page-1/images/depth-4-frame-0-Qt7.png'},
    // Add more data as needed
  ];

  final List<Map<String, dynamic>> featuredArtists = [
    {'name': 'John Doe', 'image': 'assets/page-1/images/depth-4-frame-0-3ZR.png', 'rating': '4.5', 'skill': 'Guitarist'},
    {'name': 'Jane Smith', 'image': 'assets/featured-artists/jane_smith.png', 'rating': '4.2', 'skill': 'Pianist'},
    {'name': 'Bob Johnson', 'image': 'assets/featured-artists/bob_johnson.png', 'rating': '4.7', 'skill': 'Singer'},
    // Add more data as needed
  ];

  final List<Map<String, dynamic>> seasonal = [
    {'name': 'Bass House', 'image': 'assets/page-1/images/depth-4-frame-0-3ZR.png'},
    {'name': 'Tech House', 'image': 'assets/page-1/images/depth-4-frame-0-CB1.png'},
    {'name': 'Trance', 'image': 'assets/page-1/images/depth-4-frame-0-Qt7.png'},
    // Add more data as needed
  ];

  final List<Map<String, dynamic>> bestArtists = [
    {'name': 'Abhishek', 'image': 'assets/page-1/images/depth-4-frame-0-3ZR.png', 'rating': '4.5', 'skill': 'Guitarist'},
    {'name': 'Rohit', 'image': 'assets/featured-artists/jane_smith.png', 'rating': '4.2', 'skill': 'Pianist'},
    {'name': 'Mohit Johnson', 'image': 'assets/featured-artists/bob_johnson.png', 'rating': '4.7', 'skill': 'Singer'},
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
          padding: const EdgeInsets.fromLTRB(0,0,8,0),
          child: Text('Artista', style: TextStyle(fontWeight: FontWeight.w600,color: Color(0xff1c0c11)),),
        ),
        backgroundColor: Colors.white, // You can change the app bar background color if needed
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
                  padding: EdgeInsets.fromLTRB(15*fem ,10 * fem,0 *fem ,12*fem),
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
                  height: 320, // Set a specific height for the Container
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
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
                                  categories[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                  padding: EdgeInsets.fromLTRB(15*fem ,30 * fem,0 *fem ,12*fem),
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
                      return Container(margin: EdgeInsets.only(right: 14 * fem),
                        width: 190 * fem,
                        padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 0 * fem, 10 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap:() {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                artist_profile(),

                                ));

                                       },


                              child: Container(
                                margin: EdgeInsets.only(bottom: 12 * fem),
                                width: 190 * fem,
                                height: 220 * fem,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                  child: Image.asset(
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
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  ' ${featuredArtists[index]['skill']}',
                                  style: TextStyle(
                                    fontSize: 16 * ffem,
                                    fontWeight:FontWeight.w500,
                                    color: Color(0xff1c0c11),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                  child: Text(
                                    ' ${featuredArtists[index]['rating']}/5',
                                    style: TextStyle(
                                      fontSize: 16 * ffem,
                                      fontWeight:FontWeight.w500,
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
                  padding: EdgeInsets.fromLTRB(15*fem ,15 * fem,0 *fem ,12*fem),
                  child: Text(
                    'Seasonal',
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
                  padding: EdgeInsets.fromLTRB(15*fem ,30 * fem,0 *fem ,12*fem),
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
                      return Container(margin: EdgeInsets.only(right: 14 * fem),
                        width: 190 * fem,
                        padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 0 * fem, 16 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap:() {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                   team_profile(),

                                ));

                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12 * fem),
                                width: 190 * fem,
                                height: 220 * fem,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                  child: Image.asset(
                                    bestArtists[index]['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              bestArtists[index]['name'],
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
                                  ' ${bestArtists[index]['skill']}',
                                  style: TextStyle(
                                    fontSize: 16 * ffem,
                                    fontWeight:FontWeight.w500,
                                    color: Color(0xff1c0c11),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                  child: Text(
                                    ' ${bestArtists[index]['rating']}/5',
                                    style: TextStyle(
                                      fontSize: 16 * ffem,
                                      fontWeight:FontWeight.w500,
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
