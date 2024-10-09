import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test1/page-1/booking_history.dart';
import '../config.dart';
import '../utils.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'booked_artist.dart';
import 'customer_support.dart';
import'google_map_page.dart';


class booking_artist extends StatefulWidget {
  late String  artist_id;
  String? isteam;
  booking_artist({required this.artist_id , this.isteam});
  @override
  _BookingArtistState createState() => _BookingArtistState();
}

class _BookingArtistState extends State<booking_artist> {

  DateTime? selectedDate; // Define selectedDate variable here
  bool isContainerTapped = false;
  String? selectedFromTime;
  String? selectedFromTimeBack;
  String? selectedToTimeBack;
  String? name;
  String? team_name;
  String? price;
  String? amount;
  double? netAmount;
  String? image;
  String? orderId;
  int? hours;
  int? minutes;
  late String fcm_token;
 late double? latitude;
  late double? longitude;
  final FocusNode locationFocusNode = FocusNode();
  String? selectedToTime;
  String? selectedAudienceSize;// Define selectedToTime variable here
  double? artistPrice=10.0;
  String? crowdSize;
double? soundSystemPrice=0.0;
  bool hasSoundSystem = false ;
  double? totalAmount=0.0;
  // Place this outside the build method in your widget tree



  // Define TextEditingController instances
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController specialRequestController = TextEditingController();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
  String? selectedCategory;
  List<String> categories = ['House party', 'Corporate event', 'Wedding events','School or College fest','Cultural or Art Exhibitions','Festival','Birthday party','Private booking','Baby showers','Private Dinners','others']; // Replace with your actual categories


