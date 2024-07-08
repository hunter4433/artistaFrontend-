import 'package:flutter/material.dart';
import '../utils.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchedArtist extends StatelessWidget {
  final List<Map<String, dynamic>> filteredArtistData;

  SearchedArtist({required this.filteredArtistData});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        title: Text(
           'Artists',
          style: TextStyle(color: Colors.white, fontSize: 23,
              fontWeight: FontWeight.w400),

        ),
        backgroundColor: Color(0xFF121217),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: filteredArtistData.isNotEmpty
            ? Container(
          width: double.infinity,
          child: ListView.builder(
            itemCount: filteredArtistData.length,
            itemBuilder: (context, index) {
              return Card(
                color: Color(0xFF292938),
                margin: EdgeInsets.symmetric(vertical: 16 * fem, horizontal: 16 * fem),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14 * fem),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(0 * fem),
                      height: 300.66 * fem,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12 * fem)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12 * fem),
                          topRight: Radius.circular(12 * fem),
                        ),
                        child: Image.asset(
                          filteredArtistData[index]['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16 * fem),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredArtistData[index]['name'],
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 22 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.25 * ffem / fem,
                                  letterSpacing: -0.33 * fem,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8 * fem),
                              Row(
                                children: [
                                  Text(
                                    'Skill: ${filteredArtistData[index]['skill']}',
                                    style: SafeGoogleFont(
                                      'Be Vietnam Pro',
                                      fontSize: 17 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xFF9E9EB8),
                                    ),
                                  ),
                                  SizedBox(width: 96 * fem),
                                  Text(
                                    'Rating: ${filteredArtistData[index]['rating']}',
                                    style: SafeGoogleFont(
                                      'Be Vietnam Pro',
                                      fontSize: 17 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xFF9E9EB8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
            : Center(
          child: Text(
            "No artists found in your area. We're working hard to bring them soon!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20 * ffem,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SearchedArtist(filteredArtistData: [
      {
        'image': 'assets/artist1.png',
        'name': 'Artist One',
        'skill': 'Magician',
        'rating': '4.5'
      },
      {
        'image': 'assets/artist2.png',
        'name': 'Artist Two',
        'skill': 'Juggler',
        'rating': '4.7'
      },
    ]),
  ));
}