import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/page-1/page0.3_booking.dart';
import '../utils.dart';

class payment_history extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
        appBar: AppBar(
        title: Text( 'Payment History',
        textAlign: TextAlign.center,
        style: SafeGoogleFont(
        'Be Vietnam Pro',
        fontSize: 22 * ffem,
        fontWeight: FontWeight.w700,
        height: 1.25 * ffem / fem,
        color: Color(0xffa53a5e),
    ),),
    backgroundColor: Color(0xffffffff),

    // Add a back arrow in the top-left corner to go back to the previous screen

    ),);}
}
