import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/main.dart';
import 'package:test1/page-1/page1.dart';
import '../utils.dart';

class Scene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(backgroundColor: Color(0xFF121217),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF121217)
            ,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 20 * fem),
                width: double.infinity,
                decoration: BoxDecoration(
                  color:Color(0xFF121217)
                  ,
                ),
                child: Center(
                  child: SizedBox(
                    width: 390 * fem,
                    height: 218 * fem,
                    child: Image.asset(
                      'assets/page-1/images/depth-4-frame-0-GGo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 290 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: 450 * fem,
                        ),
                        child: Center(
                          child: Text(
                            'Welcome to the new way of celebrating',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Be Vietnam Pro',
                              fontSize: 28 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.25 * ffem / fem,
                              letterSpacing: -0.6999999881 * fem,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20 * fem, 0 * fem, 20 * fem, 0 * fem),
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: 352 * fem,
                      ),
                      child: Center(
                        child: Text(
                          'From birthdays to baby showers, we\'ve got you covered with live entertainment from the best artists in your area.',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Be Vietnam Pro',
                            fontSize: 17 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5 * ffem / fem,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:35, right: 35),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>
                       Scene1() ,

                    )
                    );
                    // Handle button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffe5195e),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12 * fem),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * fem, // Adjust the horizontal padding as needed
                      vertical: 12 * fem,
                    ),
                    minimumSize: Size(double.infinity, 14 * fem), // Set the width to match the replaced container
                  ),
                  child: Center(
                    child: Text(
                      'Get Started',
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
      ),
    );
  }
}
