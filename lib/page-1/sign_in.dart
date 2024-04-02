import 'package:flutter/material.dart';
import '../utils.dart';

class Scene extends StatelessWidget {
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
          // galileodesignwYb (4:931)
          width: double.infinity,
          height: 844*fem,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: Container(
            // depth0frame0tCw (4:932)
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration (
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // depth1frame0RCs (4:933)
                  padding: EdgeInsets.fromLTRB(165.84*fem, 28.75*fem, 165.84*fem, 15.75*fem),
                  width: double.infinity,
                  height: 72*fem,
                  decoration: BoxDecoration (
                    color: Color(0xffffffff),
                  ),
                  child: Container(
                    // depth4frame0YoH (4:937)
                    width: double.infinity,
                    height: double.infinity,
                    child: Text(
                      'Sign in',
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
                Container(
                  // autogroupndhq3zw (JkRZBxsWizfhRZPKSFNdhq)
                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 3*fem),
                  padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // depth5frame0N1d (4:946)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                        padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 16*fem, 16*fem),
                        width: double.infinity,
                        height: 56*fem,
                        decoration: BoxDecoration (
                          color: Color(0xfff4eff2),
                          borderRadius: BorderRadius.circular(12*fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // depth6frame0TYs (4:947)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 259*fem, 0*fem),
                              width: 43*fem,
                              height: double.infinity,
                              child: Center(
                                child: Text(
                                  'Email',
                                  style: SafeGoogleFont (
                                    'Be Vietnam Pro',
                                    fontSize: 16*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5*ffem/fem,
                                    color: Color(0xff876370),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              // depth6frame1M8T (4:950)
                              width: 24*fem,
                              height: 24*fem,
                              child: Image.asset(
                                'assets/page-1/images/depth-6-frame-1-KAF.png',
                                width: 24*fem,
                                height: 24*fem,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // depth5frame05KM (4:958)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                        padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 16*fem, 16*fem),
                        width: double.infinity,
                        height: 56*fem,
                        decoration: BoxDecoration (
                          color: Color(0xfff4eff2),
                          borderRadius: BorderRadius.circular(12*fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // depth6frame0yfd (4:959)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 225.81*fem, 0*fem),
                              width: 76.19*fem,
                              height: double.infinity,
                              child: Text(
                                'Password',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff876370),
                                ),
                              ),
                            ),
                            Container(
                              // depth6frame1HAX (4:962)
                              width: 24*fem,
                              height: 24*fem,
                              child: Image.asset(
                                'assets/page-1/images/depth-6-frame-1-XC3.png',
                                width: 24*fem,
                                height: 24*fem,
                              ),
                            ),
                          ],
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
                              'Sign In',
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
                        height: 16*fem,
                      ),
                      Text(
                        // orcontinuewithgoogleRg3 (4:973)
                        'Forget Password?\nDon\'t have a account Sign Up',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont (
                          'Be Vietnam Pro',
                          fontSize: 14*ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.5*ffem/fem,
                          color: Color(0xff876370),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // depth1frame8N5V (4:975)
                  width: double.infinity,
                  decoration: BoxDecoration (
                    image: DecorationImage (
                      fit: BoxFit.cover,
                      image: AssetImage (
                        'assets/page-1/images/vector-2.png',
                      ),
                    ),
                  ),
                  child: Center(
                    // vector34j1 (4:979)
                    child: SizedBox(
                      width: 390*fem,
                      height: 320*fem,
                      child: Image.asset(
                        'assets/page-1/images/vector-3.png',
                        width: 390*fem,
                        height: 320*fem,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
            ),
    ),);
  }
}