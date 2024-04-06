import 'package:flutter/material.dart';
import '../utils.dart';

class booked extends StatelessWidget {
  // Fetched text from backend
  final String dateText = 'Sat, Feb 5';
  final String timeText = '10:00 PM';
  final String durationText = '3 hours';
  final String priceText = '\$65.00 USD';
  final String locationText = 'Venue';



  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          height: 960*fem,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: Container(

            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration (
              color: Color(0xffffffff),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 16*fem, 29*fem),
                    width: double.infinity,
                    height: 72*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0*fem, 2*fem, 0*fem, 1*fem),
                      width: 310*fem,
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
              
                          Container(
                            // depth4frame0zrb (9:1693)
                            margin: EdgeInsets.fromLTRB(130*fem, 0.75*fem, 0*fem, 0.75*fem),
                            height: double.infinity,
                            child: Center(
                              child: Text(
                                'Confirmed',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 18*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25*ffem/fem,
                                  letterSpacing: -0.2700000107*fem,
                                  color: Color(0xff171111),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    // bookedartistxS3 (9:1704)
                    margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 0*fem, 11.5*fem),
                    child: Text(
                      'Booked artist',
                      style: SafeGoogleFont (
                        'Be Vietnam Pro',
                        fontSize: 22*ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.25*ffem/fem,
                        letterSpacing: -0.3300000131*fem,
                        color: Color(0xff171111),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                    padding: EdgeInsets.fromLTRB(16 * fem, 8 * fem, 16 * fem, 8 * fem),
                    width: double.infinity,
                    height: 56 * fem,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 5 * fem, 0 * fem),
                      width: double.infinity,
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 16 * fem, 0 * fem),
                            width: 40 * fem,
                            height: 40 * fem,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20 * fem),
                              child: FutureBuilder<String?>(
                                future: fetchImage(), // Function to fetch image from backend
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Container(color: Colors.grey); // Placeholder until image is loaded
                                  } else if (snapshot.hasError) {
                                    return Container(color: Colors.red); // Placeholder for error
                                  } else {
                                    return Image.network(snapshot.data ?? ''); // Display the fetched image
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 217 * fem,
                            height: double.infinity,
                            child: Center(
                              child: FutureBuilder<String?>(
                                future: fetchText(), // Function to fetch text from backend
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Container(); // Placeholder until text is loaded
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      'Error loading text', // Placeholder for error
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xff171111),
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      snapshot.data ?? '', // Display the fetched text
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xff171111),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // detailsWEb (9:1714)
                    margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 0*fem, 7.5*fem),
                    child: Text(
                      'Details',
                      style: SafeGoogleFont (
                        'Be Vietnam Pro',
                        fontSize: 18*ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.25*ffem/fem,
                        letterSpacing: -0.2700000107*fem,
                        color: Color(0xff171111),
                      ),
                    ),
                  ),
                  Container(
                    // depth1frame51h9 (9:1715)
                    padding: EdgeInsets.fromLTRB(16*fem, 14*fem, 16*fem, 13*fem),
                    width: double.infinity,
                    height: 72*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                    ),
                    child: Container(
                      // depth3frame0YBH (9:1717)
                      width: 69.28*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame05h1 (9:1718)
                            width: 39*fem,
                            height: 24*fem,
                            child: Center(
                              child: Text(
                                'Date',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff171111),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // depth4frame1b9Z (9:1721)
                            width: double.infinity,
                            child: Text(
                              dateText,
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 14*ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5*ffem/fem,
                                color: Color(0xff876370),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // depth1frame6vBq (9:1724)
                    padding: EdgeInsets.fromLTRB(16*fem, 14*fem, 16*fem, 13*fem),
                    width: double.infinity,
                    height: 72*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                    ),
                    child: Container(
                      // depth3frame0qpb (9:1726)
                      width: 62.03*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0nE3 (9:1727)
                            width: 39*fem,
                            height: 24*fem,
                            child: Center(
                              child: Text(
                                'Time',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff171111),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // depth4frame1V8T (9:1730)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0.03*fem, 0*fem),
                            width: double.infinity,
                            height: 21*fem,

                              child: Text(
                                timeText,
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 14*ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff876370),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // depth1frame7BGB (9:1733)
                    padding: EdgeInsets.fromLTRB(16*fem, 14*fem, 16*fem, 13*fem),
                    width: double.infinity,
                    height: 72*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                    ),
                    child: Container(
                      // depth3frame0uxs (9:1735)
                      width: 70.7*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame04as (9:1736)
                            width: double.infinity,
                            height: 24*fem,

                              child: Text(
                                'Duration',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff171111),

                              ),
                            ),
                          ),
                          Container(
                            // depth4frame1NrT (9:1739)
                            width: 420*fem,
                            height: 21*fem,

                              child: Text(
                                durationText ,
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 14*ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff876370),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // depth1frame8U8o (9:1742)
                    padding: EdgeInsets.fromLTRB(16*fem, 14*fem, 16*fem, 13*fem),
                    width: double.infinity,
                    height: 72*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                    ),
                    child: Container(
                      // depth3frame018j (9:1744)
                      width: 83.25*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame09Vq (9:1745)
                            width: 42*fem,
                            height: 24*fem,
                            child: Text(
                              'Price',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: Color(0xff171111),
                              ),
                            ),
                          ),
                          Container(
                            // depth4frame1G4f (9:1748)
                            width: double.infinity,
                            child: Text(
                              priceText,
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 14*ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5*ffem/fem,
                                color: Color(0xff876370),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // depth1frame9BxK (9:1751)
                    padding: EdgeInsets.fromLTRB(16*fem, 14*fem, 16*fem, 13*fem),
                    width: double.infinity,
                    height: 72*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                    ),
                    child: Container(
                      // depth3frame0ihM (9:1753)
                      width: 67.92*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0TQ3 (9:1754)
                            width: double.infinity,
                            height: 24*fem,
                            child: Text(
                              'Location',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: Color(0xff171111),
                              ),
                            ),
                          ),
                          Container(
                            // depth4frame1ZCB (9:1757)
                            width: 51*fem,
                            height: 21*fem,
                            child: Text(
                              'Venue',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 14*ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5*ffem/fem,
                                color: Color(0xff876370),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // autogroupmzqsqvP (JkRoFj6v1J7WT1Tj1JMZQs)
                    padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: ElevatedButton(
                            onPressed: () {
                              print('hi');
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
                                'Call Artist',
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
                        SizedBox(
                            height: 10*fem
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: ElevatedButton(
                            onPressed: () {
                              print('hi');
                              // Handle button press
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xfff4eff2),
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
                                'Edit Booking',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 16 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5 * ffem / fem,
                                  letterSpacing: 0.2399999946 * fem,
                                  color: Color(0xff171111),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // depth1frame126NT (9:1770)
                    width: double.infinity,
                    height: 20*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
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
Future<String> fetchImage() async {
  // Function to fetch image from backend, return the URL of the image
  return 'https://example.com/image.jpg';
}

Future<String> fetchText() async {
  // Function to fetch text from backend, return the text
  return 'Fetched text from backend';
}
