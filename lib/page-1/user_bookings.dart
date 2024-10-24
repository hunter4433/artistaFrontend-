import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test1/page-1/page_0.3_artist_home.dart';
import 'package:test1/page-1/review.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../utils.dart';
import 'booked_artist.dart';

bool isCacheLoaded = false;
Map<String, List<dynamic>>? cachedData;
class UserBookings extends StatefulWidget {
  String? isteam;

  UserBookings({this.isteam});

  @override
  _UserBookingsState createState() => _UserBookingsState();
}

class _UserBookingsState extends State<UserBookings> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  bool isLoading = true;

  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBookings();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _resetCache(); // Clear cache on app closure
    }
  }

  Future<void> _loadBookings({bool forceReload = false}) async {
    if (isCacheLoaded && !forceReload) {
      // Use cached data
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      String? userId = await _getUserId();
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final response = await http.get(Uri.parse('${Config().apiDomain}/user/bookings/$userId'));

      if (response.statusCode == 200) {
        final decodedList = json.decode(response.body) as List<dynamic>;
        print('bokings are $decodedList ');

        setState(() {
          cachedData = {'bookings': decodedList.map((e) => Map<String, dynamic>.from(e)).toList()};
          isCacheLoaded = true;
          isLoading = false;
        });
        print(decodedList);
      } else {
        _handleError('Failed to load bookings');
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String message) {
    setState(() {
      isLoading = false;
    });
    print('Error: $message');
  }

  Future<String?> _getUserId() async {
    return await storage.read(key: 'user_id');
  }

  void _resetCache() {
    cachedData = null;
    isCacheLoaded = false;
  }

  @override
  bool get wantKeepAlive => true; // Keep state alive

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }


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
            phoneNumber = userData['phone_number'] ?? '';
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

  Widget _buildRequestCard(String Category, String booking_date, String Time,
      int booking_id, int artist_id, int index) {
    double baseWidth = 390;
    final bookings = cachedData?['bookings'] ?? [];
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
              Booked(BookingId: booking_id.toString(),
                  artistId: artist_id.toString(),
                  isteam: widget.isteam)),
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
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xffe5195e)),
                        minHeight: 8,
                      ),
// <<<<<<< HEAD
                      Positioned(
                        left: MediaQuery
                            .of(context)
                            .size
                            .width * progress - 30,
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
              status != 1
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: ElevatedButton(
                      onPressed: () async {
                        bool wait = await fetchArtistBooking(artist_id);
                        if (wait) {
                          _makePhoneCall(phoneNumber ?? '');
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
                            letterSpacing: 0.24 * fem,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the review page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewPage(artistId: artist_id.toString() , isteam: widget.isteam),
                          ),
                        );
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
                          'Write a Review',
                          style: SafeGoogleFont(
                            'Be Vietnam Pro',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.5 * ffem / fem,
                            letterSpacing: 0.24 * fem,
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

  Widget build(BuildContext context) {
    super.build(context); // Ensure AutomaticKeepAliveClientMixin works

    final bookings = cachedData?['bookings'] ?? [];

    // Sort bookings by creation date in descending order
    bookings.sort((a, b) {
      DateTime createdAtA = DateTime.parse(a['created_at']);
      DateTime createdAtB = DateTime.parse(b['created_at']);
      return createdAtB.compareTo(createdAtA);
    });

    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Bookings',
            style: TextStyle(
// <<<<<<< HEAD
//                 fontSize: 22, fontWeight: FontWeight.w400, color: Colors.white),
// =======
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
// >>>>>>> c29e89df1aac051be8cea2d6749ef204c90acc8e
          ),
        ),
        backgroundColor: const Color(0xFF121217),
      ),
// <<<<<<< HEAD
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : bookings.isEmpty
//           ? const Center(
//         child: Text(
//           'No bookings done yet',
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//       )
// =======
      body: bookings.isEmpty
          ? Center(
          child: isLoading
        ? CircularProgressIndicator()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/page-1/images/booking.png', // Replace with your image path
                height: 220, // Adjust height as needed
              ),
              SizedBox(height: 10), // Add spacing between the image and text
              Text(
                'You haven’t made any bookings yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),)
// >>>>>>> c29e89df1aac051be8cea2d6749ef204c90acc8e
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          final idToUse = booking['artist_id'] ?? booking['team_id'];
          widget.isteam =
          (booking['team_id'] != '0' && booking['team_id'] != null)
              ? 'true'
              : 'false';

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