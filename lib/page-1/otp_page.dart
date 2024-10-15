import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/artist_sign_up.dart';
import 'package:test1/page-1/page_0.3_artist_home.dart';
import 'package:test1/page-1/team_info.dart';
import '../config.dart';
import 'bottomNav_artist.dart';
import 'loc_service_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VerificationCodeInputScreen extends StatefulWidget {
  // final String verificationId;
  //
  // VerificationCodeInputScreen({required this.verificationId});

  @override
  _VerificationCodeInputScreenState createState() =>
      _VerificationCodeInputScreenState();
}

class _VerificationCodeInputScreenState
    extends State<VerificationCodeInputScreen> {
   final List<TextEditingController> _codeController =
  List.generate(6, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _countdown = 30; // Countdown timer in seconds
  bool _isButtonVisible = false; // Control visibility of the button

  final storage = FlutterSecureStorage();
  Timer? _timer; // Store the timer instance




  Future<String?> _getFCMToken() async {
    return await storage.read(key: 'fCMToken');
  }

  Future<String?> _getPhoneNumber() async {
    return await storage.read(key: 'phone_number');
  }

  Future<String?> _getSelectedValue() async {
    return await storage.read(key: 'selected_value');
  }
   Future<String?> _getTrimmedPhoneNumber() async {
     String? phoneNumber = await _getPhoneNumber();
     if (phoneNumber != null && phoneNumber.startsWith('+91')) {
       return phoneNumber.substring(3).trim(); // Remove '+91' and trim spaces
     }
     return phoneNumber?.trim(); // Return trimmed number if '+91' is not present
   }

  @override
  void initState() {
    super.initState();
    _startCountdown(); // Start the countdown timer when the screen loads
  }
  @override
  void dispose() {
    for (var controller in _codeController) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel(); // Cancel the timer if it's running
    super.dispose();
  }

  // Future<void> _sendTwilioOTP(String phoneNumber) async {
  //   // Your backend endpoint that integrates with Twilio Verify API
  //   final String url = '${Config().apiDomain}/twilio/send-verification';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'phone_number': phoneNumber}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('OTP sent successfully');
  //   } else {
  //     print('Failed to send OTP: ${response.body}');
  //   }
  // }






   Future<bool> _verifyTwilioOTP(String phoneNumber, String otpCode) async {
    // Your backend endpoint that verifies the OTP via Twilio
    final String url = '${Config().apiDomain}/verify';
    String? userType = await _getSelectedValue();
    if (phoneNumber.startsWith('+91')) {
      phoneNumber = phoneNumber.substring(3).trim();
    }
    print(phoneNumber);

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json'},
      body: jsonEncode({'numbers': phoneNumber, 'otp': otpCode}),
    );

    if (response.statusCode == 200) {
      print('OTP verified successfully');
      // Navigate to the relevant home page
      _navigateToHome(userType);
      return true;
    } else {
      print('Failed to verify OTP: ${response.body}');
      return false;
      _showSnackBar('Invalid OTP. Please try again.');
    }
    return false;
  }



  Future<bool> login(String? fCMToken, String? phoneNumber) async {
    if (fCMToken == null || phoneNumber == null) return false;

    // Define URLs for each user type
    final String artistLoginUrl = '${Config().apiDomain}/artist/login';
    final String teamLoginUrl = '${Config().apiDomain}/team/login';
    final String userLoginUrl = '${Config().apiDomain}/user/login';

    // Get the user type from selection
    String? userType = await _getSelectedValue();

    // Select the appropriate URL based on the user type
    String url;
    if (userType == 'hire') {
      url = userLoginUrl;
    } else if (userType == 'team') {
      url = teamLoginUrl;
    } else {
      url = artistLoginUrl;  // Default to solo_artist
    }

    // Send the login request
    bool loginSuccessful = await _sendLoginRequest(url, fCMToken, phoneNumber);

    if (loginSuccessful) {
      print('Login successful');
      return true;
    } else {
      print('Failed to login');
      return false;
    }
  }

  Future<bool> _sendLoginRequest(String url, String fCMToken, String phoneNumber) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
      },
      body: jsonEncode(<String, String>{
        'fcm_token': fCMToken,
        'phone_number': phoneNumber,
      }),
    );

    String? userType = await _getSelectedValue();
    print('User type: $userType');

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      print('my body is $body');

      int id;
      if (userType == 'hire') {
        id = body['user']['id']; // Handle hire login
        await storage.write(key: 'user_id', value: id.toString());
      } else if (userType == 'team') {
        id = body['artist']['id']; // Handle team login
        await storage.write(key: 'team_id', value: id.toString());
      } else {
        id = body['artist']['id']; // Handle solo_artist login
        await storage.write(key: 'artist_id', value: id.toString());
        print("hi");
      }

      return true;
    } else {
      print('Failed to login: ${response.body}');
      return false;
    }
  }

  Future<bool> sendFCMTokenBackend(
      String? fCMToken, String? phoneNumber) async {
    if (fCMToken == null || phoneNumber == null) return false;

    final String backendUrl = '${Config().apiDomain}/basic';
    print(backendUrl);
    final response = await http.post(
      Uri.parse(backendUrl),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
      },
      body: jsonEncode(<String, String>{
        'fcm_token': fCMToken,
        'phone_number': phoneNumber,
      }),
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> body = json.decode(response.body);
      int id = body['id'];
      await storage.write(key: 'user_id', value: id.toString());

      print('FCM token and phone_number sent successfully');
      return true;
    } else {
      print('Failed to send FCM token: ${response.body}');
      return false;
    }
  }

  void _signInWithPhoneNumber() async {
    final smsCode = _codeController.map((controller) => controller.text.trim()).join();

    try {
      // Fetch stored phone number
      String? phoneNumber = await _getPhoneNumber();
      if (phoneNumber == null) throw Exception('Phone number not found.');

      // Verify OTP with Twilio
      bool otpVerified = await _verifyTwilioOTP(phoneNumber, smsCode);
      if (!otpVerified) {
        _showSnackBar('OTP verification failed. Please try again.');
        return; // Stop further execution if OTP fails
      }

      // Fetch FCM token and user type
      String? fCMToken = await _getFCMToken();
      String? userType = await _getSelectedValue();

      // Attempt login
      bool loginSuccessful = await login(fCMToken, phoneNumber);

      if (loginSuccessful) {
        await storage.write(key: 'authorised', value: 'true');
        if (mounted) _navigateToHome(userType);
      } else {
        if (userType == 'hire') {
          bool success = await sendFCMTokenBackend(fCMToken, phoneNumber);
          if (success) {
            await storage.write(key: 'authorised', value: 'true');
            if (mounted) _navigateToSignUp(userType);
          }
        } else {
          if (mounted) _navigateToSignUp(userType);
        }
      }
    } catch (e) {
      print('Failed to sign in: $e');
      if (mounted) _showSnackBar('Failed to sign in: $e');
    }
  }

