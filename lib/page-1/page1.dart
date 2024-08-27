import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/phone_varification.dart';

class Scene1 extends StatefulWidget {
  const Scene1({Key? key}) : super(key: key);

  @override
  _Scene1State createState() => _Scene1State();
}

class _Scene1State extends State<Scene1> {
  late VideoPlayerController _controller;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/page-1/images/6f1ff42d57f59d5c0b032de4753cf734.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0); // Mute the video
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void saveSelectedValue(String value) async {
    await storage.write(key: 'selected_value', value: value);
  }

  Future<void> navigateToNextPage(Widget nextPage) async {
    _controller.pause();
    await Future.delayed(Duration(milliseconds: 300));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: Stack(
        children: [
          // Video Background
          SizedBox.expand(
            child: _controller.value.isInitialized
                ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
                : Container(
              color: Colors.black,
            ),
          ),

          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.6), // Semi-transparent film
          ),

          // Content over the overlay
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0 * fem, 0, 50 * fem),
                  child: Text(
                    'Start Your Journey With Us.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 30 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.25 * ffem / fem,
                      letterSpacing: -0.7 * fem,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          saveSelectedValue('hire');
                          navigateToNextPage(PhoneNumberInputScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffe5195e),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7 * fem),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * fem,
                            vertical: 12 * fem,
                          ),
                          minimumSize: Size(double.infinity, 14 * fem),
                        ),
                        child: Text(
                          'Hire Artist',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.5 * ffem / fem,
                            letterSpacing: 0.74 * fem,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 38 * fem),
                      Container(
                        child: Text(
                          'Register as an Artist',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 22 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5 * ffem / fem,
                            letterSpacing: 0.74 * fem,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 14 * fem),
                      ElevatedButton(
                        onPressed: () {
                          saveSelectedValue('solo_artist');
                          navigateToNextPage(PhoneNumberInputScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffe5195e),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7 * fem),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * fem,
                            vertical: 12 * fem,
                          ),
                          minimumSize: Size(double.infinity, 14 * fem),
                        ),
                        child: Text(
                          'I\'m a Solo Artist',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.5 * ffem / fem,
                            letterSpacing: 0.74 * fem,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 14 * fem),
                      ElevatedButton(
                        onPressed: () {
                          saveSelectedValue('team');
                          navigateToNextPage(PhoneNumberInputScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffe5195e),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7 * fem),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * fem,
                            vertical: 12 * fem,
                          ),
                          minimumSize: Size(double.infinity, 14 * fem),
                        ),
                        child: Text(
                          'We\'re a Team of Artists',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.5 * ffem / fem,
                            letterSpacing: 0.74 * fem,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 102 * fem),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}