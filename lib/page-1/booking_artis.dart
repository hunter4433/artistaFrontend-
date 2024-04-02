import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test1/page-1/booking_history.dart';
import '../utils.dart';

class booking_artist extends StatefulWidget {
  @override
  _BookingArtistState createState() => _BookingArtistState();
}

class _BookingArtistState extends State<booking_artist> {
  DateTime? selectedDate; // Define selectedDate variable here
  bool isContainerTapped = false;
  String? selectedFromTime;
  // Define selectedFromTime variable to hold the selected time
  // Simulated backend function to fetch artist image URL
  Future<String> fetchArtistImage() async {
    await Future.delayed(Duration(seconds: 2));
    return 'https://example.com/artist_image.jpg';
  }

  // Simulated backend function to fetch artist name and price
  Future<Map<String, dynamic>> fetchArtistData() async {
    await Future.delayed(Duration(seconds: 2));
    return {
      'name': 'DJ Khaled',
      'price': 1500,
    };
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
      });
    }
  }

  // Define a TextEditingController for the "From" TextField
  TextEditingController fromTimeController = TextEditingController();
  // Define a TextEditingController for the "To" TextField
  TextEditingController toTimeController = TextEditingController();

  @override
  void dispose() {
    // Dispose both controllers to avoid memory leaks
    fromTimeController.dispose();
    toTimeController.dispose();
    super.dispose();
  }
  String? selectedToTime; // Define selectedToTime variable here

  @override
  void initState() {
    super.initState();
    // Set the initial value of the "From" controller to selectedFromTime if it's not null
    fromTimeController.text = selectedFromTime ?? '';
    // Set the initial value of the "To" controller to selectedToTime if it's not null
    toTimeController.text = selectedToTime ?? '';
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
                                child: FutureBuilder<String>(
                                  future: fetchArtistImage(), // Function to fetch artist image URL from backend
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator(); // Placeholder while loading
                                    } else {
                                      return Container(
                                        margin: EdgeInsets.fromLTRB(10 * fem, 0 * fem, 10 * fem, 0 * fem),
                                        width: 128 * fem,
                                        height: 128 * fem,
                                        decoration: BoxDecoration(color: Colors.grey,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot.data!), // Use fetched image URL
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }
                                  },
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
                                    FutureBuilder<Map<String, dynamic>>(
                                      future: fetchArtistData(), // Function to fetch artist data from backend
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator(); // Placeholder while loading
                                        } else {
                                          return Text(
                                            snapshot.data!['name'], // Use fetched name
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
                                    SizedBox(height: 4),
                                    FutureBuilder<Map<String, dynamic>>(
                                      future: fetchArtistData(), // Function to fetch artist data from backend
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator(); // Placeholder while loading
                                        } else {
                                          return Text(
                                            '₹${snapshot.data!['price']}   Per Hour\n(Includes all the Charges)', // Use fetched price
                                            style: SafeGoogleFont(
                                              'Be Vietnam Pro',
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5 * ffem / fem,
                                              color: Color(0xffa53a5e),
                                            ),
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
                                       controller: fromTimeController, // Connect the controller here
                                       onTap: () async {
                                         final TimeOfDay? pickedTime = await showTimePicker(
                                           context: context,
                                           initialTime: TimeOfDay.now(),
                                         );

                                         if (pickedTime != null) {
                                           setState(() {
                                             // Store the selected time in selectedFromTime variable
                                             selectedFromTime = pickedTime.format(context);
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
                                      controller: toTimeController, // Connect the controller here
                                      onTap: () async {
                                        final TimeOfDay? pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (pickedTime != null) {
                                          setState(() {
                                            // Store the selected time in selectedToTime variable
                                            selectedToTime = pickedTime.format(context);
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
                              ]
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
                        SizedBox(
                          height: 18*fem,
                        ),

                        Container(
                          // durationPc3 (9:1652)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 16*fem),
                          child: Text(
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
                        ),

                        Container(
                          width: double.infinity,
                          height: 156 * fem,
                          child: TextField( maxLines: null,
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
                        SizedBox(
                          height: 18*fem,
                        ),



                        Container(
                          // specialrequestssp3 (9:1666)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 6.5*fem),
                          child: Text(
                            'Special requests',
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
                          // depth3frame0y6P (9:1669)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // pleaseprovideanyspecialrequest (9:1671)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8*fem),
                                constraints: BoxConstraints (
                                  maxWidth: 325*fem,
                                ),
                                child: Text(
                                  'Any Special Message For the Booked Artist.',
                                  style: SafeGoogleFont (
                                    'Be Vietnam Pro',
                                    fontSize: 16*ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5*ffem/fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 56 * fem,
                                child: TextField(
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