  final storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getid() async {
    return await storage.read(key: 'id'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getKind() async {
    return await storage.read(key: 'selected_value'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getUserFCMToken() async {
    return await storage.read(key: 'fCMToken'); // Assuming you stored the token with key 'token'
  }

  @override
  void initState() {
    super.initState();
    fetchArtistInformation(widget.artist_id);

    // Add a listener to the durationController to listen for changes
    durationController.addListener(() async {
      if (durationController.text.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 2));

        // Call the function to calculate the total amount
          // _calculateTotalAmount();
print('price is $price');
print('hour is $hours');
print('minute is $minutes');
          double? result = await calculateTotalAmount(price!, hours!, minutes!);
          if (result != null) {

            // Extract the total amount and sound system price from the result
            setState(() {
              totalAmount = result.toDouble();
              soundSystemPrice = result.toDouble();
              netAmount = totalAmount! + soundSystemPrice!; // Calculate the net amount
            });

            // Print the results or update the UI accordingly
            print('Total Amount: \$${totalAmount}');
            print('Sound System Price: \$${soundSystemPrice}');
          } else {
            print('Failed to calculate total amount');
          }
        // }
      }
    });

  }

  @override
  void dispose(){
    super.dispose();
    locationFocusNode.dispose();
    // _razorpay.clear(); // Removes all listeners
  }



    void _handlePaymentError(PaymentFailureResponse response) {
      // Handle payment error
      debugPrint('Payment error: ${response.code} - ${response.message}');
    }

    void _handleExternalWallet(ExternalWalletResponse response) {
      // Handle external wallet
      debugPrint('External wallet: ${response.walletName}');
    }




    void calculateDuration() {
      if (selectedFromTimeBack != null && selectedToTimeBack != null) {

        DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        DateTime fromTime = dateFormat.parse(selectedFromTimeBack!);
        DateTime toTime = dateFormat.parse(selectedToTimeBack!);

        Duration duration = toTime.difference(fromTime);

        if (duration.isNegative) {
          // Handle the case when 'To' time is before 'From' time
          duration = Duration.zero;
        }

        setState(() {
          durationController.text = "${duration.inHours} hours ${duration.inMinutes.remainder(60)} minutes";
           hours= duration.inHours;
           minutes = duration.inMinutes.remainder(60);
        });
        print(hours);
        print(minutes);


      }
    }

//   Future<Map<String, dynamic>?> calculateTotalAmount(
//       String pricePerHour, int hours, int minutes, bool hasSoundSystem) async {
//     // Define the API endpoint URL (Replace with your actual API URL)
//     final String apiUrl = '${Config().apiDomain}/calculate-total-amount';
//
//     try {
//       // Prepare the request body
//       Map<String, dynamic> requestBody = {
//         'price_per_hour': pricePerHour,
//         'hours': hours,
//         'minutes': minutes,
//         'has_sound_system': hasSoundSystem,
//       };
//
//       // Send the POST request
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/vnd.api+json',
//           'Accept': 'application/vnd.api+json',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       // Check if the request was successful (status code 200)
//       if (response.statusCode == 200) {
//         // Parse the JSON response
//         Map<String, dynamic> responseBody = jsonDecode(response.body);
// print('price for the event$responseBody');
//         // Return the parsed response containing total_amount and sound_system_price
//         return responseBody;
//       } else {
//         // If the API returned an error, print the status code and response body
//         print('Error: ${response.statusCode} - ${response.body}');
//         return null;
//       }
//     } catch (error) {
//       // Handle any errors that occur during the API request
//       print('Error: $error');
//       return null;
//     }
//   }

    double calculateTotalAmount(String pricePerHour, int hours, int minutes) {
      // Convert total time to hours
      double totalTimeInHours = hours + (minutes / 60.0);

      // Convert pricePerHour to double
      double pricePerHourDouble = double.parse(pricePerHour);

      // Calculate the total amount
      double totalAmount = totalTimeInHours * pricePerHourDouble;
      // print(totalAmount);

      return totalAmount;
    }



    Future<void> fetchArtistInformation(String artist_id) async {
    String? token = await _getToken();
    String? id = await _getid();
    String? kind = await _getKind();
     // print(widget.artist_id);

    String? pp;
    // Initialize API URLs for different kinds
    String apiUrl;
    if (widget.isteam == 'true') {
      apiUrl = '${Config().apiDomain}/featured/team/$artist_id';

    }else{
      apiUrl = '${Config().apiDomain}/featured/artist_info/$artist_id';
    }

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
          // 'Authorization': 'Bearer $token', // Include the token in the header
        },
      );
      if (response.statusCode == 200) {
        // Parse the response JSON
        List<dynamic> userDataList = json.decode(response.body);
print(userDataList );
        // print(userDataList);

        // Assuming the response is a list, iterate over each user's data
        for (var userData in userDataList) {
          // Update text controllers with fetched data for each user
          setState(() {
            team_name = userData['team_name'] ;
            name = userData['name'] ; // Assign String to name
            price = userData['price_per_hour'] ?? ''; // Assign String to price
            image = '${userData['profile_photo']}' ;
            fcm_token=userData['fcm_token'] ?? '';
            hasSoundSystem=userData['sound_system'] == 1 ? true: false ;

          });
// print('soundsystem is $hasSoundSystem');
        }
      } else {
        print('Failed to fetch user information. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }


    Future<String?> createOrder(double totalAmount) async {
      // Convert totalAmount to int and multiply by 100
      int totalAmountInCents = (totalAmount * 100).toInt();
      // Initialize API URLs for different kinds
      String  apiUrl = '${Config().apiDomain}/order';
      try {
        var uri = Uri.parse(apiUrl).replace(queryParameters: {'amount': totalAmountInCents.toString()});
        var response = await http.get(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            // 'Authorization': 'Bearer $token', // Include the token in the header
          },
        );
        if (response.statusCode == 201) {
          // Parse the response JSON
          Map<String, dynamic> orderResponse  = json.decode(response.body);

          orderId= orderResponse['order_id'];
          print( orderId);
          return orderId;

        } else {
          print('Failed to create order. Status code: ${response.body}');
        }
      } catch (e) {
        print('Error creating order: $e');
      }
      return null;
    }



  Future<void> sendNotification(BuildContext context, String fcm_token) async {
    Future<String?> _getBookingId() async {
      return await storage.read(key: 'booking_id'); // Assuming you stored the token with key 'token'
    }
    String? id = await _getid();
    String? booking_id = await _getBookingId();
    String? user_fcmToken = await _getUserFCMToken();




    // Initialize API URLs for different kinds
    String apiUrl = '${Config().apiDomain}/send-notification';

    Map<String, dynamic> requestBody = {
      'fcm_token': fcm_token,
      'type':'artist',
      // 'artist_id': id,
      // 'booking_id':booking_id,
      // 'user_fcmToken':user_fcmToken,
      'status':false,
    };
    print(requestBody);

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
            content: Text('Notification has been sent to the artist'),
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
          content: Text('Notification has been sent to the artist'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }




  Future<void> _selectDate(BuildContext context) async {

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      // Use builder to customize the date picker dialog
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xffe5195e), // Change primary color
              onPrimary: Colors.white, // Change text color on primary color
              surface: Colors.white, // Change background color
              onSurface: Colors.black, // Change text color on background color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xffe5195e), // Change button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        print(selectedDate);
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;


    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details',style: SafeGoogleFont('Be Vietnam Pro',color: Colors.black,
        fontWeight: FontWeight.w500,fontSize: 22*fem),
        ),
        leading: IconButton(color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            // Use Navigator.pop() to close the current screen (Scene2) and go back to the previous screen (Scene1)
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Container(
          // depth0frame0uCT (9:1570)
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // depth1frame28cw (9:1588)
                  padding: EdgeInsets.fromLTRB(16 * fem, 0 * fem, 0 * fem, 1 * fem),
                  width: double.infinity,
                  height: 148.66 * fem,
                  decoration: BoxDecoration(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(

                        height: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0* fem, 0* fem, 10 * fem, 0 * fem),
                              width: 110 * fem,
                              height: 130 * fem,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10 * fem),
                                child: Image.network(
                                  image ?? '',
                                  width: 110 * fem,
                                  height: 130 * fem,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              // depth3frame26CP (9:1591)
                              margin: EdgeInsets.fromLTRB(10 * fem, 0 * fem, 0 * fem, 1.83 * fem),
                              padding: EdgeInsets.fromLTRB( 0* fem, 30 * fem, 0 * fem, 0 * fem),
                              width: 222.61 * fem,
                              height: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name ??  team_name ?? '', // Use fetched name
                                    style: SafeGoogleFont(
                                      'Be Vietnam Pro',
                                      fontSize: 19 * ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xff1e0a11),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '₹ ${price ?? ''}  Per Hour\n(Includes all the Taxes)', // Use fetched price
                                    style: SafeGoogleFont(
                                      'Be Vietnam Pro',
                                      fontSize: 17 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xffa53a5e),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                // autogroupe7afD43 (JkRkRPf57vHepTRWamE7AF)
                padding: EdgeInsets.fromLTRB(16 * fem, 20 * fem, 16 * fem, 12 * fem),
                 width: double.infinity,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Container(
                       margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                       child: TextFormField(
                         controller: nameController,  // TextEditingController for name input
                         decoration: InputDecoration(
                           contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 12.0),
                           hintText: 'Enter Your Name',
                           hintStyle: SafeGoogleFont(
                             'Be Vietnam Pro',
                             fontSize: 16 * ffem,
                             fontWeight: FontWeight.w400,
                             height: 1.5 * ffem / fem,
                             color: Color(0xff1e0a11),
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(12 * fem),
                             borderSide: BorderSide(width: 1.25, color: Color(0xffeac6d3)),
                           ),
                           focusedBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(12 * fem),
                             borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                           ),
                         ),
                         style: SafeGoogleFont(
                           'Be Vietnam Pro',
                           fontSize: 16 * ffem,
                           fontWeight: FontWeight.w500,
                           height: 1.5 * ffem / fem,
                           color: Color(0xff1e0a11),
                         ),
                       ),
                     ),

                     Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                       child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        hint: Text(
                        'Select Event Category',
                       style: SafeGoogleFont(
                        'Be Vietnam Pro',
                        fontSize: 16 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.5 * ffem / fem,
                        color: Color(0xff1e0a11),
                         ),
                       ),
                        items: categories.map((String category) {
                          return DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category,
                          style: SafeGoogleFont(
                            'Be Vietnam Pro',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5 * ffem / fem,
                            color: Color(0xff1e0a11),
                          ),
                         ),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                       },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12 * fem),
                        borderSide: BorderSide(width: 1.25, color: Color(0xffeac6d3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12 * fem),
                        borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                      ),
                    ),
                  ),
                   ),

                     Container(
                       margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                       child: DropdownButtonFormField<String>(
                         value: selectedAudienceSize, // Store the selected audience size
                         hint: Text(
                           'Your Audience Size',
                           style: SafeGoogleFont(
                             'Be Vietnam Pro',
                             fontSize: 16 * ffem,
                             fontWeight: FontWeight.w400,
                             height: 1.5 * ffem / fem,
                             color: Color(0xff1e0a11),
                           ),
                         ),
                         items: [
                           '1-10',
                           '1-30',
                           '1-50',
                           '1-70',
                           '1-100',
                           'More than 100'
                         ].map((String size) {
                           return DropdownMenuItem<String>(
                             value: size,
                             child: Text(
                               size,
                               style: SafeGoogleFont(
                                 'Be Vietnam Pro',
                                 fontSize: 16 * ffem,
                                 fontWeight: FontWeight.w500,
                                 height: 1.5 * ffem / fem,
                                 color: Color(0xff1e0a11),
                               ),
                             ),
                           );
                         }).toList(),
                         onChanged: (newValue) {
                           setState(() {
                             selectedAudienceSize = newValue;
                           });
                         },
                         decoration: InputDecoration(
                           contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 12.0),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(12 * fem),
                             borderSide: BorderSide(width: 1.25, color: Color(0xffeac6d3)),
                           ),
                           focusedBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(12 * fem),
                             borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                           ),
                         ),
                       ),
                     ),

               ],
               ),
                ),
                 Container(
                  // autogroupe7afD43 (JkRkRPf57vHepTRWamE7AF)
                  padding: EdgeInsets.fromLTRB(16*fem, 7*fem, 16*fem, 12*fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // datetimevj9 (9:1606)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 15*fem),
                        child: Text(
                          'Date & Time',
                          style: SafeGoogleFont (
                            'Be Vietnam Pro',
                            fontSize: 22*ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.25*ffem/fem,
                            letterSpacing: -0.3300000131*fem,
                            color: Color(0xff1e0a11),
                          ),
                        ),
                      ),
                      Container(
                        // depth3frame0ppX (9:1609)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 14*fem),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isContainerTapped = !isContainerTapped;
                                  });
                                  _selectDate(context);
                                },
                                child: Container(
                                  height: 54 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isContainerTapped ? Color(0xffe5195e) : Color(0xffeac6d3),
                                    ),
                                    borderRadius: BorderRadius.circular(12 * fem),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(10 * fem, 0, 10 * fem, 0),
                                        child: Text(
                                          selectedDate != null
                                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                              : 'Choose Event Date',
                                          style: TextStyle(
                                            fontSize: 16 * ffem,
                                            color: Color(0xff1e0a11),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 16 * fem), // Add some space to shift the icon to the left
                                          Icon(
                                            Icons.calendar_today,
                                            color: isContainerTapped ? Color(0xffe5195e) : Color(0xffeac6d3),
                                          ),
                                          SizedBox(width: 8 * fem), // Adjust space if needed to balance the layout
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 14*fem,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 12 * fem),
                              child: Text(
                                'Select Time   (From-To)',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5 * ffem / fem,
                                  color: Color(0xff1e0a11),
                                ),
                              ),
                            ),

                            Row(
                              children:[
                                Container(
                                  width: 165*fem,
                                  height: 56 * fem,
                                  child: TextField(
                                    controller: fromTimeController,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );

                                      if (pickedTime != null) {
                                        setState(() {
                                          // Store the selected time in selectedFromTime variable
                                          selectedFromTime = pickedTime.format(context);
                                          String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
                                          selectedFromTimeBack = '$formattedDate ${pickedTime.hour}:${pickedTime.minute}:00';
                                          fromTimeController.text = selectedFromTime ?? ''; // Update the text field
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 12.0),
                                      suffixIcon: Icon(Icons.access_time, color: Color(0xffeac6d3)),
                                      hintText: 'From',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12 * fem),
                                        borderSide: BorderSide(width: 1.25, color: Color(0xffeac6d3)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12 * fem),
                                        borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Container(
                                  width: 165*fem,
                                  height: 56 * fem,
                                  child: TextField(
                                    controller: toTimeController,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );

                                      if (pickedTime != null) {
                                        setState(() {
                                          // Store the selected time in selectedToTime variable
                                          selectedToTime = pickedTime.format(context);
                                          // Format the selected date and time
                                          String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
                                          selectedToTimeBack = '$formattedDate ${pickedTime.hour}:${pickedTime.minute}:00';
                                          toTimeController.text = selectedToTime ?? ''; // Update the text field// Calculate duration whenever "To" time is selected
                                        });
                                        calculateDuration();
                                      }
                                    },
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 12.0),
                                      suffixIcon: Icon(Icons.access_time, color: Color(0xffeac6d3)),
                                      hintText: 'To',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12 * fem),
                                        borderSide: BorderSide(width: 1.25, color: Color(0xffeac6d3)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12 * fem),
                                        borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 56 * fem,
                        child: TextField(
                          controller: durationController, // Connect the controller here
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 12.0),
                            hintText: 'Event Duration',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * fem),
                              borderSide: BorderSide(width: 1.25, color: Color(0xffeac6d3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * fem),
                              borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18 * fem),

                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Event Location',
                              style: SafeGoogleFont (
                                'Be Vietnam Pro',
                                fontSize: 22*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.25*ffem/fem,
                                letterSpacing: -0.3300000131*fem,
                                color: Color(0xff1e0a11),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Color(0xffe5195e)),
                              onPressed: () {
                                // Focus on the TextField to allow editing
                                locationFocusNode.requestFocus();
                              },
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              // minHeight: 100.0, // Set a minimum height
                            ),
                            child: InkWell(
                              onTap: () {
                                _showLocationDialog(context);
                              },
                              child: IgnorePointer(
                                child: TextField(
                                  controller: locationController,
                                  focusNode: locationFocusNode,
                                  maxLines: null, // This allows the TextField to grow vertically
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 12.0), // Adjust padding
                                    hintText: 'Full Address',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 1.25,
                                        color: Color(0xffeac6d3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 1.25,
                                        color: Color(0xffe5195e),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),


                      SizedBox(height: 15 * fem),

                      Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 24 * fem),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                              constraints: BoxConstraints(
                                maxWidth: 325 * fem,
                              ),
                              child: Text(
                                'Special Message/Request For the Artist.',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 16 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5 * ffem / fem,
                                  color: Color(0xff1e0a11),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 56 * fem,
                              child: TextField(
                                controller: specialRequestController, // Connect the controller here
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 12.0),
                                  hintText: 'Optional',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Color(0xffeac6d3)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              // datetimevj9 (9:1606)
                              margin: EdgeInsets.fromLTRB(0*fem, 25*fem, 0*fem, 0*fem),
                              child: Text(
                                'Payment Information',
                                style: SafeGoogleFont (
                                  'Be Vietnam Pro',
                                  fontSize: 22*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25*ffem/fem,
                                  letterSpacing: -0.3300000131*fem,
                                  color: Color(0xff1e0a11),
                                ),
                              ),
                            ),
          Container(
            padding: EdgeInsets.fromLTRB(0,10*fem,0,20*fem),
            child: RichText(
              text: TextSpan(
                text: 'Questions on cancellations or refunds? See our ',
                style: TextStyle(
                  fontStyle: FontStyle.italic, // Italic style for the entire text
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'FAQ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.blue, // Blue color for the button
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to FAQ screen
                        Navigator.push(context, MaterialPageRoute (builder:
                            (context)=> SupportScreen())

                        );
                      },
                  ),
                  TextSpan(
                    text: ' or ',
                  ),
                  TextSpan(
                    text: 'Refund Policy',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.blue, // Blue color for the button
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to Refund Policy screen
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>SupportScreen()));
                      },
                  ),
                  TextSpan(
                    text: '.',
                  ),
                ],
              ),
            ),
          ),




                                Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                      Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                            Text(
                                          'Total Price for the artist:',
                                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
                                              ),
                                        Text(
                                            '₹${totalAmount}',
                                            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
                                            ),
                                      ],
                                      ),
                                      SizedBox(height: 10.0),


                                     if (hasSoundSystem)
                                     Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                       Text(
                                         'Sound system price :',
                                          style: TextStyle(fontSize: 17.0),
                                           ),
                                       Text(
                                        '₹${soundSystemPrice}',
                                        style: TextStyle(fontSize: 17.0),
                                            ),
                                      ],
                                     ),
                                    SizedBox(height: 5.0),

                                       Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                          Text(
                                         'Have your own sound system?',
                                          style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                                             ),
                                           TextButton(
                                             onPressed: () {
                                              setState(() {
                                              hasSoundSystem = !hasSoundSystem;
                                              soundSystemPrice = hasSoundSystem ? soundSystemPrice: 0.0;
                                                });
                                                },
                                             child: Text(
                                              hasSoundSystem ? 'Remove' : 'Add',
                                               style: TextStyle(color: hasSoundSystem ? Colors.red : Colors.green,fontSize: 16),
                                           ),
                                           ),
                                            ],
                                           ),
                                     SizedBox(height: 5.0),


                                     Divider(thickness: 1, color: Colors.grey),

                                     SizedBox(height: 10.0),

                                      Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                         Text(
                                        'Total Amount Payable:',
                                         style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
                                         ),
                                           Text(
                                             '₹${netAmount?.toStringAsFixed(2) ?? '0.00'}',
                                             style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
                                           ),
                                          ],
                                         ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '(Includes all the taxes)',
                                          style: TextStyle(fontSize: 16.0, ),
                                        ),
                                           ], ),
                                        ],

                                   )
                          ],



                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child:ElevatedButton(
                          onPressed: () async {
                            // Check if all required fields are filled
                            if (selectedCategory == null ||
                                selectedAudienceSize == null ||
                                selectedDate == null ||
                                fromTimeController.text.isEmpty ||
                                toTimeController.text.isEmpty ||
                                durationController.text.isEmpty ||
                                locationController.text.isEmpty) {
                              // Show an error message to the user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please fill in all the required fields')),
                              );
                              return; // Stop further execution
                            }

                            // Proceed with creating order if all fields are filled
                            String? orderId = await createOrder(netAmount!);

                            if (orderId != null) {
                              Razorpay _razorpay = Razorpay();

                              var options = {
                                'key': 'rzp_live_KJYr4DUx18zaJj',
                                // 'amount': ,
                                'name': 'Home Stage',
                                'order_id': orderId,
                                'description': 'artist book',
                                'timeout': 120, // in seconds
                              };

                              try {
                                _razorpay.open(options);
                              } catch (e) {
                                debugPrint('Error: $e');
                              }

                              _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) => _handlePaymentSuccess(context, response));
                              _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                              _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                            } else {
                              print('Order creation failed');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffe5195e),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          child: Center(
                            child: Text(
                              'Proceed To Payment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
                Container(
                  // depth1frame14GWj (9:1682)
                  width: double.infinity,
                  height: 20*fem,
                  decoration: BoxDecoration (
                    color: Color(0xffffffff),
                  ),
                ),
              ],
            ),
          ),
        ),
            ),
    ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(backgroundColor:Color(0xfffff5f8) ,
          title: Text('Event Location'),
          content: Text('How would you like to enter the Event Location?',
          style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                latitude = null;
                longitude = null;
                Navigator.of(context).pop();
                _showManualEntryDialog(context);
              },
              child: Text('Enter Manually',style: TextStyle(color: Colors.black),),
            ),
        ElevatedButton(
        onPressed: () async {
        // Close any modal that is open, such as a dialog
        Navigator.of(context).pop();

        // Show a loading indicator while transitioning to the map page
        showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
        child: CircularProgressIndicator(), // Display a loading spinner
        ),
        );

        // Navigate to GoogleMapPage and await the result
        final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GoogleMapPage()),
        );

        // Remove the loading spinner after the map is closed
        Navigator.of(context).pop();

        if (result != null && result.containsKey('coordinates')) {
        LatLng coordinates = result['coordinates'];
        latitude = coordinates.latitude;
        longitude = coordinates.longitude;
        String address = result['address'];

        // Update the UI with the selected address
        setState(() {
        locationController.text = address;
        });

        print('Selected Coordinates: ${coordinates.latitude}, ${coordinates.longitude}');
        } else {
        // Optionally handle the case when the user cancels without selecting a location
        print('No location selected');
        }
        },
        child: const Text(
        'Select On Map',
        style: TextStyle(color: Colors.black),
        ),
        ),
          ],
        );
      },
    );
  }

  void _showManualEntryDialog(BuildContext context) {
    TextEditingController flatController = TextEditingController();
    TextEditingController areaController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController stateController = TextEditingController();
    TextEditingController pincodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(backgroundColor:Color(0xfffff5f8) ,
          title: Text('Enter Address Manually'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: flatController,
                  decoration: InputDecoration(hintText: 'Apartment/House No,  Building'),
                ),
                TextField(
                  controller: areaController,
                  decoration: InputDecoration(hintText: 'Area, Street, Sector'),
                ),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(hintText: 'City'),
                ),
                TextField(
                  controller: stateController,
                  decoration: InputDecoration(hintText: 'State'),
                ),
                TextField(
                  controller: pincodeController,
                  decoration: InputDecoration(hintText: 'Pincode'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                locationController.text =
                "${flatController.text}, ${areaController.text}, ${cityController.text}, ${stateController.text}, ${pincodeController.text}";
                Navigator.of(context).pop();
              },
              child: Text('OK',style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }



  Future<void> _handlePaymentSuccess(BuildContext context, PaymentSuccessResponse response) async {
    try {
      // Extract the payment details
      String razorpayPaymentId = response.paymentId!;
      String razorpayOrderId = response.orderId!;
      String razorpaySignature = response.signature!;

      // Retrieve the artist ID from secure storage
      // Future<String?> _getArtistId() async {
      //   return await storage.read(key: 'artist_id');
      // }
      //
      // String artistId = (await _getArtistId()) ?? '';  // Fallback to an empty string if artistId is null
      //
      // if (artistId.isEmpty) {
      //   throw Exception('Failed to retrieve artist ID');
      // }

      // Save booking information and handle potential error
      String? bookingId;
      try {
        bookingId = (await _saveBookingInformation()).toString();
        if (bookingId == null || bookingId.isEmpty) {
          throw Exception('Failed to save booking information');
        }
      } catch (e) {
        // Handle booking save error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving booking: $e')));
        return;
      }

      // Send the payment details to the server
      try {
        await _sendPaymentDetailsToServer(razorpayPaymentId, razorpayOrderId, razorpaySignature, bookingId);
      } catch (e) {
        // Handle payment sending error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error sending payment details: $e')));
        return;
      }

      // Navigate to the booked page on success
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Booked(BookingId: bookingId!, artistId: widget.artist_id, isteam: widget.isteam ),
        ),
      );

      // Send notification
      sendNotification(context, fcm_token);

    } catch (e) {
      // Handle any other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment handling error: $e')));
    }
  }


    Future<Object> _saveBookingInformation() async {
      final storage = FlutterSecureStorage();


      // Future<String?> _getArtist_id() async {
      //   return await storage.read(key: 'artist_id'); // Assuming you stored the token with key 'token'
      // }



      Future<String?> _getToken() async {
        return await storage.read(key: 'token');
      }
      Future<String?> _getUserId() async {
        return await storage.read(key: 'user_id');
      }

      String? token = await _getToken();
      String? user_id = await _getUserId();

      // String? artist_id = await _getArtist_id();
      String? apiUrl='${Config().apiDomain}/booking';

      Map<String, dynamic> bookingData = {
        'artist_id': widget.isteam == 'true' ? null : widget.artist_id, // Only set artist_id if isteam is false
        'team_id': widget.isteam == 'true' ? widget.artist_id : null, // Only set team_id if isteam is true
        'user_id': user_id,
        'booking_date': selectedDate != null ? selectedDate.toString() : null,
        'booked_from':  selectedFromTimeBack ?? '',
        'booked_to':  selectedToTimeBack ?? '',
        'duration': durationController.text,
        'audience_size': selectedAudienceSize,
        'location': locationController.text,
        'longitude': longitude,
        'latitude': latitude,
        'special_request': specialRequestController.text,
        'category':selectedCategory,
        'status':0,
        // 'audience_size':selectedAudienceSize,
      };



      try {
        // Make PATCH request to the API
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            'Authorization': 'Bearer $token', // Include the token in the header
          },
          body: jsonEncode(bookingData),
        );

        // Check if request was successful (status code 200)
        if (response.statusCode == 201) {
          // User information saved successfully, handle response if needed
          print('Booking information saved successfully');

          Map<String, dynamic> responseData = jsonDecode(response.body);
          int id = responseData['id'];

// Store the token securely
          await storage.write(key: 'booking_id', value: id.toString());
          print(id);
          // Example response handling
          print('Response: ${response.body}');
          return id;
        } else {
          // Request failed, handle error
          print('Failed to save booking information. Status code: ${response.statusCode}');
          // Example error handling
          print('Error response: ${response.body}');
          return false;
        }
      } catch (e) {
        // Handle network errors
        print('Error saving user information: $e');
      }
      return false;
    }

    Future<void> _sendPaymentDetailsToServer(String paymentId, String orderId, String signature, String id) async {

      String serverUrl = '${Config().apiDomain}/payment/success';
      // print('booking_is is :$id');

      Future<String?> _getBookingId() async {
        return await storage.read(key: 'booking_id'); // Assuming you stored the token with key 'token'
      }
      String? booking_id = await _getBookingId();
      print('booking_is is :$booking_id');


      Map<String, dynamic> requestBody = {
        'payment_id': paymentId,
        'order_id': orderId,
        'signature': signature,
        'booking_id': booking_id,
      };
      print(requestBody);

      try {
        var response = await http.post(
          Uri.parse(serverUrl),
          headers: {'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',},
          body: json.encode(requestBody),
        );

        if (response.statusCode == 201) {
          debugPrint('Payment details stored successfully.');
        } else {
          debugPrint('Failed to store payment details. Status code: ${response.statusCode}');
          debugPrint('Failed to store payment details. Status code: ${response.body}');
        }
      } catch (e) {
        debugPrint('Error storing payment details: $e');
      }
    }



    Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(DateTime.now().year + 5),
      );
     if (pickedDate != null && pickedDate != selectedDate) {
     setState(() {
      selectedDate = pickedDate;
    });
  }
}
}

