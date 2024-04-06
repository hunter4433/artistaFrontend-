
import 'package:flutter/material.dart';
import 'package:test1/page-1/account_managment.dart';
import 'package:test1/page-1/customer_support.dart';
import '../utils.dart';

class setting extends StatelessWidget {
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
          // galileodesignh11 (16:2430)
          width: double.infinity,
          height: 844*fem,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: Container(
            // depth0frame0qN7 (16:2431)
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration (
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // depth1frame0ZJ7 (16:2432)
                  padding: EdgeInsets.fromLTRB(16*fem, 6*fem, 16*fem, 6*fem),
                  width: double.infinity,
                  height: 72*fem,
                  decoration: BoxDecoration (
                    color: Color(0xffffffff),
                  ),
                  child: Container(
                    // depth4frame0WsZ (16:2440)
                    margin: EdgeInsets.fromLTRB(0*fem, 0.75*fem, 0*fem, 0.75*fem),
                    height: double.infinity,
                    child: Center(
                      child: Text(
                        'Settings',
                        style: SafeGoogleFont (
                          'Be Vietnam Pro',
                          fontSize: 22*ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.25*ffem/fem,
                          letterSpacing: -0.2700000107*fem,
                          color: Color(0xff171111),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>account_managment()),
                    );
                  },
                  child: Container(
                    // depth1frame5N8P (16:2494)
                    padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                    width: double.infinity,
                    height: 56 * fem,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Specify the border color here
                          width: 0.25, // Specify the border width here
                        ),),
                      // Add decoration as needed
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Account',
                            style: SafeGoogleFont(
                              'Be Vietnam Pro',
                              fontSize: 17 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: Color(0xff171111),
                            ),
                          ),
                        ),
                        Container(

                          // depth2frame1MPD (19:2920)
                          width: 64 * fem,
                          height: 44 * fem,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded, // Different icon
                            // Color of the icon
                            // Size of the icon
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => customer_support()),
                );
              },
              child: Container(
                // depth1frame5N8P (16:2494)
                padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                width: double.infinity,
                height: 56 * fem,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // Specify the border color here
                      width: 0.25, // Specify the border width here
                    ),),
                  // Add decoration as needed
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(

                        // depth3frame02ij (16:2496)
                        child: Text(
                          'Legal',
                          style: SafeGoogleFont(
                            'Be Vietnam Pro',
                            fontSize: 17 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5 * ffem / fem,
                            color: Color(0xff171111),
                          ),
                        ),
                      ),
                    ),
                    Container(

                      // depth2frame1MPD (19:2920)
                      width: 64 * fem,
                      height: 44 * fem,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded, // Different icon
                        // Color of the icon
                        // Size of the icon
                      ),
                    ),
                  ],
                ),
              ),
            ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => customer_support()),
                    );
                  },
                  child: Container(
                    // depth1frame5N8P (16:2494)
                    padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                    width: double.infinity,
                    height: 56 * fem,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Specify the border color here
                          width: 0.25, // Specify the border width here
                        ),),
                      // Add decoration as needed
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(

                            // depth3frame02ij (16:2496)
                            child: Text(
                              'Notification',
                              style: SafeGoogleFont(
                                'Be Vietnam Pro',
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff171111),
                              ),
                            ),
                          ),
                        ),
                        Container(

                          // depth2frame1MPD (19:2920)
                          width: 64 * fem,
                          height: 44 * fem,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded, // Different icon
                            // Color of the icon
                            // Size of the icon
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => customer_support()),
                    );
                  },
                  child: Container(
                    // depth1frame5N8P (16:2494)
                    padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                    width: double.infinity,
                    height: 56 * fem,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                        color: Colors.grey, // Specify the border color here
                        width: 0.25, // Specify the border width here
                      ),),
                      // Add decoration as needed
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(

                            // depth3frame02ij (16:2496)
                            child: Text(
                              'Share App',
                              style: SafeGoogleFont(
                                'Be Vietnam Pro',
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff171111),
                              ),
                            ),
                          ),
                        ),
                        Container(

                          // depth2frame1MPD (19:2920)
                          width: 64 * fem,
                          height: 44 * fem,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded, // Different icon
                            // Color of the icon
                            // Size of the icon
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => customer_support()),
                    );
                  },
                  child: Container(
                    // depth1frame5N8P (16:2494)
                    padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                    width: double.infinity,
                    height: 56 * fem,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Specify the border color here
                          width: 0.25, // Specify the border width here
                        ),),
                      // Add decoration as needed
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(

                            // depth3frame02ij (16:2496)
                            child: Text(
                              'Cusromer Support',
                              style: SafeGoogleFont(
                                'Be Vietnam Pro',
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff171111),
                              ),
                            ),
                          ),
                        ),
                        Container(

                          // depth2frame1MPD (19:2920)
                          width: 64 * fem,
                          height: 44 * fem,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded, // Different icon
                            // Color of the icon

                            // Size of the icon
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => customer_support()),
                    );
                  },
                  child: Container(
                    // depth1frame5N8P (16:2494)
                    padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                    width: double.infinity,
                    height: 56 * fem,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Specify the border color here
                          width: 0.25, // Specify the border width here
                        ),),
                      // Add decoration as needed
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(

                            // depth3frame02ij (16:2496)
                            child: Text(
                              'App Version',
                              style: SafeGoogleFont(
                                'Be Vietnam Pro',
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff171111),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 44,
                          width: 94,

                          // depth2frame1MPD (19:2920)

                          child:Center(
                            child: const Text('1.0.2',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w300,
                              )

                              ),
                          ),

                          ),

                      ],
                    ),
                  ),
                ),
                Container(
                  // depth1frame5N8P (16:2494)
                  padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                  width: double.infinity,
                  height: 56 * fem,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey, // Specify the border color here
                        width: 0.25, // Specify the border width here
                      ),),
                    // Add decoration as needed
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(

                          // depth3frame02ij (16:2496)
                          child: Text(
                            'Logout',
                            style: SafeGoogleFont(
                              'Be Vietnam Pro',
                              fontSize: 17 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: Colors.red,
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
        ),
            ),
    ),);
  }
}