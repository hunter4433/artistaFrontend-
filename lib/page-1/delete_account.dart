
import 'package:flutter/material.dart';
import 'package:test1/page-1/customer_support.dart';
import 'package:test1/page-1/edit_user_info.dart';


import '../utils.dart';

class account_delete extends StatelessWidget {
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(height: 674*fem,width: double.infinity,
                      padding: EdgeInsets.all(20),
                      child: const Text(
                        'Before proceeding with the deletion of your account, we want to ensure that '
                            'you\'re fully informed about the implications of this action. Deleting your '
                            'account will result in the permanent removal of all your data from our servers, '
                            'regardless of its secure encryption by Stargrime. '
                            '\n\nWe understand that this decision may be significant for you,'
                            ' and we want to reassure you that your security and privacy are '
                            'of the utmost importance to us. If you have any concerns or encounter '
                            'any issues during this process, please don\'t '
                            'hesitate to reach out to us through the customer'
                            ' support option available in the settings.'
                            '\n\nOur dedicated support team is here to assist'
                            ' you every step of the way and address any questions or concerns you may have. '
                            'Your satisfaction and peace of mind are our top priorities, and we\'re '
                        'committed to ensuring that you have a'
                        ' positive experience with our service.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff171111),
                          fontFamily: 'Be Vietnam Pro', // Change font family as needed
                          // You can add more text styles as needed
                        ),
                      ),
                
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 45, right: 45),
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
                            'Delete Account',
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
          ),
        ),
      ),);
  }
}