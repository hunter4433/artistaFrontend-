import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
int? artist_id;
String? amount;
String? duration;

  @override
  void initState() {
    super.initState();
    fetchBookingDetails(widget.bookingId); // Fetch profile data when screen initializes
    fetchArtist(widget.artistId);
  }


Future <void> fetchArtist(String artist_id) async{
  // Initialize API URLs for different kinds
  print(artist_id);
  String? user_fcmToken;

  String apiUrl = '${Config().apiDomain}/artist/info/$artist_id';

  try {
    var uri = Uri.parse(apiUrl);
    var response = await http.get(
      uri,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      // body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // print('user fetched successfully: ${response.body}');
      Map<String, dynamic> user= json.decode(response.body);

      setState(() {
      amount= user['data']['attributes']['price_per_hour'];
      });
      print(amount);

      // user_fcmToken=user['fcm_token'];
      // user_phonenumber=user['phone_number'];
      // sendNotification( context,  user_fcmToken!,status);
      // print(user_fcmToken);
      // String name= user['name'];
      // print(name);
      // print(user_fcmToken);

    } else {
      print('user fetch unsuccessful Status code: ${response.body}');

    }
  } catch (e) {
    print('Error sending notification: $e');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Notification has been sent to the artist'),
    //     backgroundColor: Colors.green,
    //   ),
    // );
  }

}


Future <void> fetchBookingDetails(String booking_id) async{
    // Initialize API URLs for different kinds
    print('hi mohit heere $booking_id');
    String? user_fcmToken;

    String apiUrl = '${Config().apiDomain}/booking/$booking_id';

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
        // print('user fetched successfully: ${response.body}');
        Map<String, dynamic> booking= json.decode(response.body);
        print( booking);

        setState(() {


        location= booking['location'];
        BookingDate= booking['booking_date'];
        Category= booking['category'];
        SpecialRequest= booking['special_request'];
        duration=booking['duration'];

        });
        print(location);
        print(duration);

        // user_fcmToken=user['fcm_token'];
        // user_phonenumber=user['phone_number'];
        // sendNotification( context,  user_fcmToken!,status);
        // print(user_fcmToken);
        // String name= user['name'];
        // print(name);
        // print(user_fcmToken);

      } else {
        print('user fetch unsuccessful Status code: ${response.body}');

      }
    } catch (e) {
      print('Error sending notification: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Notification has been sent to the artist'),
      //     backgroundColor: Colors.green,
      //   ),
      // );
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
      backgroundColor:Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: Color(0xFF121217),
        title: Text(
          'Event Details',
          style: GoogleFonts.epilogue(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            height: 1.3,
            color: Color(0xFFFFFFFF),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Text(
              'DJ set at a private party',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                height: 1.3,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 12),
            Text(
              BookingDate!,
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 16),
            _buildInfoSection(
              title: 'Location',
              info: location!,
            ),
            _buildInfoSection(
              title: 'Audience Size',
              info: '500 people',
            ),
            _buildInfoSection(
              title: 'Type',
              info: Category!,
            ),
            _buildInfoSection(
              title: 'Offer Amount',
              info:   TotalAmount = calculateTotalAmount(duration!, amount!),
            ),
            SizedBox(height: 20),
            Text(
              'Description',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                height: 1.3,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We\'re hosting a private party for our employees. We\'d love to have you DJ the event.',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Special Requests',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                height: 1.3,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 8),
            Text(
              SpecialRequest!,
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required String info}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 13.5),
      color: Color(0xFF121217),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.5,
              color: Color(0xFFFFFFFF),
            ),
          ),
          SizedBox(height: 4),
          Text(
            info,
            style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF9494C7),
            ),
          ),
        ],
      ),
    );
  }
}

