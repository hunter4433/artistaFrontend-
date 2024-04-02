
import 'package:flutter/material.dart';
import 'package:test1/page-1/customer_support.dart';
import 'package:test1/page-1/delete_account.dart';
import 'package:test1/page-1/edit_user_info.dart';


import '../utils.dart';

class account_managment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(title: const Text('Account'),),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Container(
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

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>user_information()),
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
                            width: 0.2, // Specify the border width here
                          ),),
                        // Add decoration as needed
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(

                              // depth3frame02ij (16:2496)
                              child: Text(
                                'Edit Profile',
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
                            width: 0.2, // Specify the border width here
                          ),),
                        // Add decoration as needed
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(

                              // depth3frame02ij (16:2496)
                              child: Text(
                                'Report a Problem',
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
                        MaterialPageRoute(builder: (context) => account_delete()),
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
                                'Delete Account',
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
                          Container(

                            // depth2frame1MPD (19:2920)
                            width: 64 * fem,
                            height: 44 * fem,
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded, // Different icon
                              // Color of the icon
                              // Size of the icon
                            ),
                          ),
                        ],
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