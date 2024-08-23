import 'package:flutter/material.dart';
import 'package:test1/page-1/booked_artist.dart';
import 'package:test1/page-1/dmeo.dart';
import 'package:test1/page-1/search.dart';
import 'package:test1/page-1/settings.dart';
import 'package:test1/page-1/user_bookings.dart';

class BottomNav extends StatefulWidget {

  final Map<String, dynamic> data;
  final int initialPageIndex;
  final String? newBookingTitle;
  final String? newBookingDateTime;

  BottomNav({
    required this.data,
    this.initialPageIndex = 0,
    this.newBookingTitle,
    this.newBookingDateTime,
  });
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  late List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialPageIndex;
    _pages=[ Home_user(),
    Search(),
    UserBookings( data: widget.data,
    newBookingTitle: widget.newBookingTitle,
    newBookingDateTime: widget.newBookingDateTime,),
    setting(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292938),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xFF9E9EB8),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor:Color(0xFF292938), // Set your desired background color here
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


