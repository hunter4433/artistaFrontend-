import 'dart:ffi';

import 'package:flutter/material.dart';
import '../config.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';



class Booked extends StatefulWidget {
  final String BookingId;
  final String artistId;
  Booked({required this.BookingId, required this.artistId});

  @override
  _BookedState createState() => _BookedState();
}

class _BookedState extends State<Booked> {
  // Fetched text from backend

  String? name;
  String? price;
  String? image;
  String? phone_number;
   String? dateText ;
  String? timeText ;
   String? durationText ;
 String? priceText;
String? locationText ;
int? hour;
int? minute;
String? fcm_token;
String? totalprice;
   TextEditingController _locationController= TextEditingController();
   TextEditingController _dateTextController= TextEditingController();
   TextEditingController _timeTextController= TextEditingController();
   TextEditingController _durationTextController= TextEditingController();



  final storage = FlutterSecureStorage();
  bool _isEditing = false;



  Future<String?> _getToken() async {
    return await storage.read(key: 'token'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getid() async {
    return await storage.read(key: 'id'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getbookingid() async {
    return await storage.read(key: 'booking_id'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getKind() async {
    return await storage.read(key: 'selected_value'); // Assuming you stored the token with key 'token'
  }
  @override
  void initState() {
    super.initState();
    fetchArtistBooking(widget.artistId);
    fetchBookingDetails(widget.BookingId);
    _locationController = TextEditingController(text: locationText);
    _dateTextController = TextEditingController(text: locationText);

    // // Set the initial value of the "From" controller to selectedFromTime if it's not null
    // fromTimeController.text = selectedFromTime ?? '';
    // // Set the initial value of the "To" controller to selectedToTime if it's not null
    // toTimeController.text = selectedToTime ?? '';
  }

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

  String calculateTotalAmount(String pricePerHour, int hours, int minutes) {
    // Convert total time to hours
    double totalTimeInHours = hours + (minutes / 60.0);

    // Convert pricePerHour to double
    double pricePerHourDouble = double.parse(pricePerHour);

    // Calculate the total amount
    double totalAmount = (totalTimeInHours * pricePerHourDouble) ;
    // print(totalAmount);
    String amount= totalAmount.toString();

    return amount;
  }


  Future<String?> fetchBookingDetails(String BookingId)async{
  String? token = await _getToken();
  String? booking_id = await _getbookingid();

  String apiUrl= '${Config().apiDomain}/booking/$BookingId';

  try {
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> userData = json.decode(response.body);
      print(userData);

      // Check if the widget is mounted before calling setState

      setState(() {
        _durationTextController.text = userData['duration'] ?? '';
        _locationController.text = userData['location'] ?? '';
        _dateTextController.text = userData['booking_date'] ?? '';
        _timeTextController.text = userData['booked_from'] ?? '';

      });

      // Split the string by spaces
      List<String>? parts = _durationTextController.text?.split(' ');

      // // Initialize hour and minute variables
      // int hours = 0;
      // int minutes = 0;

      // Iterate over the parts and extract the values
      for (int i = 0; i < parts!.length; i++) {
        if (parts[i] == "hour" || parts[i] == "hours") {
          hour = int.parse(parts[i - 1]) as int?;
        } else if (parts[i] == "minute" || parts[i] == "minutes") {
          minute = int.parse(parts[i - 1]) as int?;
        }
      }

      // Print the extracted values
      print('Hours: $hour');
      print('Minutes: $minute');

      totalprice=await calculateTotalAmount( price!, hour as int , minute as int );
      print(totalprice);


    }

   else {
      print('Failed to fetch user information. Status code: ${response.body}');
    }
  } catch (e) {
    print('Error fetching user information: $e');
  }
}




  Future<void> fetchArtistBooking(String artistId) async {
    // String? token = await _getToken();
    String? id = await _getid();
    // String? kind = await _getKind();
    print(id);


    String apiUrl = '${Config().apiDomain}/featured/artist_info/$artistId';

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

        // Check if the widget is mounted before calling setState
        if (mounted) {
          for (var userData in userDataList) {
            // setState(() {
            name = userData['name'] ?? '';
            price = userData['price_per_hour'] ?? '';
            image = '${Config().baseDomain}/storage/${userData['profile_photo']}' ;
            phone_number=userData['phone_number'] ?? '';
            fcm_token=userData['fcm_token']??'';
            print('token is $fcm_token');
            // });
          }
        }
      } else {
        print('Failed to fetch user information. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }

  Future<void> _saveBookingDetails() async {
print('savebooking is working');

    String apiUrl = '${Config().apiDomain}/booking/${widget.BookingId}';
Map<String, dynamic> formData={ 'booking_date': _dateTextController.text,
      'booked_from': _timeTextController.text,
      'location':_locationController.text,
      'duration': _durationTextController.text,
    };
print(formData);
    try {
      var response = await http.patch(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',

        },
        body: jsonEncode(formData),
      );
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          _isEditing = false; // Exit editing mode
        });

        // You can show a success message here
      } else {
        // Handle error
        print('error:$response.body');
      }
    } catch (e) {
      print('Error saving booking details: $e');
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   throw UnimplementedError();
  // }
  // }


  @override
  Widget build(BuildContext context) {
    //
    // final message =ModalRoute.of(context)!.settings.arguments;

    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      backgroundColor: Color(0xFF121217),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Container(
            width: double.infinity,
            height: 960 * fem,
            decoration: BoxDecoration(
              color: Color(0xFF121217),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF121217),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 16 * fem, 29 * fem),
                      width: double.infinity,
                      height: 72 * fem,
                      decoration: BoxDecoration(
                        color: Color(0xFF121217),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Booked Artist Details',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 18 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25 * ffem / fem,
                                  letterSpacing: -0.2700000107 * fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // This SizedBox ensures that the title is centered
                          // by taking the same width as the back button
                          SizedBox(width: 48),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                      padding: EdgeInsets.fromLTRB(1 * fem, 8 * fem, 1 * fem, 8 * fem),
                      width: 540 * fem,
                      height: 160 * fem,
                      color: Color(0xFF121217),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10 * fem, 0 * fem, 15 * fem, 0 * fem),
                            width: 100 * fem,
                            height: 140 * fem,
                            child: FutureBuilder<void>(
                              future: fetchArtistBooking(widget.BookingId), // Call fetchArtistBooking instead of fetchImage
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Container(color: Colors.grey); // Placeholder until image is loaded
                                } else if (snapshot.hasError) {
                                  return Container(color: Colors.red); // Placeholder for error
                                } else {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10 * fem), // Set your desired border radius
                                    child: Image.network(
                                      image ?? '', // Display the fetched image
                                      fit: BoxFit.cover, // Ensure the image covers the container
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10 * fem, 1 * fem, 5 * fem, 8 * fem),
                            width: 260 * fem,
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Artist Name: ', // Hardcoded name field
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8 * fem), // Add some space between the hardcoded and fetched name
                                    FutureBuilder<void>(
                                      future: fetchArtistBooking(widget.BookingId), // Function to fetch text from backend
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Container(); // Placeholder until text is loaded
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error loading text', // Placeholder for error
                                            style: SafeGoogleFont(
                                              'Be Vietnam Pro',
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5 * ffem / fem,
                                              color: Colors.white,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            name ?? '', // Display the fetched text
                                            style: SafeGoogleFont(
                                              'Be Vietnam Pro',
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5 * ffem / fem,
                                              color: Colors.white,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8 * fem), // Add some space between name and other details
                                FutureBuilder<void>(
                                  future: fetchArtistBooking(widget.BookingId), // Function to fetch price and rating from backend
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container(); // Placeholder until text is loaded
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        'Error loading text', // Placeholder for error
                                        style: SafeGoogleFont(
                                          'Be Vietnam Pro',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5 * ffem / fem,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Price per Hour: ${price ?? ''}', // Display the fetched price
                                            style: SafeGoogleFont(
                                              'Be Vietnam Pro',
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5 * ffem / fem,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 8 * fem),
                                          Text(
                                            'Rating:' , // Display the fetched rating
                                            style: SafeGoogleFont(
                                              'Be Vietnam Pro',
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5 * ffem / fem,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),



                    Container(
                      // depth1frame51h9 (9:1715)
                      padding: EdgeInsets.fromLTRB(16*fem, 1*fem, 16*fem, 13*fem),
                      width: double.infinity,
                      height: 96*fem,
                      decoration: BoxDecoration (
                        color: Color(0xFF121217),
                      ),
                      child: Container(
                        // depth3frame0YBH (9:1717)
                        width: 169.28*fem,
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // depth4frame05h1 (9:1718)
                              width: 139*fem,
                              height: 24*fem,
                              child: Text(
                                'Date',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 19*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              // depth4frame1b9Z (9:1721)
                              width: double.infinity,
                              child:TextField(
                                controller: _dateTextController,
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: _isEditing ? Colors.white : Color(0xff876370),
                                ),
                                enabled: _isEditing,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // depth1frame6vBq (9:1724)
                      padding: EdgeInsets.fromLTRB(16*fem, 1*fem, 16*fem, 13*fem),
                      width: double.infinity,
                      height: 96*fem,
                      decoration: BoxDecoration (
                        color: Color(0xFF121217)
                        ,
                      ),
                      child: Container(
                        // depth3frame0qpb (9:1726)
                        width: 162.03*fem,
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // depth4frame0nE3 (9:1727)
                              width: 139*fem,
                              height: 24*fem,
                              child: Text(
                                'Time',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 19*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              // depth4frame1V8T (9:1730)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0.03*fem, 0*fem),
                              width: double.infinity,
                              height: 31*fem,

                              child:TextField(
                                controller: _timeTextController,
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: _isEditing ? Colors.white : Color(0xff876370),
                                ),
                                enabled: _isEditing,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // depth1frame7BGB (9:1733)
                      padding: EdgeInsets.fromLTRB(16*fem, 1*fem, 16*fem, 13*fem),
                      width: double.infinity,
                      height: 96*fem,
                      decoration: BoxDecoration (
                        color:Color(0xFF121217),
                      ),
                      child: Container(
                        // depth3frame0uxs (9:1735)
                        width: 170.7*fem,
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // depth4frame04as (9:1736)
                              width: double.infinity,
                              height: 24*fem,

                              child: Text(
                                'Duration',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 19*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Colors.white,

                                ),
                              ),
                            ),
                            Container(
                              // depth4frame1NrT (9:1739)
                              width: double.infinity,
                              height: 31*fem,

                              child:  TextField(
                                controller: _durationTextController,
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: _isEditing ? Colors.white : Color(0xff876370),
                                ),
                                enabled: _isEditing,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // depth1frame8U8o (9:1742)
                      padding: EdgeInsets.fromLTRB(16*fem, 1*fem, 16*fem, 13*fem),
                      width: double.infinity,
                      height: 96*fem,
                      decoration: BoxDecoration (
                        color: Color(0xFF121217)
                        ,
                      ),
                      child: Container(
                        // depth3frame018j (9:1744)
                        width: 163.25*fem,
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // depth4frame09Vq (9:1745)
                              width: double.infinity,
                              height: 24*fem,
                              child: Text(
                                'Total Price ',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 19*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5*ffem/fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              // depth4frame1G4f (9:1748)
                              width: double.infinity,
                              height: 31*ffem,
                              child: Text(
                                totalprice!,
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 14*ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5*ffem/fem,
                                  color: Color(0xff876370),
                                ),

                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16 * fem, 1 * fem, 16 * fem, 13 * fem),
                      width: double.infinity,
                      height: 182 * fem,
                      decoration: BoxDecoration(
                        color: Color(0xFF121217),
                      ),
                      child: Container(
                        width: 167.92 * fem,
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 24 * fem,
                              child: Text(
                                'Location',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 19 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 144 * fem,
                              child: TextField(
                                controller: _locationController,
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: _isEditing ? Colors.white : Color(0xff876370),
                                ),
                                enabled: _isEditing,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      // autogroupmzqsqvP (JkRoFj6v1J7WT1Tj1JMZQs)
                      padding: EdgeInsets.fromLTRB(16*fem, 1*fem, 16*fem, 12*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: ElevatedButton(
                              onPressed: () {
                                print('hi');
                                _makePhoneCall(phone_number!);
                                // Handle button press
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffe5195e),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16 * fem,
                                  vertical: 12 * fem,
                                ),
                                // minimumSize: Size(double.infinity, 14 * fem),
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
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: 10*fem
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = !_isEditing;
                                  if (!_isEditing) {
                                    // Call your function here
                                    _saveBookingDetails();
                                    sendNotification(context,fcm_token!,false);
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9E9EB8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12 * fem),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16 * fem,
                                  vertical: 12 * fem,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _isEditing ? 'Save Changes' : 'Edit Booking',
                                  style: SafeGoogleFont(
                                    'Be Vietnam Pro',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5 * ffem / fem,
                                    letterSpacing: 0.2399999946 * fem,
                                    color: Color(0xff171111),
                                  ),
                                ),
                              ),
                            ),

                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),);
  }

  Future<void> sendNotification(BuildContext context, String fcm_token,bool status ) async {
    // Initialize API URLs for different kinds
    String apiUrl = '${Config().apiDomain}/send-notification';
    print('sendnotoify');
    print(fcm_token);

    Map<String, dynamic> requestBody = {
      'type':'artist',
      'fcm_token':fcm_token,
      'status':status,
    };

    try {
      var uri = Uri.parse(apiUrl);
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        // Show snackbar on successful notification send
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification has been sent to the user'),
            backgroundColor: Colors.green,
          ),
        );
        print('notification sent successfully: ${response.body}');
      } else {
        print('Failed to send notification. Status code: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification unsuccessfull'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error sending Notification  to the user'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}




