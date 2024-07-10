import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test1/page-1/booking_history.dart';
import '../utils.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import'google_map_page.dart';

class booking_artist extends StatefulWidget {
  @override
  _BookingArtistState createState() => _BookingArtistState();
}

class _BookingArtistState extends State<booking_artist> {
    // Razorpay _razorpay = Razorpay();

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
  // Define TextEditingController instances
  TextEditingController durationController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController specialRequestController = TextEditingController();



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




    // Simulated backend function to fetch artist name and price
  @override
  void initState() {
    super.initState();
    fetchArtistInformation();
    // // Set the initial value of the "From" controller to selectedFromTime if it's not null
    // fromTimeController.text = selectedFromTime ?? '';
    // // Set the initial value of the "To" controller to selectedToTime if it's not null
    // toTimeController.text = selectedToTime ?? '';
  }

  @override
  void dispose(){
    super.dispose();
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



    // void _handlePaymentError(PaymentFailureResponse response) {
    //   // Do something when payment fails
    //   // showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
    // }

    // void _handleExternalWallet(ExternalWalletResponse response) {
    //   // Do something when an external wallet is selected
    // //   showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
    //  }
    // void showAlertDialog(BuildContext context, String title, String message){
    //   // set up the buttons
    //   Widget continueButton = ElevatedButton(
    //     child: const Text("Continue"),
    //     onPressed:  () {},
    //   );
    //   // set up the AlertDialog
    //   AlertDialog alert = AlertDialog(
    //     title: Text(title),
    //     content: Text(message),
    //   );
    //   // show the dialog
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return alert;
    //     },
    //   );
    // }
    void calculateDuration() {
      if (selectedFromTimeBack != null && selectedToTimeBack != null) {
        DateTime fromTime = DateTime.parse(selectedFromTimeBack!);
        DateTime toTime = DateTime.parse(selectedToTimeBack!);

        Duration duration = toTime.difference(fromTime);
        //  hours= duration.inHours;
        // int minutes = duration.inMinutes.remainder(60);

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
    // print(token);
    print(id);
    print(kind);

    // Initialize API URLs for different kinds
    String apiUrl;
    // if (kind == 'solo_artist') {
      apiUrl = 'http://192.0.0.2:8000/api/featured/artist_info/$id';

    // } else if (kind == 'team') {
    //   apiUrl = 'http://127.0.0.1:8000/api/artist/team_info/$id';
    // } else {
    //   // Handle the case where kind is not recognized
    //   return;
    // }

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
        // Parse the response JSON
        List<dynamic> userDataList = json.decode(response.body);
        print(userDataList);


        // Assuming the response is a list, iterate over each user's data
        for (var userData in userDataList) {
          // Update text controllers with fetched data for each user
          setState(() {
            name = userData['name'] ?? ''; // Assign String to name
            price = userData['price_per_hour'] ?? ''; // Assign String to price
            image = 'http://192.0.0.2:8000/storage/${userData['profile_photo']}' ;
            fcm_token=userData['fcm_token'] ?? '';
          });
            print( price);
            print(fcm_token);
        }
      } else {
        print('Failed to fetch user information. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }

    Future<String?> createOrder(double totalAmount) async {

      print(totalAmount);


// Convert totalAmount to int and multiply by 100
      int totalAmountInCents = (totalAmount * 100).toInt();

      // Initialize API URLs for different kinds
      String  apiUrl = 'http://192.0.0.2:8000/api/order';


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
          // Parse the response JSON
          Map<String, dynamic> orderResponse  = json.decode(response.body);

          orderId= orderResponse['order_id'];
          print( orderId);
          return orderId;


          // }
        } else {
          print('Failed to create order. Status code: ${response.body}');
        }
      } catch (e) {
        print('Error creating order: $e');
      }
      return null;
    }

  Future<void> sendNotification(BuildContext context, String fcm_token) async {
    print('hi mohit here');
    print(fcm_token);
    print('bye');

    // Initialize API URLs for different kinds
    String apiUrl = 'http://192.0.0.2:8000/api/send-notification';

    Map<String, dynamic> requestBody = {
      'fcm_token': fcm_token,
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
      }
    } catch (e) {
      print('Error sending notification: $e');
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

  // Define a TextEditingController for the "From" TextField
  TextEditingController fromTimeController = TextEditingController();
  // Define a TextEditingController for the "To" TextField
  TextEditingController toTimeController = TextEditingController();

  // @override
  // void dispose() {
  //   // Dispose both controllers to avoid memory leaks
  //   fromTimeController.dispose();
  //   toTimeController.dispose();
  //   super.dispose();
  // }
  String? selectedToTime; // Define selectedToTime variable here


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
                    padding: EdgeInsets.fromLTRB(16*fem, 0*fem, 16*fem, 1*fem),
                    width: double.infinity,
                    height: 148.66*fem,
                    decoration: BoxDecoration (
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // depth2frame03V1 (9:1589)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 7.39*fem, 0*fem),
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
                                margin: EdgeInsets.fromLTRB(10*fem, 44.83*fem, 0*fem, 1.83*fem),
                                width: 202.61*fem,
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
                                            // fromTimeController.text = selectedFromTime ?? ''; // Update the text field
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

// Add the new text widget here
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
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                          child: Text(
                            'Event Location',
                            style: TextStyle(
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.25 * ffem / fem,
                              letterSpacing: -0.33 * fem,
                              color: Color(0xff1e0a11),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 156 * fem,
                          child: InkWell(
                            onTap: () {
                              // Navigate to the GoogleMapPage when tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GoogleMapPage()),
                              );
                            },
                            child: IgnorePointer(
                              child: TextField(
                                controller: locationController, // Connect the controller here
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'Full Address',
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
                          ),
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
                              // _handlePaymentSuccess(response);
                              _saveBookingInformation();
                              // Calculate the total amount
                              double totalAmount = calculateTotalAmount(price!, hours!, minutes!);
                              print(totalAmount);
                              // Create order and wait for the response
                              String? orderId = await createOrder(totalAmount);
                              print('hi');
                              print(orderId);
                              print('bi');

                             if (orderId != null) {
                               Razorpay _razorpay = Razorpay();

                               var options = {
                                 'key': 'rzp_test_Hb4hFCm46361XC',
                                 'amount': 5000,
                                 //in the smallest currency sub-unit.
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
    ),);
  }

    void _handlePaymentSuccess(BuildContext context, PaymentSuccessResponse response) {
      debugPrint('Payment Success: $response');


      // Extract the payment details
      String razorpayPaymentId = response.paymentId!;
      debugPrint(razorpayPaymentId);
      String razorpayOrderId = response.orderId!;
      debugPrint(razorpayOrderId);
      String razorpaySignature = response.signature!;
      debugPrint(razorpaySignature );

      // Send the payment details to the server
      _sendPaymentDetailsToServer(razorpayPaymentId, razorpayOrderId, razorpaySignature);

      sendNotification(context , fcm_token);

    }

    Future<bool> _saveBookingInformation() async {
      final storage = FlutterSecureStorage();

      Future<String?> _getArtist_id() async {
        return await storage.read(key: 'artist_id'); // Assuming you stored the token with key 'token'
      }

      Future<String?> _getToken() async {
        return await storage.read(key: 'token');
      }

      String? token = await _getToken();
      String? artist_id = await _getArtist_id();
      String? apiUrl='http://192.0.0.2:8000/api/booking';

      Map<String, dynamic> bookingData = {
        'artist_id':'$artist_id',
        'booking_date': selectedDate != null ? selectedDate.toString() : null,
        'booked_from':  selectedFromTimeBack ?? '',
        'booked_to':  selectedToTimeBack ?? '',
        'duration': durationController.text,
        'location': locationController.text,
        'special_request': specialRequestController.text,
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
          print('User information saved successfully');

          Map<String, dynamic> responseData = jsonDecode(response.body);
          int id = responseData['id'];

// Store the token securely
          await storage.write(key: 'booking_id', value: id.toString());
          print(id);
          // Example response handling
          print('Response: ${response.body}');
          return true;
        } else {
          // Request failed, handle error
          print('Failed to save user information. Status code: ${response.statusCode}');
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

      String serverUrl = 'http://192.0.0.2:8000/api/payment/success';

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

