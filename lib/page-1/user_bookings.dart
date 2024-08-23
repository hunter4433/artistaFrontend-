import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test1/page-1/page_0.3_artist_home.dart';
import '../config.dart';
import 'booked_artist.dart';




class UserBookings extends StatefulWidget {
  final String? newBookingTitle;
  final String? newBookingDateTime;

  UserBookings({this.newBookingTitle, this.newBookingDateTime, required Map<String, dynamic> data});

  @override
  _UserBookingsState createState() => _UserBookingsState();
}

class _UserBookingsState extends State<UserBookings> {

  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  String? bookingsString;
  String? fcmToken;


  Future<void> _loadBookings() async {

    // String? id = await _getArtist_id();
    Future<String?> _getUser_id() async {
      return await storage.read(key: 'user_id'); // Assuming you stored the token with key 'token'
    }

     String? id = await _getUser_id();
    print(id);

    final response = await http.get(Uri.parse('${Config().apiDomain}/user/bookings/$id'));

    if (response.statusCode == 200) {
      List<dynamic> decodedList = json.decode(response.body);
      bookings = decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
      print('bookings are :$bookings ');
      // // Define the date format for parsing and formatting
      // DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'");
      // DateFormat outputDateFormat = DateFormat('yyyy-MM-dd');
      // DateFormat outputTimeFormat = DateFormat('HH:mm:ss');

      // for (var booking in bookings) {
      //   DateTime createdAt = inputFormat.parse(booking['created_at']!);
      //   String formattedDate = outputDateFormat.format(createdAt);
      //   String formattedTime = outputTimeFormat.format(createdAt);
      //
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

  // List to keep track of rejected status for each booking
  List<bool> rejectedStatus = [];

  @override
  void initState() {
    super.initState();
    _initializeBookings();
  }
  Future<void> _initializeBookings() async {
    await _loadBookings();

    // Ensure the UI updates after bookings are loaded
    setState(() {
      // Initialize rejected status list with false values
      rejectedStatus = List<bool>.filled(bookings.length, false);
    });
  }


  @override
  Widget build(BuildContext context) {
    bookings.sort((a, b) {
      DateTime createdAtA = DateTime.parse(a['created_at']);
      DateTime createdAtB = DateTime.parse(b['created_at']);
      return createdAtB.compareTo(createdAtA); // Descending order
    });

    return Scaffold(
      backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: Color(0xFF121217),
        title: Text(
          'Booking Requests',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: bookings.isEmpty
          ? Center(
        child: Text(
          'No bookings done yet',
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
            booking['category'],
            booking['booking_date'],
            booking['booked_from'],
            booking['id'],
            booking['artist_id'],
            index,
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(String Category, String booking_date, String Time, int booking_id, int artist_id, int index) {
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
          MaterialPageRoute(builder: (context) => Booked(BookingId: booking_id.toString(), artistId : artist_id.toString())),
        );
      },
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
                    'Artist Booked for $Category',
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    booking_date,
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF9494C7),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Time,
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF9494C7),
                    ),
                  ),
                  SizedBox(height: 16),
                  Stack(
                    children: [
                      // Progress Bar
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[800],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 8,
                      ),
                      // End Indicator
                      Positioned(
                        left: MediaQuery.of(context).size.width * progress - 25, // Positioning the indicator
                        top: -4,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.green,
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Labels for the progress bar points
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Booking Initiated',
                        style: GoogleFonts.epilogue(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Artist Response',
                        style: GoogleFonts.epilogue(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Event Completion',
                        style: GoogleFonts.epilogue(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (status == 3) // Check the status from the backend
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Rejected',
                          style: GoogleFonts.epilogue(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              booking['status'] = 0;
                            });
                            cancelBooking(context ,booking_id,'0');
                            fetchArtist(context,artist_id , false );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Color(0xFF340539),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 9.5),
                          ),
                          child: Center(
                            child: Text(
                              'Undo',
                              style: GoogleFonts.epilogue(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          booking['status'] = 3; // Mark as rejected
                          _showCancelConfirmationDialog(context, booking_id, artist_id);
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xFF340539),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 9.5),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel Booking',
                          style: GoogleFonts.epilogue(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 18,
            right: 8,
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



  void _showCancelConfirmationDialog(BuildContext context,int booking_id, int artist_id)  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Booking'),
          content: Text('Are you sure you want to cancel the booking?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: ()async {
                Navigator.of(context).pop(); // Close the dialog
                bool wait= await cancelBooking(context ,booking_id,'3'); // Call the cancel booking function
                if (wait){
                  fetchArtist(context,artist_id , true );
                }else{
                  print('error occured while fecthing user');
                }


              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future <void> fetchArtist(BuildContext context,int artist_id, bool status ) async{
    // Initialize API URLs for different kinds
    print(artist_id);


    String apiUrl = '${Config().baseDomain}/artist/info/$artist_id';

    try {
      var uri = Uri.parse(apiUrl);
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
        // body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Artist fetched successfully: ${response.body}');
        Map<String, dynamic> artist= json.decode(response.body);

        fcmToken=artist['data']['attributes']['fcm_token'];
        // user_phonenumber=user['phone_number'];
        sendNotification( context,fcmToken!, status);
        print('token is :$fcmToken');


      } else {
        print('user fetch unsuccessful Status code: ${response.body}');

      }
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification has been sent to the artist'),
          backgroundColor: Colors.green,
        ),
      );
    }

  }


  Future<void> sendNotification(BuildContext context, String fcm_token, bool status) async {
    if (!mounted) return; // Check if the widget is still mounted

    // Initialize API URLs for different kinds
    String apiUrl = '${Config().baseDomain}/send-notification';

    Map<String, dynamic> requestBody = {
      'type': 'artist',
      'fcm_token': fcm_token,
      'status': status,
    };

    try {
      var uri = Uri.parse(apiUrl);
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        if (status) {
          _showDialog('Delete success',
              'Your Booking has been Deleted successfully and Notification has been Sent to Artist');
        }else{
          _showDialog('Request intiated again', 'Notification has been sent to the artist again.');
        }
        print('notification sent successfully: ${response.body}');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notification unsuccessfull'),
              backgroundColor: Colors.green,
            ),
          );
        }
        print('Failed to send notification. Status code: ${response.body}');
      }
    } catch (e) {

      print('Error sending notification: $e');
    }
  }





  Future<bool> cancelBooking(BuildContext context, int booking_id, String status ) async {
    print(booking_id);
    final response = await http.patch(
      Uri.parse('${Config().baseDomain}/booking/$booking_id'),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
      },
      body: json.encode({
        'status':status,
    })

    );

    if (response.statusCode == 200) {
      // var decodedResponse = json.decode(response.body);
      // print(decodedResponse);
      print('Booking deleted successfully');
      print(response.body);
      // _loadBookings();
      return true;

      // Show success dialog
      // _showDialog('Success', 'Booking deleted successfully');
    } else {
      // Handle the error case
      print('Failed to update booking: ${response.body}');
      // Show error dialog
      // _showDialog('Error', 'Failed to delete booking');

    }
    return false;
  }

  void _showDialog( String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
