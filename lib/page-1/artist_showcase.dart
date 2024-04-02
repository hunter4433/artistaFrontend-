
import 'package:flutter/material.dart';
import 'package:test1/page-1/booking_artis.dart';
import '../utils.dart';


class artist_profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;


    // Simulated list of image paths from backend
    List<String> imagePathsFromBackend = [
      'assets/page-1/images/depth-4-frame-0-c8F.png',
      'image2_url_from_backend',
      'image2_url_from_backend',
      'image2_url_from_backend',

      // Add more image paths as needed
    ];

    // Simulated list of image paths from backend
    String profileImagePathFromBackend = 'profile_image_url_from_backend';

    // Simulated data fetched from backend
    Future<String> fetchName() async {
      // Fetch name from the backend
      return Future.delayed(Duration(seconds: 1), () => 'Carla');
    }

    Future<String> fetchRole() async {
      // Fetch role from the backend
      return Future.delayed(Duration(seconds: 1), () => 'Artist');
    }

    Future<String> fetchRatings() async {
      // Fetch ratings from the backend
      return Future.delayed(Duration(seconds: 1), () => '4.5/5');
    }

    Future<String> fetchPrice() async {
      // Fetch price per hour from the backend
      return Future.delayed(Duration(seconds: 1), () => '200');
    }


    Future<String> fetchAboutText() async {
      // Simulated delay to mimic network request
      await Future.delayed(Duration(seconds: 1));

      // Simulated data fetched from the backend
      String aboutText = 'My work is inspired by nature and the human form. I specialize in murals and paintings.';

      // Return the fetched about text
      return aboutText;
    }

    // Function to fetch the special message from the backend
    Future<String> fetchSpecialMessage() async {
      // Simulated delay to mimic network request
      await Future.delayed(Duration(seconds: 2));

      // Simulated data fetched from the backend
      String specialMessage = 'Thank you for hosting! We are excited to be part of your event.';

      // Return the fetched special message
      return specialMessage;
    }



    return Scaffold(
      appBar: AppBar(title: Text('Artista'),
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
          // galileodesignDQb (15:2110)
          width: double.infinity,
          height: 1950*fem,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: Container(
            // depth0frame0wLb (15:2111)
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration (

            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    // autogroupw2njBkj (JkS1Ti6a5oTyiELwzGW2nj)
                    padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 25*fem, 11.5*fem),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 128 * fem,
                                  height: 128 * fem,
                                  color: Colors.grey[200], // Placeholder color
                                  child: Image.network(
                                    profileImagePathFromBackend,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(20*fem, 5*fem, 0*fem, 15*fem),
                                // depth4frame1YUo (15:2131)
                                width: 200*fem,
                                height: 130*fem,
                                child: Column(  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // FutureBuilder to fetch and display name
                                    FutureBuilder<String>(
                                      future: fetchName(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else {
                                          return Text(
                                            snapshot.data!,
                                            style: TextStyle(
                                              fontSize: 22 * ffem,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xff1c0c11),
                                            ),
                                          );
                                        }
                                      },
                                    ),


                                    // FutureBuilder to fetch and display role (e.g., Artist)
                                    FutureBuilder<String>(
                                      future: fetchRole(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else {
                                          return Text(
                                            snapshot.data!,
                                            style: TextStyle(
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff964f66),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),

                                    // FutureBuilder to fetch and display ratings
                                    FutureBuilder<String>(
                                      future: fetchRatings(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Row(
                                            children: [
                                              Text(
                                                'Rating: ', // Static text
                                                style: TextStyle(
                                                  fontSize: 16 * ffem,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff1c0c11),
                                                ),
                                              ),
                                              Text(
                                                snapshot.data!,
                                                style: TextStyle(
                                                  fontSize: 16 * ffem,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff1c0c11),
                                                ),
                                              ),
                                            ],
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error fetching ratings data',
                                            style: TextStyle(
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red, // Error text color
                                            ),
                                          );
                                        } else {
                                          return SizedBox(); // Return an empty container if there's no data or error
                                        }
                                      },
                                    ),

                                    SizedBox(
                                      height: 4,
                                    ),


                                    // FutureBuilder to fetch and display price per hour
                                    FutureBuilder<String>(
                                      future: fetchPrice(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Row(
                                            children: [
                                              Text(
                                                'Price Per Hour:₹', // Static text
                                                style: TextStyle(
                                                  fontSize: 16 * ffem,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff1c0c11),
                                                ),
                                              ),
                                              Text(
                                                snapshot.data!,
                                                style: TextStyle(
                                                  fontSize: 16 * ffem,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff1c0c11),
                                                ),
                                              ),
                                            ],
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error fetching price data',
                                            style: TextStyle(
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red, // Error text color
                                            ),
                                          );
                                        } else {
                                          return SizedBox(); // Return an empty container if there's no data or error
                                        }
                                      },
                                    ),


                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>booking_artist()));
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
                                'Book Artist',
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
                        Container(

                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                          child: Text(
                            'About',
                            style: SafeGoogleFont (
                              'Be Vietnam Pro',
                              fontSize: 22*ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.25*ffem/fem,
                              letterSpacing: -0.3300000131*fem,
                              color: Color(0xff1c0c11),
                            ),
                          ),
                        ),
                        Container(

                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 28*fem),
                          width: 2222*fem,
                          height: 100,
                          child: FutureBuilder<String>(
                            future: fetchAboutText(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(); // Return an empty container while waiting for data
                              } else if (snapshot.hasData) {
                                return Container(
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 28*fem),
                                  width: 2222*fem,
                                  height: 100,
                                  child: Text(
                                    snapshot.data!,
                                    style: TextStyle(
                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5*ffem/fem,
                                      color: Color(0xff1c0c11),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error fetching about data',
                                  style: TextStyle(
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red, // Error text color
                                  ),
                                );
                              } else {
                                return SizedBox(); // Return an empty container if there's no data or error
                              }
                            },
                          ),


                        ),
                        Text(
                          // audiosamplesxKZ (15:2148)
                          'Audio Sample',
                          style: SafeGoogleFont (
                            'Be Vietnam Pro',
                            fontSize: 22*ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.25*ffem/fem,
                            letterSpacing: -0.3300000131*fem,
                            color: Color(0xff1c0c11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // depth1frame55uy (15:2149)
                    width: double.infinity,
                    height: 80*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                    ),
                    child: Container(
                      // depth2frame024X (15:2150)
                      padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration (
                        color: Color(0xfff2e8ea),
                        borderRadius: BorderRadius.circular(12*fem),
                      ),
                      child: Container(
                        // depth3frame0MMh (15:2151)
                        width: double.infinity,
                        height: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // depth4frame0JGw (15:2152)
                              width: 56*fem,
                              height: 56*fem,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8*fem),
                                child: Image.asset(
                                  'assets/page-1/images/depth-4-frame-0-bao.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(16*fem, 7.5*fem, 0*fem, 7.5*fem),
                              height: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // depth4frame2v3R (15:2153)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                    width: 230*fem,
                                    height: double.infinity,
                                    child: Container(
                                      width: 270*fem,
                                      height: 20*fem,
                                      child: Text(
                                        'Nature Inspiration',
                                        style: SafeGoogleFont (
                                          'Be Vietnam Pro',
                                          fontSize: 17*ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25*ffem/fem,
                                          color: Color(0xff1c0c11),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // depth4frame3A6B (15:2160)
                                    width: 40*fem,
                                    height: 40*fem,
                                    child: Image.asset(
                                      'assets/page-1/images/depth-4-frame-3-oFu.png',
                                      width: 40*fem,
                                      height: 40*fem,
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
                  Container(
                    margin: EdgeInsets.fromLTRB(16 * fem, 30, 16 * fem, 0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 22 * ffem,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1c0c11),
                          ),
                        ),
                        SizedBox(height: 12 * fem),
                        // GridView builder for the gallery
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: imagePathsFromBackend.length , // Total count including placeholders
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12 * fem,
                            crossAxisSpacing: 12 * fem,
                            childAspectRatio: 1, // Aspect ratio of each grid item
                          ),
                          itemBuilder: (context, index) {
                            if (index < imagePathsFromBackend.length) {
                              // If index is within the number of actual images
                              return GestureDetector(
                                onTap: () {
                                  // Navigate to fullscreen view
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenView(
                                        imagePath: imagePathsFromBackend[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12 * fem),
                                    color: Colors.grey[200], // Placeholder color
                                  ),
                                ),
                              );
                            } else {
                              // If index exceeds actual images, return empty containers
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                  color: Colors.grey[200], // Placeholder color
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),



                  Container(
                    // autogroupcvhmtnB (JkS2cgAzEk6pkAMGDjcvHm)
                    padding: EdgeInsets.fromLTRB(16*fem, 40*fem, 16*fem, 11.5*fem),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // specialmessageforthehost2dV (15:2210)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 23.5*fem),
                          child: Text(
                            'Special Message for the Host',
                            style: SafeGoogleFont (
                              'Epilogue',
                              fontSize: 22*ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.25*ffem/fem,
                              letterSpacing: -0.3300000131*fem,
                              color: Color(0xff1c0c11),
                            ),
                          ),
                        ),
                        Container(
                          // depth5frame06dM (15:2215)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 32*fem),

                          width: double.infinity,
                          height: 144*fem,

                          child:FutureBuilder<String>(
                            future: fetchSpecialMessage(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // While waiting for data, return an empty container with the same styling
                                return Container(
                                  // Same dimensions and border color as the original container
                                  width: double.infinity,
                                  height: 144 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xffe8d1d6)),
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(12 * fem),
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                // If data is available, display the fetched text inside the container
                                return Container(
                                  // Same dimensions and border color as the original container
                                  width: double.infinity,
                                  height: 144 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xffe8d1d6)),
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(12 * fem),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16 * fem), // Adjust padding as needed
                                    child: Text(
                                      snapshot.data!,
                                      style: TextStyle(
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff964f66),
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                // If there's an error, display an error message
                                return Text(
                                  'Error fetching special message',
                                  style: TextStyle(
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red, // Error text color
                                  ),
                                );
                              } else {
                                return SizedBox(); // Return an empty container if there's no data or error
                              }
                            },
                          )

                        ),
                        Text(
                          // reviewsZ19 (15:2222)
                          'Reviews',
                          style: SafeGoogleFont (
                            'Epilogue',
                            fontSize: 22*ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.25*ffem/fem,
                            letterSpacing: -0.3300000131*fem,
                            color: Color(0xff1c0c11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // depth1frame15grT (15:2223)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 14*fem),
                    padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 16*fem, 1*fem),
                    width: double.infinity,
                    height: 209*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 45),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>booking_artist()));
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
                          'Book Artist',
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
// Fullscreen view for images
class FullScreenView extends StatelessWidget {
  final String imagePath;

  FullScreenView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate back when tapped
            Navigator.pop(context);
          },
          child: Image.network(imagePath), // Use Image.network for network images
        ),
      ),
    );
  }
}