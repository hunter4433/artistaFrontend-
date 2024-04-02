import 'package:flutter/material.dart';
import 'package:test1/page-1/artist_inbox.dart';
import 'package:test1/page-1/booked_artist.dart';
import 'package:test1/page-1/dmeo.dart';
import 'package:test1/page-1/page0.3_booking.dart';
import 'package:test1/page-1/page_0.3_artist_home.dart';
import 'package:test1/page-1/search.dart';
import 'package:test1/page-1/settings.dart';


class BottomNavart extends StatefulWidget {
  @override
  State<BottomNavart> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNavart> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // Replace with your actual pages/widgets
    artist_home(), // Example, replace with your Home page
    artist_inbox(),
    bookingDetails(),
    setting(),// Example, replace with your Search page
    // Add more pages for Bookings and Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black, // Set the color for the selected item
        unselectedItemColor: Color(0xFFA63B5E), // Set the color for unselected items
        showSelectedLabels: true, // Show labels for the selected item
        showUnselectedLabels: true, // Show labels for unselected items
        type: BottomNavigationBarType.fixed, // Disable animation and keep the spacing even
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/page-1/images/depth-4-frame-0-btb.png', width: 24, height: 24), // Replace 'assets/home_icon.png' with your actual asset path
            activeIcon: Icon(Icons.home_filled), // Replace 'assets/home_icon_active.png' with your actual asset path
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline_outlined),
            activeIcon: Icon(Icons.mail_outline_outlined),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/page-1/images/depth-4-frame-0-Kvf.png', width: 24, height: 24),
            activeIcon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
