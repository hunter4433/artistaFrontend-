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
import'google_map_page.dart';


class booking_artist extends StatefulWidget {
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
  String? price;
  String? amount;
  String? netAmount;
  String? image;
  String? orderId;
  int? hours;
  int? minutes;
  late String fcm_token;
 late double? latitude;
  late double? longitude;
  final FocusNode locationFocusNode = FocusNode();
  String? selectedToTime; // Define selectedToTime variable here

  // Define TextEditingController instances
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
    fetchArtistInformation();

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



    Future<void> fetchArtistInformation() async {
    String? token = await _getToken();
    String? id = await _getid();
    String? kind = await _getKind();


    // Initialize API URLs for different kinds
    String apiUrl;
    // if (kind == 'solo_artist') {
      apiUrl = '${Config().apiDomain}/featured/artist_info/$id';

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

        print(userDataList);

        // Assuming the response is a list, iterate over each user's data
        for (var userData in userDataList) {
          // Update text controllers with fetched data for each user
          setState(() {
            name = userData['name'] ?? ''; // Assign String to name
            price = userData['price_per_hour'] ?? ''; // Assign String to price
            image = '${userData['profile_photo']}' ;
            fcm_token=userData['fcm_token'] ?? '';
          });

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
        title: Text('Booking Details',style: SafeGoogleFont('Be Vietnam Pro')


          ),
      ),
      body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          height: 1232.16*fem,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
          ),
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
                    padding: EdgeInsets.fromLTRB(16 * fem, 0 * fem, 16 * fem, 1 * fem),
                    width: double.infinity,
                    height: 148.66 * fem,
                    decoration: BoxDecoration(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // depth2frame03V1 (9:1589)
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 7.39 * fem, 0 * fem),
                          height: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 7.39 * fem, 0 * fem),
                                width: 128 * fem,
                                height: 128 * fem,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10 * fem, 0 * fem, 10 * fem, 0 * fem),
                                  width: 128 * fem,
                                  height: 128 * fem,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(64 * fem),
                                    child: Image.network(
                                      image ?? '',
                                      width: 128 * fem,
                                      height: 128 * fem,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // depth3frame26CP (9:1591)
                                margin: EdgeInsets.fromLTRB(10 * fem, 44.83 * fem, 0 * fem, 1.83 * fem),
                                width: 202.61 * fem,
                                height: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name ?? '', // Use fetched name
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xff1e0a11),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '₹${price ?? ''}   Per Hour\n(Includes all the Charges)', // Use fetched price
                                      style: SafeGoogleFont(
                                        'Be Vietnam Pro',
                                        fontSize: 16 * ffem,
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
                  // Add Category Dropdown here
                       Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                         child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          hint: Text(
                          'Select Booking Category',
                         style: SafeGoogleFont(
                          'Be Vietnam Pro',
                          fontSize: 16 * ffem,
                          fontWeight: FontWeight.w500,
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
                              fontWeight: FontWeight.w500,
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
                    padding: EdgeInsets.fromLTRB(16*fem, 20*fem, 16*fem, 12*fem),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // datetimevj9 (9:1606)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 23.5*fem),
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
                                child: Text(
                                  'Select Date',
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
                                    height: 56 * fem,
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
                                          padding: EdgeInsets.symmetric(horizontal: 16 * fem),
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
                                        Icon(Icons.calendar_today,
                                            color: isContainerTapped ? Color(0xffe5195e) : Color(0xffeac6d3)),
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
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                ),
                              ),

                              Row(
                                children:[
                                  Container(
                                    width: 175,
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
                                            print(selectedFromTimeBack);
                                            fromTimeController.text = selectedFromTime ?? ''; // Update the text field
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
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
                                    width: 10,
                                  ),
                                  Container(
                                    width: 175,
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
                                            print(selectedToTimeBack);
                                            toTimeController.text = selectedToTime ?? ''; // Update the text field
                                            calculateDuration(); // Calculate duration whenever "To" time is selected
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
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
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                          child: Text(
                            'Event Duration',
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
                            controller: durationController, // Connect the controller here
                            decoration: InputDecoration(
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
                          margin: EdgeInsets.symmetric(vertical: 8 * fem),
                          child: FutureBuilder<double>(
                            future: Future.delayed(Duration(seconds: 1), () => calculateTotalAmount( price!  ,hours!, minutes!)), // Replace 1000 with the actual amount
                            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text(
                                  '',
                                  style: SafeGoogleFont(
                                    'Be Vietnam Pro',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  '',
                                  style: SafeGoogleFont(
                                    'Be Vietnam Pro',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                );
                              } else {
                                return Text(
                                  'Total Amount Excluding GST: ${snapshot.data!.toStringAsFixed(2)}',
                                  style: SafeGoogleFont(
                                    'Be Vietnam Pro',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Event Location',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                  letterSpacing: -0.33,
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
                              height: 156,
                              child: InkWell(
                                onTap: () {
                                  _showLocationDialog(context);
                                },
                                child: IgnorePointer(
                                  child: TextField(
                                    controller: locationController,
                                    focusNode: locationFocusNode,
                                    maxLines: null,
                                    decoration: InputDecoration(
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
                            ),
                          ],
                        ),


                        SizedBox(height: 18 * fem),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 6.5 * fem),
                          child: Text(
                            'Special requests',
                            style: SafeGoogleFont(
                              'Be Vietnam Pro',
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.25 * ffem / fem,
                              letterSpacing: -0.3300000131 * fem,
                              color: Color(0xff1e0a11),
                            ),
                          ),
                        ),
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
                                  'Any Special Message For the Booked Artist.',
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: ElevatedButton(
                            onPressed: () async{

                              // Calculate the total amount
                              double totalAmount = calculateTotalAmount(price!, hours!, minutes!);
                              // Create order and wait for the response
                              String? orderId = await createOrder(totalAmount);

                             if (orderId != null) {
                               Razorpay _razorpay = Razorpay();

                               var options = {
                                 'key': 'rzp_test_Hb4hFCm46361XC',
                                 'amount': 5000,
                                 'name': 'Home Stage ',
                                 'order_id': orderId,
                                 // Generate order_id using Orders API
                                 'description': 'artist book',
                                 'timeout': 120,
                                 // in seconds
                                 // 'prefill': {
                                 //   'contact': '8538948208',
                                 //   'email': 'manav.kumar@example.com'
                                 // }
                               };

                               try {
                                 _razorpay.open(options);
                               } catch (e) {
                                 debugPrint('Error: $e');
                               }

                               _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                       (response) => _handlePaymentSuccess(context, response));
                               _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                   _handlePaymentError);
                               _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                   _handleExternalWallet);

                               // _razorpay.clear(); // Removes all listeners
                             }else {
                               print('Order creation failed');
                             }
                              // Handle button pres
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
                              minimumSize: Size(double.infinity, 14 * fem),
                            ),
                            child: Center(
                              child: Text(
                                'Proceed To Payment',
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
    ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Event Location'),
          content: Text('How would you like to enter the event location?'),
          actions: [
            TextButton(
              onPressed: () {
                latitude = null;
                longitude = null;
                Navigator.of(context).pop();
                _showManualEntryDialog(context);
              },
              child: Text('Enter Manually'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoogleMapPage()),
                );
                if (result != null && result.containsKey('coordinates')) {

                  LatLng  coordinates = result['coordinates'];
                  latitude= coordinates.latitude;
                  longitude= coordinates.longitude;
                  String address = result['address'];
                  setState(() {
                    locationController.text = address;
                  });
                  print('Selected Coordinates: ${coordinates.latitude}, ${coordinates.longitude}');

                }
              },
              child: Text('Select on Map'),
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
        return AlertDialog(
          title: Text('Enter Address Manually'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: flatController,
                  decoration: InputDecoration(hintText: 'Flat, House No, Building, Apartment'),
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
            TextButton(
              onPressed: () {
                locationController.text =
                "${flatController.text}, ${areaController.text}, ${cityController.text}, ${stateController.text}, ${pincodeController.text}";
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }



Future<void> _handlePaymentSuccess(BuildContext context, PaymentSuccessResponse response) async {

      // Extract the payment details
      String razorpayPaymentId = response.paymentId!;

      String razorpayOrderId = response.orderId!;

      String razorpaySignature = response.signature!;

      Future<String?> _getArtist_id() async {
        return await storage.read(key: 'id'); // Assuming you stored the token with key 'token'
      }

      String artist_id = await _getArtist_id().toString();

      String id= await _saveBookingInformation().toString();

      // Send the payment details to the server

        _sendPaymentDetailsToServer(
            razorpayPaymentId, razorpayOrderId, razorpaySignature);



      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Booked(BookingId: id ,artistId :artist_id ),
        ),
      );

      sendNotification(context , fcm_token);

    }

    Future<Object> _saveBookingInformation() async {
      final storage = FlutterSecureStorage();


      Future<String?> _getArtist_id() async {
        return await storage.read(key: 'id'); // Assuming you stored the token with key 'token'
      }

      Future<String?> _getToken() async {
        return await storage.read(key: 'token');
      }
      Future<String?> _getUserId() async {
        return await storage.read(key: 'user_id');
      }

      String? token = await _getToken();
      String? user_id = await _getUserId();

      String? artist_id = await _getArtist_id();
      String? apiUrl='${Config().apiDomain}/booking';

      Map<String, dynamic> bookingData = {
        'artist_id':artist_id,
        'user_id': user_id,
        'booking_date': selectedDate != null ? selectedDate.toString() : null,
        'booked_from':  selectedFromTimeBack ?? '',
        'booked_to':  selectedToTimeBack ?? '',
        'duration': durationController.text,

        'location': locationController.text,
        'longitude': longitude,
        'latitude': latitude,
        'special_request': specialRequestController.text,
        'category':selectedCategory,
        'status':0,
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

    Future<void> _sendPaymentDetailsToServer(String paymentId, String orderId, String signature) async {

      String serverUrl = '${Config().apiDomain}/payment/success';

      Future<String?> _getBookingId() async {
        return await storage.read(key: 'booking_id'); // Assuming you stored the token with key 'token'
      }
      String? booking_id = await _getBookingId();
      // print(booking_id);
      // print(paymentId);
      // print(orderId);
      // print(signature);

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

