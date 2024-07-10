import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:test1/page-1/page2.1.dart';
// import 'package:test1/page-1/signup_team.dart';
import 'package:test1/page-1/page2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/phone_number.dart';

class Scene1 extends StatelessWidget {

  const Scene1({Key? key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    final storage = FlutterSecureStorage();

    void saveSelectedValue(String value) async {
    return await storage.write(key: 'selected_value', value: value);

    }



    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 16 * fem, 8 * fem),
              width: double.infinity,
              height: 72 * fem,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                // color : Colors.yellow,
              ),
              child: Container(
                color: Color(0xffffffff),
                padding: EdgeInsets.fromLTRB(0 * fem, 12 * fem, 0 * fem, 12 * fem),
                width: 310 * fem,
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(color: Color(0xffffffff),
                      margin: EdgeInsets.fromLTRB(145 * fem, 0.75 * fem, 10 * fem, 0.75 * fem),
                      height: double.infinity,

                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.25 * ffem / fem,
                            letterSpacing: -0.2700000107 * fem,
                            color: Color(0xff171111),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 340 * fem),
              padding: EdgeInsets.fromLTRB(16 * fem, 0 * fem, 16 * fem, 12 * fem),
              width: double.infinity,
              color: Color(0xffffffff),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Color(0xffffffff),
                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 29 * fem),
                    child: Text(
                      'Start Your Journey With Us.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 28 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.25 * ffem / fem,
                        letterSpacing: -0.6999999881 * fem,
                        color: Color(0xff171111),
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xffffffff),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: ElevatedButton(
                            onPressed: () {
                              saveSelectedValue('hire');
                              Navigator.push(context, MaterialPageRoute(builder:(context)
                              => PhoneNumberInputScreen()
                              ));

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
                                'Hire Artist',
                                style: GoogleFonts.beVietnamPro(
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
                          height: 12 * fem,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: ElevatedButton(
                            onPressed: () {
                              saveSelectedValue('solo_artist');
                              Navigator.push(context, MaterialPageRoute(builder:(context)
                              => Scene2()
                              ));
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
                                'I\'m a Solo Artist',
                                style: GoogleFonts.beVietnamPro(
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
                          height: 12 * fem,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: ElevatedButton(
                            onPressed: () {
                              saveSelectedValue('team');
                              Navigator.push(context, MaterialPageRoute(builder:(context)
                              => Scene2()
                              ));
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
                                'We\'re a Team of Artists',
                                style: GoogleFonts.beVietnamPro(
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
                ],
              ),
            ),
            Container(
              color: Color(0xffffffff),
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 12 * fem),
              constraints: BoxConstraints(
                maxWidth: 339 * fem,
              ),
              child: Text(
                'By continuing you agree to our privacy policy and terms and conditions.',
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 15 * ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.5 * ffem / fem,
                  color: Color(0xff876370),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
