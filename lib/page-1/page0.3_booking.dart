import 'package:flutter/material.dart';
import '../utils.dart';

class bookingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: SafeArea(
      child: Container(  color: Color(0xffffffff),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // depth1frame0yeX (19:2718)
              padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 16*fem, 8*fem),
              width: double.infinity,
              height: 72*fem,
              decoration: BoxDecoration (

              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(0*fem, 0.75*fem, 0*fem, 0.75*fem),
                height: double.infinity,
                child: Center(
                  child: Text(
                    'Booking Details',
                    style: SafeGoogleFont (
                      'Be Vietnam Pro',
                      fontSize: 22*ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.25*ffem/fem,
                      letterSpacing: -0.2700000107*fem,
                      color: Color(0xff1e0a11),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              // depth1frame1qaF (19:2731)
              padding: EdgeInsets.fromLTRB(16*fem, 11*fem, 16*fem, 12*fem),
              width: double.infinity,
              height: 72*fem,
              decoration: BoxDecoration (

              ),
              child: Container(
                width: 48.77*fem,
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth3frame0KVR (19:2733)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                      width: 48*fem,
                      height: 48*fem,
                      child: Image.asset(
                        'assets/page-1/images/depth-3-frame-0-s9q.png',
                        width: 48*fem,
                        height: 48*fem,
                      ),
                    ),
                    Container(
                      // depth3frame12ud (19:2738)
                      margin: EdgeInsets.fromLTRB(0*fem, 1.5*fem, 0*fem, 1.5*fem),
                      width: 271.77*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0Mwu (19:2739)
                            width: 146*fem,
                            height: 24*fem,

                              child: Text(
                                'Name',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff1e0a11),

                              ),
                            ),
                          ),
                          Container(
                            // depth4frame1sQT (19:2742)
                            width: 216*fem,
                            height: 21*fem,

                              child: Text(
                                'Marie S.',
                                style: SafeGoogleFont (
                                  'Plus Jakarta Sans',
                                  fontSize: 18*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xffa53a5e),

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
            Container(
              // depth1frame2PNo (19:2745)
              padding: EdgeInsets.fromLTRB(16*fem, 11*fem, 16*fem, 12*fem),
              width: double.infinity,
              height: 72*fem,
              decoration: BoxDecoration (

              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // depth3frame0Ffu (19:2747)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                    width: 48*fem,
                    height: 48*fem,
                    child: Image.asset(
                      'assets/page-1/images/depth-3-frame-0-zKZ.png',
                      width: 48*fem,
                      height: 48*fem,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0*fem, 1.5*fem, 0*fem, 1.5*fem),
                    width: 198.42*fem,
                    height:  48*fem,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // depth4frame06gX (19:2753)
                          width: 100*fem,
                          height: 24*fem,
                          child: Text(
                            'Phone',
                            style: SafeGoogleFont (
                              'Be Vietnam Pro',
                              fontSize: 16*ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.5*ffem/fem,
                              color: Color(0xff1e0a11),
                            ),
                          ),
                        ),
                        Container(
                          // depth4frame1CzT (19:2756)
                          width: double.infinity,
                          height: 22*fem,
                          child: Text(
                            '+123-456-7890',
                            style: SafeGoogleFont (
                              'Plus Jakarta Sans',
                              fontSize: 18*ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.5*ffem/fem,
                              color: Color(0xffa53a5e),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // depth1frame3wBM (19:2759)
              padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
              width: double.infinity,
              height: 72*fem,
              decoration: BoxDecoration (

              ),
              child: Container(
                // depth2frame052f (19:2760)
                width: 140.8*fem,
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth3frame0pW3 (19:2761)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                      width: 48*fem,
                      height: 48*fem,
                      child: Image.asset(
                        'assets/page-1/images/depth-3-frame-0-noy.png',
                        width: 48*fem,
                        height: 48*fem,
                      ),
                    ),
                    Container(
                      // depth3frame1wqZ (19:2766)
                      margin: EdgeInsets.fromLTRB(0*fem, 1.5*fem, 0*fem, 1.5*fem),
                      width: 206.8*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame05gs (19:2767)
                            width: 47*fem,
                            height: 24*fem,
                            child: Text(
                              'Date',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: Color(0xff1e0a11),
                              ),
                            ),
                          ),
                          Container(
                            // depth4frame1nLP (19:2770)
                            width: 187*fem,
                            height: 21*fem,
                            child: Text (
                              'Jan 21,2023',
                              style: SafeGoogleFont (
                                'Plus Jakarta Sans',
                                fontSize: 15*ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5*ffem/fem,
                                color: Color(0xffa53a5e),
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
            Container(
              // depth1frame4W1V (19:2773)
              padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
              width: double.infinity,
              height: 72*fem,
              decoration: BoxDecoration (

              ),
              child: Container(
                // depth2frame0Ey5 (19:2774)
                width: 120*fem,
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth3frame0my1 (19:2775)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                      width: 48*fem,
                      height: 48*fem,
                      child: Image.asset(
                        'assets/page-1/images/depth-3-frame-0-WEs.png',
                        width: 48*fem,
                        height: 48*fem,
                      ),
                    ),
                    Container(
                      // depth3frame1hLs (19:2780)
                      margin: EdgeInsets.fromLTRB(0*fem, 1.5*fem, 0*fem, 1.5*fem),
                      width: 256*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0E5u (19:2781)
                            width: 137*fem,
                            height: 24*fem,
                            child: Text(
                              'Time',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: Color(0xff1e0a11),
                              ),
                            ),
                          ),
                          Container(
                            // depth4frame18wy (19:2784)
                            width: double.infinity,
                            height: 21*fem,
                            child: Text(
                              '6:00 PM',
                              style: SafeGoogleFont (
                                'Plus Jakarta Sans',
                                fontSize: 15*ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5*ffem/fem,
                                color: Color(0xffa53a5e),
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
            Container(
              // depth1frame5Fmh (19:2787)
              padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 1*fem),
              width: double.infinity,
              height: 72*fem,
              decoration: BoxDecoration (
                color: Color(0xffffffff),
              ),
              child: Container(
                // depth2frame0Pd1 (19:2788)
                width: 129.69*fem,
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth3frame0Lo9 (19:2789)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                      width: 48*fem,
                      height: 48*fem,
                      child: Image.asset(
                        'assets/page-1/images/depth-3-frame-0-T4K.png',
                        width: 48*fem,
                        height: 48*fem,
                      ),
                    ),
                    Container(
                      // depth3frame1rWb (19:2794)
                      margin: EdgeInsets.fromLTRB(0*fem, 1.5*fem, 0*fem, 1.5*fem),
                      width: 165.69*fem,
                      height: 48*fem,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0Bom (19:2795)
                            width: double.infinity,
                            height: 24*fem,

                              child: Text(
                                'Duration',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff1e0a11),

                              ),
                            ),
                          ),
                          Container(
                            // depth4frame17Bd (19:2798)
                            width: double.infinity,
                            height: 24*fem,

                              child: Text(
                                '3 hours',
                                style: SafeGoogleFont (
                                  'Plus Jakarta Sans',
                                  fontSize: 15*ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xffa53a5e),

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
            Container(
              // depth1frame61no (19:2801)
              padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
              width: double.infinity,
              height: 72*fem,
              decoration: BoxDecoration (
                color: Color(0xffffffff),
              ),
              child: Container(
                // depth2frame0wgT (19:2802)
                width: 140.47*fem,
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth3frame06ZM (19:2803)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                      width: 48*fem,
                      height: 48*fem,
                      child: Image.asset(
                        'assets/page-1/images/depth-3-frame-0-muZ.png',
                        width: 48*fem,
                        height: 48*fem,
                      ),
                    ),
                    Container(
                      // depth3frame1cXh (19:2808)
                      margin: EdgeInsets.fromLTRB(0*fem, 1.5*fem, 0*fem, 1.5*fem),
                      width: 286.47*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0YRM (19:2809)
                            width: 149*fem,
                            height: 24*fem,
                            child: Text(
                              'Venue',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: Color(0xff1e0a11),
                              ),
                            ),
                          ),
                          Container(color: Colors.purple,
                            // depth4frame1ymZ (19:2812)
                            width: double.infinity,
                            child: Text(
                              'The Garden',
                              style: SafeGoogleFont (
                                'Plus Jakarta Sans',
                                fontSize: 15*ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5*ffem/fem,
                                color: Color(0xffa53a5e),
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
            Container(
              // depth1frame7JYw (19:2815)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 50*fem),
              padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
              width: double.infinity,
              height: 72*fem,
              decoration: BoxDecoration (
                color: Color(0xffffffff),
              ),
              child: Container(
                // depth2frame0cpX (19:2816)
                width: 205.25*fem,
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth3frame0N31 (19:2817)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                      width: 48*fem,
                      height: 48*fem,
                      child: Image.asset(
                        'assets/page-1/images/depth-3-frame-0-aYo.png',
                        width: 48*fem,
                        height: 48*fem,
                      ),
                    ),
                    Container(
                      // depth3frame1ULw (19:2822)
                      margin: EdgeInsets.fromLTRB(0*fem, 1.5*fem, 0*fem, 1.5*fem),
                      width: 241.25*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0oe7 (19:2823)
                            width: 140*fem,
                            height: 24*fem,
                            child: Text(
                              'Special Request',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: Color(0xff1e0a11),
                              ),
                            ),
                          ),
                          Container(color: Colors.purple,
                            // depth4frame1K6f (19:2826)
                            width: double.infinity,
                            child: Text(
                              'Please play some jazz',
                              style: SafeGoogleFont (
                                'Plus Jakarta Sans',
                                fontSize: 15*ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5*ffem/fem,
                                color: Color(0xffa53a5e),
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
                    'Generate OTP',
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
    ),);
  }
}