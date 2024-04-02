import 'package:flutter/material.dart';
import '../utils.dart';
import 'package:google_fonts/google_fonts.dart';

class Searched_artist extends StatelessWidget {
  // Dummy data for testing. Replace it with actual data from your backend.
  final List<Map<String, dynamic>> artistData = [
    {'name': 'Sophia', 'skill': 'Classical Piano', 'rating': 4.5, 'image': 'assets/page-1/images/depth-3-frame-0-4tP.png'},
    {'name': 'Sophia', 'skill': 'Classical Piano', 'rating': 4.5, 'image': 'assets/page-1/images/depth-3-frame-0-4tP.png'},
    {'name': 'Sophia', 'skill': 'Classical Piano', 'rating': 4.5, 'image': 'assets/page-1/images/depth-3-frame-0-4tP.png'},

  ];

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: Text('Artista'),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: ListView.builder(
            itemCount: artistData.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 16 * fem, 8 * fem),
                    width: double.infinity,
                    height: 270.66 * fem,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(12 * fem),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 358 * fem,
                          height: 238.66 * fem,
                          child: Image.asset(
                            artistData[index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16 * fem, 8 * fem, 26 * fem, 34 * fem),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 8 * fem),
                              child: Text(
                                artistData[index]['name'],
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 22 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25 * ffem / fem,
                                  letterSpacing: -0.33 * fem,
                                  color: Color(0xff1c0c11),
                                ),
                              ),
                            ),
                            Text(
                              'Skill: ${artistData[index]['skill']}',
                              style: SafeGoogleFont(
                                'Be Vietnam Pro',
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff1c0c11),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Rating: ',
                              style: SafeGoogleFont(
                                'Be Vietnam Pro',
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff1c0c11),
                              ),
                            ),
                            Text(
                              '${artistData[index]['rating']}',
                              style: SafeGoogleFont(
                                'Be Vietnam Pro',
                                fontSize: 17 * ffem,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
