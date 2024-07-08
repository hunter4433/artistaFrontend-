import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountManagement2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor: Color(0xFF121217),

      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF121217),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF121217),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 28, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0.8, 0, 0.3),
                        child: Text(
                          'Home',
                          style: GoogleFonts.getFont(
                            'Be Vietnam Pro',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            height: 1.3,
                            letterSpacing: -0.3,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 23.5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Categories',
                  style: GoogleFonts.getFont(
                    'Be Vietnam Pro',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 1.3,
                    letterSpacing: -0.3,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 36.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
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
                                image: AssetImage('assets/images/depth_3_frame_04.png'),
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
                      ),
                      Expanded(
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
                              image: AssetImage('assets/images/depth_3_frame_03.png'),
                            ),
                          ),
                          height: 97.3,
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
                      ),
                    ],
                  ),
                  SizedBox(height: 11.7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
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
                                image: AssetImage('assets/images/depth_3_frame_0.png'),
                              ),
                            ),
                            height: 97.3,
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
                        ),
                      ),
                      Expanded(
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
                              image: AssetImage('assets/images/depth_3_frame_02.png'),
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
                    ],
                  ),
                  SizedBox(height: 11.7),
                  Align(
                    alignment: Alignment.topLeft,
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
                          image: AssetImage('assets/images/depth_3_frame_01.png'),
                        ),
                      ),
                      width: 173,
                      height: 97.3,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.all(16),
                          child: Text(
                            'Artist',
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
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 404.4,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF121217),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        offset: Offset(0, -5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Messages',
                        style: GoogleFonts.getFont(
                          'Be Vietnam Pro',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          height: 1.3,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      // Add messages or further content here
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
