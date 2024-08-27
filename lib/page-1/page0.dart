import 'package:flutter/material.dart';
import 'package:test1/page-1/page1.dart';
import '../utils.dart';

class Scene extends StatefulWidget {
  @override
  _SceneState createState() => _SceneState();
}

class _SceneState extends State<Scene> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black, // Keep the black background color
          ),

          SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20 * fem),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image at the top with adjustable height and full width
                  Container(
                    width: MediaQuery.of(context).size.width, // Ensures full width of the screen
                    height: 200 * fem, // Adjust this value for image height
                    child: Image.asset(
                      'assets/page-1/images/bulbs.jpg', // Replace with your image asset
                      fit: BoxFit.cover, // Ensures image covers the entire width
                    ),
                  ),

                  Spacer(flex: 1),

                  // Text content remains the same
                  Center(
                    child: Container(
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
                            letterSpacing: -0.7 * fem,
                            color: Colors.white, // Text color remains white
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16 * fem),

                  Center(
                    child: Text(
                      'From birthdays to baby showers, we\'ve got you covered with live entertainment from the best artists in your area.',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Be Vietnam Pro',
                        fontSize: 17 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.5 * ffem / fem,
                        color: Colors.white, // Text color remains white
                      ),
                    ),
                  ),

                  Spacer(flex: 2),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scene1(),
                          ),
                        );
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
                          'Get Started',
                          style: SafeGoogleFont(
                            'Be Vietnam Pro',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.5 * ffem / fem,
                            letterSpacing: 0.24 * fem,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}