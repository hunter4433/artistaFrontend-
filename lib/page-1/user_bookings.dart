import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test1/page-1/page_0.3_artist_home.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../utils.dart';
import 'booked_artist.dart';


bool hasCalledApi = false;
Map<String, List<dynamic>>? _cachedData;  // Cache for storing fetched data

class UserBookings extends StatefulWidget {
  String? isteam;

  UserBookings({this.isteam});

  @override
  _UserBookingsState createState() => _UserBookingsState();
}

class _UserBookingsState extends State<UserBookings> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  // List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  String? phone_number;
  bool isCacheLoaded = false;  // Cache flag

  // Fetch artist bookings and cache the data
  Future<bool> fetchArtistBooking(int artistId) async {
    String apiUrl;
    if (widget.isteam == 'true') {
      apiUrl = '${Config().apiDomain}/featured/team/$artistId';
    } else {
      apiUrl = '${Config().apiDomain}/featured/artist_info/$artistId';
    }

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> userDataList = json.decode(response.body);

        if (mounted) {
          for (var userData in userDataList) {
            phone_number = userData['phone_number'] ?? '';
          }
        }

        return true;
      } else {
        print('Failed to fetch user information. Status code: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error fetching user information: $e');
      return false;
    }
  }

  // Function to initiate a phone call
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> _loadBookings({bool forceReload = false}) async {
    if (!forceReload && isCacheLoaded && _cachedData != null) {
      // Use cached data if already loaded
      setState(() {
        isLoading = false;
      });
      return;
    }

    Future<String?> _getUser_id() async {
      return await storage.read(key: 'user_id');
    }

    String? id = await _getUser_id();
    print(id);

    final response = await http.get(Uri.parse('${Config().apiDomain}/user/bookings/$id'));

    if (response.statusCode == 200) {
      List<dynamic> decodedList = json.decode(response.body);
      // Cache the bookings data
      _cachedData = {
        'bookings': decodedList.map((item) => Map<String, dynamic>.from(item)).toList(),
      };

      // Set cache loaded flag
      isCacheLoaded = true;

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> _getUser_id() async {
    return await storage.read(key: 'user_id');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!hasCalledApi) {
      _loadBookings();  // Fetch the bookings only the first time
      hasCalledApi = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("App lifecycle state changed: $state");
    if (state == AppLifecycleState.detached) {
      // Reset the cache when the app is closed
      hasCalledApi = false;
      _cachedData = null;  // Clear cached data on app close
    }
  }

  @override
  bool get wantKeepAlive => true;  // Keeps the state alive

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);  // Unregister the observer
    super.dispose();
  }




  Widget _buildRequestCard(String Category, String booking_date, String Time, int booking_id, int artist_id, int index) {
      double baseWidth = 390;
      final bookings = _cachedData?['bookings'] ?? [];
      double fem = MediaQuery
          .of(context)
          .size
          .width / baseWidth;
      double ffem = fem * 0.97;

      final booking = bookings[index];
      final status = booking['status']; // Get the status from the booking object
      double progress = 0.0;

      // Set progress based on booking status
      if (status == 0) {
        progress = 0.33; // Booking Initiated
      } else if (status == 1) {
        progress = 0.66; // Artist Response accepted
      } else if (status == 2) {
        progress = 0.0; // Event rejected by artist
      } else if (status == 3) {
        progress = 0.0; // Rejected, no progress
      }

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                Booked(BookingId: booking_id.toString(), artistId: artist_id.toString(), isteam: widget.isteam)),
          );
        },
        child: Stack(
          children: [
            Card(
              color: Color(0xFF292938),
              margin: EdgeInsets.fromLTRB(5, 0, 5, 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(23, 16, 25, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking for $Category',
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('At:  $Time',
                      style: GoogleFonts.epilogue(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFFB4B4DF)
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('On Date:  $booking_date,',
                      style: GoogleFonts.epilogue(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFFB4B4DF)
                      ),
                    ),
                    SizedBox(height: 16),
                    Stack(
                      children: [
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[800],
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe5195e)),
                          minHeight: 8,
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * progress - 30,
                          top: -4,
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Initiated',
                          style: GoogleFonts.epilogue(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Artist Response',
                          style: GoogleFonts.epilogue(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Completion',
                          style: GoogleFonts.epilogue(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right:3),
                          child: ElevatedButton(
                            onPressed: () async {
                              bool wait = await fetchArtistBooking(artist_id);
                              if (wait) {
                                _makePhoneCall(phone_number ?? '') ;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12 * fem),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 6.5 * fem,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Call Artist',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 16 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5 * ffem / fem,
                                  letterSpacing: 0.2399999946 * fem,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 18, // Adjust the distance from the top of the card
              right: 10, // Adjust the distance from the right of the card
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensures that the AutomaticKeepAliveClientMixin works
    final bookings = _cachedData?['bookings'] ?? [];

    bookings.sort((a, b) {
      DateTime createdAtA = DateTime.parse(a['created_at']);
      DateTime createdAtB = DateTime.parse(b['created_at']);
      return createdAtB.compareTo(createdAtA); // Descending order
    });

    return Scaffold(
      backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Booking Requests',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color(0xFF121217),
      ),
      body: bookings.isEmpty
          ? Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Text(
          'No bookings done yet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          final idToUse = booking['artist_id'] ?? booking['team_id'];
          widget.isteam = (booking['team_id'] != '0' && booking['team_id'] != null) ? 'true' : 'false';

          return _buildRequestCard(
            booking['category'],
            booking['booking_date'],
            booking['booked_from'],
            booking['id'],
            idToUse,
            index,
          );
        },
      ),
    );
  }
}