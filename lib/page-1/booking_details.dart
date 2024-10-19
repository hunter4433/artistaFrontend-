import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/page_0.3_artist_home.dart';

import '../config.dart';

class EventDetails extends StatefulWidget {
  final String bookingId;
  final String  artistId;

  EventDetails({required this.bookingId, required this.artistId});

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String? location;
  String? Category;
  String? TotalAmount;
  String? SpecialRequest;
  String? BookingDate;
  String? booked_from;
  String? booked_to;
  int? artist_id;
  String? amount;
  String? duration;
  String? user_id;
  String? number ;
  late Future<void> fetchFuture;

  @override
  void initState() {
    super.initState();
    fetchFuture = fetchDetails();
    // fetchBookingDetails(
    //     widget.bookingId); // Fetch profile data when screen initializes
    // fetchArtist(widget.artistId);
  }

  Future<String?> _getid() async {
    return await storage.read(
        key: 'artist_id'); // Assuming you stored the token with key 'id'
  }

  Future<String?> _getTeamid() async {
    return await storage.read(
        key: 'team_id'); // Assuming you stored the token with key 'id'
  }

  Future<String?> _getKind() async {
    return await storage.read(
        key: 'selected_value'); // Assuming you stored the token with key 'selected_value'
  }

  Future<void> fetchDetails() async {
    await Future.wait([
      fetchArtist(widget.artistId),
      fetchBookingDetails(widget.bookingId),
    ]);
  }

