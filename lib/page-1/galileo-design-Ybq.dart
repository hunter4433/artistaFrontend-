import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../utils.dart';

class Scene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // galileodesign6rB (21:3325)
        width: double.infinity,
        height: 844*fem,
        decoration: BoxDecoration (
          color: Color(0xffffffff),
        ),
        child: Container(
          // depth0frame0esh (21:3326)
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // autogroupg9jfzAs (JkSJ9EJSQBqZmtioahG9Jf)
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 424*fem),
                padding: EdgeInsets.fromLTRB(16*fem, 24*fem, 16*fem, 12*fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // signupJBZ (21:3329)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                      child: Text(
                        'Sign up',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont (
                          'Plus Jakarta Sans',
                          fontSize: 32*ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.25*ffem/fem,
                          letterSpacing: -0.8000000119*fem,
                          color: Color(0xff1e0a11),
                        ),
                      ),
                    ),
                    Container(
                      // depth3frame0Pyh (21:3332)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // emailXa7 (21:3334)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8*fem),
                            child: Text(
                              'Email',
                              style: SafeGoogleFont (
                                'Plus Jakarta Sans',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: Color(0xff1e0a11),
                              ),
                            ),
                          ),
                          Container(
                            // depth5frame0EzK (21:3336)
                            padding: EdgeInsets.fromLTRB(15*fem, 15*fem, 15*fem, 17*fem),
                            width: double.infinity,
                            height: 56*fem,
                            decoration: BoxDecoration (
                              border: Border.all(color: Color(0xffeac6d3)),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(12*fem),
                            ),
                            child: Container(
                              // depth6frame0xvK (21:3337)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 287*fem, 0*fem),
                              width: 41*fem,
                              height: double.infinity,
                              child: Center(
                                child: Text(
                                  'Email',
                                  style: SafeGoogleFont (
                                    'Plus Jakarta Sans',
                                    fontSize: 16*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5*ffem/fem,
                                    color: Color(0xffa53a5e),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // depth3frame04Cf (21:3342)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 16*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // passwordCZm (21:3344)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8*fem),
                            child: Text(
                              'Password',
                              style: SafeGoogleFont (
                                'Plus Jakarta Sans',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: Color(0xff1e0a11),
                              ),
                            ),
                          ),
                          Container(
                            // depth5frame0vVm (21:3346)
                            padding: EdgeInsets.fromLTRB(15*fem, 15*fem, 15*fem, 17*fem),
                            width: double.infinity,
                            height: 56*fem,
                            decoration: BoxDecoration (
                              border: Border.all(color: Color(0xffeac6d3)),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(12*fem),
                            ),
                            child: Container(
                              // depth6frame03aP (21:3347)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 253.86*fem, 0*fem),
                              width: 74.14*fem,
                              height: double.infinity,
                              child: Text(
                                'Password',
                                style: SafeGoogleFont (
                                  'Plus Jakarta Sans',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xffa53a5e),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      // orcontinuewithgoogle9NX (21:3353)
                      'Or continue with Google',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont (
                        'Plus Jakarta Sans',
                        fontSize: 16*ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.5*ffem/fem,
                        color: Color(0xff1e0a11),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // depth2frame0GT9 (21:3355)
                margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 16*fem, 12*fem),
                padding: EdgeInsets.fromLTRB(142.23*fem, 12*fem, 141.77*fem, 12*fem),
                width: double.infinity,
                height: 48*fem,
                decoration: BoxDecoration (
                  color: Color(0xffe5195e),
                  borderRadius: BorderRadius.circular(24*fem),
                ),
                child: Container(
                  // depth3frame0muh (21:3356)
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration (
                    color: Color(0xffe5195e),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: SafeGoogleFont (
                        'Plus Jakarta Sans',
                        fontSize: 16*ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.5*ffem/fem,
                        letterSpacing: 0.2399999946*fem,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                // depth1frame6H7M (21:3359)
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
          );
  }
}