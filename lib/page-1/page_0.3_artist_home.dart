import 'package:flutter/material.dart';
import 'package:test1/page-1/booking_history.dart';
import 'package:test1/page-1/payment_history.dart';
import '../utils.dart';

class artist_home extends StatefulWidget {
  @override
  State<artist_home> createState() => _artist_home();
}
class _artist_home extends State<artist_home> {
  bool isAvailable = true;
  // Function to fetch image URL from backend
  Future<String> getImageUrlFromBackend() async {
    // Simulated delay to mimic network request
    await Future.delayed(Duration(seconds: 1));
    // Replace this with actual logic to fetch image URL from backend
    return 'https://example.com/your-image-url.jpg';

  }
  // Function to fetch name from the backend
  Future<String> getNameFromBackend() async {
    // Simulated delay to mimic network request
    await Future.delayed(Duration(seconds: 1));
    // Replace this with actual logic to fetch name from backend
    return 'Artist';
  }
  @override

  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: Text( 'ARTISTA',
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

      ),
      body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Container(

          width: double.infinity,
          height: 844*fem,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            SizedBox(
              height: 18,
            ),
              Container(
                // depth3frame0GvB (19:2886)
                margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 1*fem, 28.5*fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 128 * fem,
                      height: 128 * fem,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey, // Placeholder color until the image is loaded
                      ),
                      child: FutureBuilder<String>(
                        future: getImageUrlFromBackend(), // Function to fetch image URL from backend
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.data != null) {
                            // Assuming snapshot.data contains the image URL
                            String imageUrl = snapshot.data!;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(64 * fem),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return Center(child: Text('No image URL available'));
                          }
                        },
                      ),

                    ),
                    SizedBox(
                      height: 18*fem,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 28.5 * fem),
                      width: double.infinity,
                      child: Column(

                        children: [
                          FutureBuilder<String>(
                            future: getNameFromBackend(), // Function to fetch name from backend
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                String name = snapshot.data ?? 'Artist'; // Fallback to a default name if no data received
                                return Text(
                                  'Hi, $name',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Be Vietnam Pro',
                                    fontSize: 22 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.25 * ffem / fem,
                                    letterSpacing: -0.3300000131 * fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // depth1frame2SiB (19:2893)
                padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
                width: double.infinity,
                height: 72*fem,
                decoration: BoxDecoration (
                  color: Color(0xffffffff),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth2frame0A8P (19:2894)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 45.53*fem, 0*fem),
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // depth3frame0VwM (19:2895)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                            width: 48*fem,
                            height: 48*fem,
                            child: Image.asset(
                              'assets/page-1/images/depth-3-frame-0-Y6K.png',
                              width: 48*fem,
                              height: 48*fem,
                            ),
                          ),
                          Container(
                            // depth3frame1DcT (19:2900)
                            margin: EdgeInsets.fromLTRB(0*fem, 1.5*fem, 0*fem, 1.5*fem),
                            width: 180.47*fem,
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // depth4frame0kMV (19:2901)
                                  width: 182*fem,
                                  height: 24*fem,

                                    child: Text(
                                      'Availability',
                                      style: SafeGoogleFont (
                                        'Be Vietnam Pro',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5*ffem/fem,
                                        color: Color(0xff1e0a11),

                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: isAvailable, // Show this text if switch is on
                                  child: Container(
                                    // depth4frame1rQX (19:2904)
                                    width: double.infinity,
                                    child: Text(
                                      'I\'m Available for Bookings',
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xffa53a5e),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !isAvailable, // Show this text if switch is off
                                  child: Container(
                                    // depth4frame1rQX (19:2904)
                                    width: double.infinity,
                                    child: Text(
                                      'I\'ll be back soon',
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xffa53a5e),
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
                    Switch(
                      value: isAvailable, // Set initial value of the switch
                      onChanged: (value) {
                        setState(() {
                          isAvailable= value;

                        });
                        // Handle switch value change
                      },
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.redAccent,
                      inactiveThumbColor: Colors.white,
                    ),

                  ],
                ),
              ),
              Container(
                // depth1frame3tc7 (19:2911)
                margin: EdgeInsets.fromLTRB(0*fem, 30*fem, 0*fem, 4*fem),
                padding: EdgeInsets.fromLTRB(16*fem, 13*fem, 18*fem, 14*fem),
                width: double.infinity,
                height: 72*fem,
                decoration: BoxDecoration (

                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth3frame0bFd (19:2913)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 4.27*fem, 0*fem),
                      width: 317.73*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0j6w (19:2914)
                            width: 133*fem,
                            height: 24*fem,
                            child: Center(
                              child: Text(
                                'Payment history',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff1e0a11),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => payment_history()),
                              );

                          } ,
                            child: Container(
                              // depth4frame1qfm (19:2917)
                              width: 43*fem,
                              height: 21*fem,

                                child: Text(
                                  'View',
                                  style: SafeGoogleFont (
                                    'Be Vietnam Pro',
                                    fontSize: 14*ffem,
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
                    Container(
                      // depth2frame1MPD (19:2920)

                      width: 34*fem,
                      height: 62*fem,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => payment_history()),
                          );

                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_sharp, // Different icon
                          // Color of the icon
                          // Size of the icon
                        ),


                      ),

                    ),
                  ],
                ),
              ),


              Container(
                padding: EdgeInsets.fromLTRB(16*fem, 13*fem, 0*fem, 14*fem),
                width: double.infinity,
                height: 72*fem,
                decoration: BoxDecoration (
                  color: Color(0xffffffff),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // depth3frame0VQs (19:2946)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 188.84*fem, 0*fem),
                      width: 132.16*fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // depth4frame0d1H (19:2947)
                            width: 145*fem,
                            child: Text(
                              'Booking History',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: Color(0xff1e0a11),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => booking_history()),
                              );

                            },
                            child: Container(
                              // depth4frame1Ye3 (19:2950)
                              width: 135*fem,
                              height: 21*fem,

                                child: Text(
                                  'View all bookings',
                                  style: SafeGoogleFont (
                                    'Plus Jakarta Sans',
                                    fontSize: 14*ffem,
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
                    Container(child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => booking_history()),
                        );

                        // Handle buttonn press
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp, // Different icon
                         // Color of the icon
                         // Size of the icon
                      ),


                    ),

                      // depth2frame1GK9 (19:2953)

                      width: 34*fem,
                      height: 62*fem,

                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
            ),
    ),);
  }
}