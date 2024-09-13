import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/page-1/page0.3_booking.dart';
import 'package:test1/page-1/page_0.3_artist_home.dart';
import '../utils.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/page0.3_booking.dart';
import '../config.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class  payment_history extends StatefulWidget {
  late String  artist_id;
  payment_history( {required this.artist_id});
  @override
  _payment_historyState createState() => _payment_historyState();
}

class _payment_historyState extends State<payment_history>{

  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPayments(widget.artist_id); // Fetch profile data when screen initializes
  }


  // Future<String?> _getid() async {
  //   return await storage.read(key: 'artist_id'); // Assuming you stored the token with key 'id'
  // }

  Future<String?> _getTeamid() async {
    return await storage.read(key: 'team_id'); // Assuming you stored the token with key 'id'
  }

  Future<String?> _getKind() async {
    return await storage.read(key: 'selected_value'); // Assuming you stored the token with key 'selected_value'
  }

  Future<void> _loadPayments(String artist_id ) async {

    // String? id = await _getArtist_id();
    // String? id = await _getid();
    String? team_id= await _getTeamid();
    String? kind = await _getKind();

    String apiUrl;
    if (kind == 'solo_artist') {
      apiUrl = '${Config().apiDomain}/artist/payments/$artist_id';
    } else if (kind == 'team') {
      apiUrl = '${Config().apiDomain}/team/payments/$team_id';
    } else {
      return;
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> decodedList = json.decode(response.body);
      print(decodedList);
      bookings = decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
      print('payments are :$bookings ');
      // Define the date format for parsing and formatting
      // DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'");
      // DateFormat outputDateFormat = DateFormat('yyyy-MM-dd');
      // DateFormat outputTimeFormat = DateFormat('HH:mm:ss');

      // for (var booking in bookings) {
      //   DateTime createdAt = inputFormat.parse(booking['created_at']);
      //   String formattedDate = outputDateFormat.format(createdAt);
      //   String formattedTime = outputTimeFormat.format(createdAt);
      //
      //
      //
      //   print('Booking ID: ${booking['id']}');
      //   print('Created Date: $formattedDate');
      //   print('Created Time: $formattedTime');
      //   print('---');
      // }

      setState(() {
        isLoading = false;
      });
    } else {
      // Handle the error case
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // bookings.sort((a, b) {
    //   DateTime createdAtA = DateTime.parse(a['created_at']);
    //   DateTime createdAtB = DateTime.parse(b['created_at']);
    //   return createdAtB.compareTo(createdAtA); // Descending order
    // });
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: Color(0xFF121217),
        title: Text(
          'Payment History',
          style: SafeGoogleFont(
            'Be Vietnam Pro',
            fontSize: 22 * ffem,
            fontWeight: FontWeight.w700,
            height: 1.25 * ffem / fem,
            color: Color(0xffa53a5e),
          ),
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : bookings.isEmpty

          ? Center(
        child: Text(
          'No Booking Event Completed Yet ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      )
          :ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildRequestCard(
            booking['amount'],
            "booking['booking_date']",
            "booking['booked_from']",
            10,
            11,
            10,
            5,
          );
        },
      ),
    );
  }
  Widget _buildRequestCard(
      String category, String bookingDate, String BookingTime, int booking_id, int user_id,int artist_id, int index) {
    // final booking = bookings[index];
    // final status = booking['status'];

    return GestureDetector(
      // onTap: () {
      //   print('booking_id : $booking_id');
      //   String bookingId = booking_id.toString();
      //   String artistId =artist_id.toString();
      //   print(index);
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => EventDetails(bookingId: bookingId,artistId: artistId)),
      //   );
      // },
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.only(bottom: 16),
            color: Color(0xFF292938),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: Colors.black54,
            child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 30, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Completed for the  $category',
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Booking Date: $bookingDate',
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF9494C7),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'feedback:',
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF9494C7),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Rating by the Host:',
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF9494C7),
                      ),
                    ),

                  ],
                )

            ),
          ),
        ],
      ),

    );
  }

}

