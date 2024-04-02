import 'package:flutter/material.dart';
import '../utils.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: Text( 'Search',
          textAlign: TextAlign.center,
          style: SafeGoogleFont(
            'Be Vietnam Pro',
            fontSize: 19 * ffem,
            fontWeight: FontWeight.w700,
            height: 1.25 * ffem / fem,
            letterSpacing: -0.8000000119 * fem,
            color: Color(0xff1e0a11),
          ),),
        backgroundColor: Color(0xffffffff),

        // Add a back arrow in the top-left corner to go back to the previous screen
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Use Navigator.pop() to close the current screen (Scene2) and go back to the previous screen (Scene1)
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Container(
          // galileodesignvfq (6:1277)
          width: double.infinity,
          height: 844*fem,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: Container(
            // depth0frame05Hq (6:1278)
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration (
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // autogrouprmqb1xB (JkRcEsnjTfPdeTAJFwrMQB)
                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 117*fem),
                  padding: EdgeInsets.fromLTRB(12*fem, 12*fem, 16*fem, 12*fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // depth2frame0i5u (6:1280)
                        margin: EdgeInsets.fromLTRB(4*fem, 0*fem, 0*fem, 24*fem),
                        padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 170*fem, 12*fem),
                        width: double.infinity,
                        decoration: BoxDecoration (
                          color: Color(0xfff5f0f2),
                          borderRadius: BorderRadius.circular(24*fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // depth3frame0cSB (6:1281)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                              width: 24*fem,
                              height: 24*fem,
                              child: Image.asset(
                                'assets/page-1/images/depth-3-frame-0-6NT.png',
                                width: 24*fem,
                                height: 24*fem,
                              ),
                            ),
                            Text(
                              // livemusicdjetcXp3 (6:1287)
                              'Live music, DJ, etc',
                              style: SafeGoogleFont (
                                'Plus Jakarta Sans',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5*ffem/fem,
                                color: Color(0xffa53a5e),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // depth1frame1TSo (6:1288)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 16*fem),
                        width: 343.34*fem,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // autogroupcvpuyvw (JkRcfXkKTVVhGexsX1CVPu)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                              width: double.infinity,
                              height: 32*fem,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // depth2frame0VeP (6:1289)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 11.84*fem, 0*fem),
                                    width: 97.16*fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration (
                                      color: Color(0xfff5f0f2),
                                      borderRadius: BorderRadius.circular(16*fem),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'All genres',
                                        style: SafeGoogleFont (
                                          'Plus Jakarta Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5*ffem/fem,
                                          color: Color(0xff1e0a11),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // depth2frame1NiB (6:1293)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 11.72*fem, 0*fem),
                                    width: 59.28*fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration (
                                      color: Color(0xfff5f0f2),
                                      borderRadius: BorderRadius.circular(16*fem),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Pop',
                                        style: SafeGoogleFont (
                                          'Plus Jakarta Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5*ffem/fem,
                                          color: Color(0xff1e0a11),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // depth2frame2FX5 (6:1297)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12.89*fem, 0*fem),
                                    width: 89.11*fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration (
                                      color: Color(0xfff5f0f2),
                                      borderRadius: BorderRadius.circular(16*fem),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Hip-hop',
                                        style: SafeGoogleFont (
                                          'Plus Jakarta Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5*ffem/fem,
                                          color: Color(0xff1e0a11),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // depth2frame3WT1 (6:1301)
                                    width: 61.34*fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration (
                                      color: Color(0xfff5f0f2),
                                      borderRadius: BorderRadius.circular(16*fem),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'R&B',
                                        style: SafeGoogleFont (
                                          'Plus Jakarta Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5*ffem/fem,
                                          color: Color(0xff1e0a11),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // autogroupt7w5oBD (JkRcwXHfwbcmBvTWmUT7w5)
                              height: 32*fem,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // depth2frame4LS3 (6:1305)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12.27*fem, 0*fem),
                                    width: 112.73*fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration (
                                      color: Color(0xfff5f0f2),
                                      borderRadius: BorderRadius.circular(16*fem),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Los Angeles',
                                        style: SafeGoogleFont (
                                          'Plus Jakarta Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5*ffem/fem,
                                          color: Color(0xff1e0a11),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // depth2frame5DEw (6:1309)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 11.33*fem, 0*fem),
                                    width: 72.67*fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration (
                                      color: Color(0xfff5f0f2),
                                      borderRadius: BorderRadius.circular(16*fem),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Today',
                                        style: SafeGoogleFont (
                                          'Plus Jakarta Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5*ffem/fem,
                                          color: Color(0xff1e0a11),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // depth2frame6trs (6:1313)
                                    width: 62.95*fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration (
                                      color: Color(0xfff5f0f2),
                                      borderRadius: BorderRadius.circular(16*fem),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Now',
                                        style: SafeGoogleFont (
                                          'Plus Jakarta Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5*ffem/fem,
                                          color: Color(0xff1e0a11),
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
                        // top40artistsinlosangelesPYj (6:1319)
                        margin: EdgeInsets.fromLTRB(4*fem, 0*fem, 0*fem, 16*fem),
                        child: Text(
                          'Top 40 Artists in Los Angeles',
                          style: SafeGoogleFont (
                            'Plus Jakarta Sans',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5*ffem/fem,
                            color: Color(0xff1e0a11),
                          ),
                        ),
                      ),
                      Container(
                        // top40artistsinnewyorkcityJQo (6:1322)
                        margin: EdgeInsets.fromLTRB(4*fem, 0*fem, 0*fem, 16*fem),
                        child: Text(
                          'Top 40 Artists in New York City',
                          style: SafeGoogleFont (
                            'Plus Jakarta Sans',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5*ffem/fem,
                            color: Color(0xff1e0a11),
                          ),
                        ),
                      ),
                      Container(
                        // top40artistsinsanfranciscoD1y (6:1325)
                        margin: EdgeInsets.fromLTRB(4*fem, 0*fem, 0*fem, 16*fem),
                        child: Text(
                          'Top 40 Artists in San Francisco',
                          style: SafeGoogleFont (
                            'Plus Jakarta Sans',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5*ffem/fem,
                            color: Color(0xff1e0a11),
                          ),
                        ),
                      ),
                      Container(
                        // top40artistsinmiami7d9 (6:1328)
                        margin: EdgeInsets.fromLTRB(4*fem, 0*fem, 0*fem, 16*fem),
                        child: Text(
                          'Top 40 Artists in Miami',
                          style: SafeGoogleFont (
                            'Plus Jakarta Sans',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5*ffem/fem,
                            color: Color(0xff1e0a11),
                          ),
                        ),
                      ),
                      Container(
                        // top40artistsinchicagodbV (6:1331)
                        margin: EdgeInsets.fromLTRB(4*fem, 0*fem, 0*fem, 16*fem),
                        child: Text(
                          'Top 40 Artists in Chicago',
                          style: SafeGoogleFont (
                            'Plus Jakarta Sans',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5*ffem/fem,
                            color: Color(0xff1e0a11),
                          ),
                        ),
                      ),
                      Container(
                        // top40artistsinbostonYTZ (6:1334)
                        margin: EdgeInsets.fromLTRB(4*fem, 0*fem, 0*fem, 16*fem),
                        child: Text(
                          'Top 40 Artists in Boston',
                          style: SafeGoogleFont (
                            'Plus Jakarta Sans',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5*ffem/fem,
                            color: Color(0xff1e0a11),
                          ),
                        ),
                      ),
                      Container(
                        // top40artistsinaustinfHH (6:1337)
                        margin: EdgeInsets.fromLTRB(4*fem, 0*fem, 0*fem, 16*fem),
                        child: Text(
                          'Top 40 Artists in Austin',
                          style: SafeGoogleFont (
                            'Plus Jakarta Sans',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5*ffem/fem,
                            color: Color(0xff1e0a11),
                          ),
                        ),
                      ),
                      Container(
                        // top40artistsinlasvegasnMu (6:1340)
                        margin: EdgeInsets.fromLTRB(4*fem, 0*fem, 0*fem, 0*fem),
                        child: Text(
                          'Top 40 Artists in Las Vegas',
                          style: SafeGoogleFont (
                            'Plus Jakarta Sans',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5*ffem/fem,
                            color: Color(0xff1e0a11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // depth1frame11HZZ (6:1342)
                  padding: EdgeInsets.fromLTRB(39.75*fem, 8*fem, 38.25*fem, 13*fem),
                  width: double.infinity,
                  height: 75*fem,
                  decoration: BoxDecoration (
                    border: Border.all(color: Color(0xfff5f0f2)),
                    color: Color(0xffffffff),
                  ),
                  child: Container(
                    // depth2frame0cLw (6:1343)
                    width: double.infinity,
                    height: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          // depth3frame08aB (6:1344)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 49.5*fem, 0*fem),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // depth4frame0f4K (6:1345)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8*fem),
                                width: 24*fem,
                                height: 24*fem,
                                child: Image.asset(
                                  'assets/page-1/images/depth-4-frame-0-btb.png',
                                  width: 24*fem,
                                  height: 24*fem,
                                ),
                              ),
                              Text(
                                // homeNUX (6:1352)
                                'Home',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont (
                                  'Plus Jakarta Sans',
                                  fontSize: 12*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  letterSpacing: 0.1800000072*fem,
                                  color: Color(0xffa53a5e),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // depth3frame1Waj (6:1353)
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // depth4frame0sAP (6:1354)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                                width: 48*fem,
                                height: 32*fem,
                                child: Image.asset(
                                  'assets/page-1/images/depth-4-frame-0-2N3.png',
                                  width: 48*fem,
                                  height: 32*fem,
                                ),
                              ),
                              Text(
                                // searchzF1 (6:1361)
                                'Search',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont (
                                  'Plus Jakarta Sans',
                                  fontSize: 12*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  letterSpacing: 0.1800000072*fem,
                                  color: Color(0xff1e0a11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // autogrouprethXVq (JkRehogaR773nuGAReRETH)
                          padding: EdgeInsets.fromLTRB(39.5*fem, 4*fem, 0*fem, 0*fem),
                          height: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                // depth3frame2GCX (6:1362)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 44*fem, 0*fem),
                                height: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // depth4frame0CM5 (6:1363)
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8*fem),
                                      width: 24*fem,
                                      height: 24*fem,
                                      child: Image.asset(
                                        'assets/page-1/images/depth-4-frame-0-C1D.png',
                                        width: 24*fem,
                                        height: 24*fem,
                                      ),
                                    ),
                                    Text(
                                      // bookingsKAo (6:1370)
                                      'Bookings',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Plus Jakarta Sans',
                                        fontSize: 12*ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5*ffem/fem,
                                        letterSpacing: 0.1800000072*fem,
                                        color: Color(0xffa53a5e),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // depth3frame3T27 (6:1371)
                                height: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // depth4frame0QCF (6:1372)
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8*fem),
                                      width: 24*fem,
                                      height: 24*fem,
                                      child: Image.asset(
                                        'assets/page-1/images/depth-4-frame-0.png',
                                        width: 24*fem,
                                        height: 24*fem,
                                      ),
                                    ),
                                    Text(
                                      // profile7cT (6:1379)
                                      'Profile',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Plus Jakarta Sans',
                                        fontSize: 12*ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5*ffem/fem,
                                        letterSpacing: 0.1800000072*fem,
                                        color: Color(0xffa53a5e),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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