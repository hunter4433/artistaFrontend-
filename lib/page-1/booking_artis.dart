import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test1/page-1/booking_history.dart';
import '../utils.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  String? image;
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
      apiUrl = 'http://127.0.0.1:8000/api/featured/artist_info/$id';

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


        // Assuming the response is a list, iterate over each user's data
        for (var userData in userDataList) {
          // Update text controllers with fetched data for each user
          setState(() {
            name = userData['name'] ?? ''; // Assign String to name
            price = userData['price_per_hour'] ?? ''; // Assign String to price
            image = 'http://127.0.0.1:8000/storage/${userData['profile_photo']}' ;
          });

        }
      } else {
        print('Failed to fetch user information. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user information: $e');
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

                        // Widgets using the text controllers to store inserted data
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
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                          child: Text(
                            'Event Location',
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
                          width: double.infinity,
                          height: 156 * fem,
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
                            onPressed: () {
                              print('hi');
                              _saveBookingInformation();
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
    String? apiUrl='http://127.0.0.1:8000/api/booking';

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

