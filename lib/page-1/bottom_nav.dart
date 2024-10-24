import 'package:flutter/material.dart';
import 'package:test1/page-1/booked_artist.dart';
import 'package:test1/page-1/dmeo.dart';
import 'package:test1/page-1/search.dart';
import 'package:test1/page-1/settings.dart';
import 'package:test1/page-1/user_bookings.dart';
import 'package:video_player/video_player.dart';  // Import the video player package

class BottomNav extends StatefulWidget {
  final int initialPageIndex;
  final String? newBookingTitle;
  final String? newBookingDateTime;
  final String? isteam;

  BottomNav({
    this.isteam,
    this.initialPageIndex = 0,
    this.newBookingTitle,
    this.newBookingDateTime,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with WidgetsBindingObserver {
  int _currentIndex = 0;
  late VideoPlayerController _videoController; // Video controller

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle events

    // Initialize video controller
    _videoController = VideoPlayerController.asset('assets/page-1/images/search.mp4')
      ..initialize().then((_) {
        setState(() {}); // Update UI once video is ready
      });
    _videoController.setVolume(0); // Optional: Mute the video
    _videoController.setLooping(true); // Loop video playback

    _currentIndex = widget.initialPageIndex;

    // Pass the video controller to the Search page
    _pages = [
      Home_user(),
      Search(controller: _videoController), // Use the controller in Search
      UserBookings(isteam: widget.isteam),
      Setting(),
    ];
  }

  // Handle lifecycle changes (pause/play video when app is paused/resumed)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _videoController.play();
    } else if (state == AppLifecycleState.paused) {
      _videoController.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Stop observing lifecycle changes
    _videoController.dispose(); // Dispose the video controller
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return false; // Prevent back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF292938),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // Play or pause video based on the selected tab
            if (index == 1) {
              _videoController.play(); // Play video when on Search tab
            } else {
              _videoController.pause(); // Pause video when leaving Search tab
            }
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFF9E9EB8),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}