// Function to show a SnackBar
  void _showSnackBar(String message) {
    if (mounted) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

// Function to navigate to the home screen
  void _navigateToHome(String? userType) {
    if (!mounted) return; // Ensure the widget is still mounted

    Widget targetPage;
    if (userType == 'hire') {
      targetPage = ServiceCheckerPage();
    } else if (userType == 'solo_artist' || userType == 'team') {
      targetPage = BottomNavart(data: {});
    } else {
      return; // Exit if no valid userType is found
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );

    _showSnackBar('Logged In Successfully');
  }

// Function to navigate to the sign-up screen
  void _navigateToSignUp(String? userType) {
    if (!mounted) return; // Ensure the widget is still mounted

    Widget targetPage;
    if (userType == 'hire') {
      targetPage = ServiceCheckerPage();
    } else if (userType == 'solo_artist') {
      targetPage = artist_cred();
    } else if (userType == 'team') {
      targetPage = team_info();
    } else {
      return; // Exit if no valid userType is found
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );

    _showSnackBar('Signed Up Successfully');
  }

  // void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  // Start the countdown timer
  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) { // Check if the widget is still mounted
        setState(() {
          if (_countdown > 0) {
            _countdown--;
          } else {
            _isButtonVisible = true; // Show the button after countdown ends
            timer.cancel();
          }
        });
      } else {
        timer.cancel(); // Cancel the timer if the widget is not mounted
      }
    });
  }

  // Function to handle Resend Code functionality
  void _resendCode(BuildContext context)  async {
    // Restart the countdown and hide the button
    setState(() {
      _countdown = 30;
      _isButtonVisible = false;
    });
    _startCountdown();

    String? phoneNumber = await _getTrimmedPhoneNumber();
    print(phoneNumber); //

    // Prepare the API request
    final url = '${Config().apiDomain}/sms'; // Update this with your backend URL
    final body = json.encode({
      'numbers': phoneNumber,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Navigate to OTP input screen if successful
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeInputScreen(
              // phoneNumber: phoneNumber,  // Pass phone number to OTP screen
            ),
          ),
        );
      } else {
        final error = json.decode(response.body)['message'];
        _showSnackBar('Error: $error');
      }
    } catch (e) {
      _showSnackBar('Something went wrong: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121217),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF121217),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(16, 110, 16, 24),
                          child: Center(
                            child: Text(
                              'Enter the code we just texted You',
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                                height: 1.25,
                                letterSpacing: -0.7,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              return Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color: Color(0xFF292938),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 0.81,
                                    child: TextField(
                                      controller: _codeController[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.manrope(
                                        color: Colors.white, // Text color
                                        fontSize: 24, // Text size
                                        fontWeight: FontWeight.w500, // Font weight
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(11),
                                          borderSide: BorderSide(
                                            color: Color(0xFF292938), // Border color when not focused
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(11),
                                          borderSide: BorderSide(
                                            color: Color(0xFFE0E0E0),  // Border color when focused
                                            width: 1.5,
                                          ),
                                        ),
                                        counterText: '',
                                        // Adjust the padding to center the text vertically.
                                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                                      ),
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      onChanged: (value) {
                                        if (value.length == 1) {
                                          if (index < _focusNodes.length - 1) {
                                            _focusNodes[index].unfocus();
                                            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                                          } else {
                                            _focusNodes[index].unfocus();
                                          }
                                        } else if (value.isEmpty) {
                                          if (index > 0) {
                                            _focusNodes[index].unfocus();
                                            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        SizedBox(height: 15),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffe5195e), // Starting color
                                    Color(0xffc2185b), // Ending color
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12.5),
                                  backgroundColor: Colors.transparent, // Set transparent to show gradient
                                  shadowColor: Colors.transparent, // Remove shadow to avoid overlay issues
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                                onPressed: _signInWithPhoneNumber,
                                child: Text(
                                  'Confirm',
                                  style: GoogleFonts.beVietnamPro(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        // Countdown timer and Resend Code button
                        // Countdown timer and Resend Code button in a single row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _countdown > 0 ? 'Resend code in $_countdown seconds' : '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            if (_isButtonVisible)
                              TextButton(
                                onPressed: () async {
                                  // Call _resendCode function and handle phone number trimming
                                   // Debugging line
                                    _resendCode(context); // Pass phone number to _resendCode

                                },
                                child: Text(
                                  'Resend Code',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue, // Change button color
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

