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
    _loadCompletedBookingsWithPaymentStatus(widget.artist_id); // Fetch profile data when screen initializes
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

  Future<void> _loadCompletedBookingsWithPaymentStatus(String artistId) async {


    String? team_id= await _getTeamid();
    String? kind = await _getKind();

    String apiUrl;
    if (kind == 'solo_artist') {
      apiUrl = '${Config().apiDomain}/payments/booking/$artistId';
    } else if (kind == 'team') {
      apiUrl = '${Config().apiDomain}/payments/booking/team/$team_id';
    } else {
      return;
    }
    // final String apiUrl = '${Config().apiDomain}/payments/booking/$artistId';

    try {
      // Send a GET request to the API
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decode the response body
        List<dynamic> decodedList = json.decode(response.body);

        // Map each item to a detailed booking object
        List<Map<String, dynamic>> bookingsWithPaymentStatus = decodedList.map((item) => Map<String, dynamic>.from(item)).toList();

        // Print the list of bookings with payment status for debugging
        print('Bookings with payment status: $bookingsWithPaymentStatus');

        // Update the state with the processed bookings
        setState(() {
          bookings = bookingsWithPaymentStatus;
          isLoading = false;
        });
      } else {
        // Handle non-200 status codes here
        setState(() {
          isLoading = false;
        });
        print('Error: Failed to load bookings with payment status');
      }
    } catch (error) {
      // Handle exceptions, such as network errors
      setState(() {
        isLoading = false;
      });
      print('Exception occurred: $error');
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





    Widget _buildRequestCard(
        String category,
        String bookingDate,
        String bookingTime,
        String location,
        String paymentStatus,
        Map<String, dynamic>? paymentDetails,
        ) {
      return GestureDetector(
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
                      'Booking Completed for $category',
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Booking Date: $bookingDate at $bookingTime',
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF9494C7),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Location: $location',
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF9494C7),
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.white38),
                    SizedBox(height: 8),
                    Text(
                      'Payment Status: $paymentStatus',
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: paymentStatus == 'Completed'
                            ? Colors.green
                            : Colors.orangeAccent,
                      ),
                    ),
                    if (paymentStatus == 'Completed' &&
                        paymentDetails != null) ...[
                      SizedBox(height: 8),
                      Text(
                        'Transaction ID: ${paymentDetails['txn_id']}',
                        style: GoogleFonts.epilogue(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF9494C7),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Amount: ₹${paymentDetails['amount']}',
                        style: GoogleFonts.epilogue(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF9494C7),
                        ),
                      ),
                    ] else
                      if (paymentStatus == 'Pending') ...[
                        SizedBox(height: 8),
                        Text(
                          'Payment Pending.It will be shortly processed to your account.',
                          style: GoogleFonts.epilogue(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

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
          ? Center(child: CircularProgressIndicator())
          : bookings.isEmpty
          ? Center(
        child: Text(
          'No Booking Event Completed Yet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildRequestCard(
            booking['category'] ?? 'N/A',
            booking['booking_date'] ?? 'N/A',
            booking['booked_from'] ?? 'N/A',
            booking['location'] ?? 'N/A',
            booking['payment_status'] ?? 'N/A',
            booking['payment_details'],
          );
        },
      ),
    );


    }

}