  Future<void> fetchArtist(String artist_id) async {
    String? team_id = await _getTeamid();
    String? kind = await _getKind();

    String apiUrl;
    if (kind == 'solo_artist') {
      apiUrl = '${Config().apiDomain}/artist/info/$artist_id';
    } else if (kind == 'team') {
      apiUrl = '${Config().apiDomain}/artist/team_info/$team_id';
    } else {
      return;
    }

    try {
      var uri = Uri.parse(apiUrl);
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> user = json.decode(response.body);
        if (mounted) {
          setState(() {
            amount = (user['data']['attributes']['price_per_hour']).toString();
          });
        }
      } else {
        print('user fetch unsuccessful Status code: ${response.body}');
      }
    } catch (e) {
      print('Error fetching artist: $e');
    }
  }

  Future<void> fetchBookingDetails(String booking_id) async {
    String apiUrl = '${Config().apiDomain}/booking/$booking_id';

    try {
      var uri = Uri.parse(apiUrl);
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> booking = json.decode(response.body);
        print(booking);
        if (mounted) {
          setState(() {
            location = booking['location'];
            BookingDate = booking['booking_date'];
            Category = booking['category'];
            SpecialRequest = booking['special_request'];
            duration = booking['duration'];
            booked_from=booking['booked_from'];
            booked_to=booking['booked_to'];
            user_id=booking['user_id'].toString();

          });
        }
      } else {
        print('Booking fetch unsuccessful: ${response.body}');
      }
    } catch (e) {
      print('Error fetching booking details: $e');
    }
  }

  String calculateTotalAmount(String duration, String pricePerHour) {
    // Extract hours and minutes from the duration string
    List<String> durationParts = duration.split(' ');

    int hours = 0;
    int minutes = 0;

    for (int i = 0; i < durationParts.length; i++) {
      if (durationParts[i] == 'hours') {
        hours = int.parse(durationParts[i - 1]);
      } else if (durationParts[i] == 'minutes') {
        minutes = int.parse(durationParts[i - 1]);
      }
    }

    // Convert total duration to hours as a double
    double totalHours = hours + (minutes / 60.0);

    // Parse the price per hour string
    double price = double.parse(pricePerHour);

    // Calculate the total amount
    double totalAmount = totalHours * price;

    // Format the total amount to a string with 2 decimal places
    return totalAmount.toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Center(
            child: Text(
              'Event Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFF121217),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16.0),
        //     child: ElevatedButton(
        //       onPressed: () async {
        //         await generateOtp(context); // Call OTP generation function
        //         showOtpDialog(context); // Show OTP dialog
        //       },
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.blue,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8.0),
        //         ),
        //       ),
        //       child: Text(
        //         'Generate OTP',
        //         style: TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w600,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: FutureBuilder(
        future: fetchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  SizedBox(height: 15),
                  Text(
                    'Congrats, you’ve received a booking!',
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w400,
                      fontSize: 21,
                      height: 1.3,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(height: 23),
                  Text(
                    'On Date:   $BookingDate',
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      height: 1.5,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'From:   $booked_from    To:    $booked_to ',
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      height: 1.5,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Duration:   $duration',
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      height: 1.5,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildInfoSection(
                    title: 'Offer Amount',
                    info: amount?.toString() ?? 'N/A',
                  ),
                  _buildInfoSection(
                    title: 'Type of Booking',
                    info: Category ?? 'N/A',
                  ),
                  _buildInfoSection(
                    title: 'Audience Size',
                    info: '500 people',
                  ),
                  _buildInfoSection(
                    title: 'Location',
                    info: location ?? 'N/A',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Special Requests',
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      height: 1.5,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    SpecialRequest ?? 'N/A',
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      height: 1.5,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

// Function to generate OTP
  Future<void> generateOtp(BuildContext context) async {
    // Your OTP generation logic here
    final String apiUrl = '${Config().apiDomain}/sms/user/10'; // Replace with the correct API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Accept': 'application/json',
        'Content-Type': 'application/json',},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
         number = responseData['number']; // Display only in testing, remove in production
        _showSnackBar('OTP sent successfully! ');
      } else {
        final errorMessage = jsonDecode(response.body)['response']['message'];
        _showSnackBar(errorMessage ?? 'Failed to send OTP');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  // Function to display a Snackbar with the provided message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

/// Function to show OTP dialog
  void showOtpDialog(BuildContext context) {
    TextEditingController otpController = TextEditingController();
    bool isVerified = false; // Track verification status

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing without user action
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Text('Enter OTP'),
                  SizedBox(width: 10),
                  if (isVerified) // Show tick mark if verified
                    Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              content: TextField(
                controller: otpController,
                decoration: InputDecoration(
                  hintText: 'Enter OTP sent to the user',
                ),
                keyboardType: TextInputType.number,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Handle OTP verification logic
                    String enteredOtp = otpController.text;

                    print('Entered OTP: $enteredOtp');

                    bool verify = await _verifyOTP(enteredOtp);

                    if (verify) {
                      setState(() {
                        isVerified = true; // Update verification status
                      });

                      // Optionally close dialog after showing the tick for a short period
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid OTP!')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _verifyOTP(String otpCode) async {
    // Your backend endpoint that verifies the OTP via Twilio
    final String url = '${Config().apiDomain}/verify/user';
    // String? userType = await _getSelectedValue();
    // if (phoneNumber.startsWith('+91')) {
    //   phoneNumber = phoneNumber.substring(3).trim();
    // }
    // print(phoneNumber);

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json'},
      body: jsonEncode({'user_id': '10', 'otp': otpCode}),
    );

    if (response.statusCode == 200) {
      print('OTP verified successfully');
      // Navigate to the relevant home page

      return true;
    } else {
      print('Failed to verify OTP: ${response.body}');
      return false;
      _showSnackBar('Invalid OTP. Please try again.');
    }
    return false;
  }


  Widget _buildInfoSection({required String title, required String info}) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      padding: EdgeInsets.symmetric(vertical: 13.5),
      color: Color(0xFF121217),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              height: 1.5,
              color: Color(0xFFFFFFFF),
            ),
          ),
          SizedBox(height: 4),
          Text(
            info,
            style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              height: 1.5,
              color: Color(0xFF9494C7),
            ),
          ),
        ],
      ),
    );
  }
}


