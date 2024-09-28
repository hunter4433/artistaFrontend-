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
  final storage = FlutterSecureStorage();

  Future<String?> _getFCMToken() async {
    return await storage.read(key: 'fCMToken');
  }

  Future<String?> _getPhoneNumber() async {
    return await storage.read(key: 'phone_number');
  }

  Future<String?> _getSelectedValue() async {
    return await storage.read(key: 'selected_value');
  }

  @override
  void dispose() {
    for (var controller in _codeController) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
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
    final String url = '${Config().apiDomain}/verify-otp';
    String? userType = await _getSelectedValue();

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json'},
      body: jsonEncode({'phone_number': phoneNumber, 'otp_code': otpCode}),
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
      // Fetch the stored phone number
      String? phoneNumber = await _getPhoneNumber();

      // Verify the OTP with Twilio
      bool otpVerified = await _verifyTwilioOTP(phoneNumber!, smsCode);

      if (!otpVerified) {
        // If OTP verification fails, show Snackbar and stop further execution
        _showSnackBar('OTP verification failed. Please try again.');
        return; // Stop further execution
      }

      // Fetch the FCM token, phone number, and user type
      String? fCMToken = await _getFCMToken();
      String? userType = await _getSelectedValue();

      // Attempt to log in with the appropriate user type
      bool loginSuccessful = await login(fCMToken, phoneNumber);

      if (loginSuccessful) {
        await storage.write(key: 'authorised', value: 'true');
        _navigateToHome(userType);
      } else {
        if (userType == 'hire') {
          bool success = await sendFCMTokenBackend(fCMToken, phoneNumber);
          if (success) {
            await storage.write(key: 'authorised', value: 'true');
            _navigateToSignUp(userType);
          }
        } else {
          _navigateToSignUp(userType);
        }
      }
    } catch (e) {
      print('Failed to sign in: $e');
      _showSnackBar('Failed to sign in: $e');
    }
  }

// Function to show the SnackBar
  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  void _navigateToHome(String? userType) {
    // Navigate to the correct screen based on user type
    if (userType == 'hire') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ServiceCheckerPage()),
      );
    } else if (userType == 'solo_artist') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavart(data: {},)),
      );
    } else if (userType == 'team') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavart(data: {},)),
      );
    }

    // Show a snackbar indicating successful login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged In Successfully')),
    );
  }



  void _navigateToSignUp(String? userType) {
    // Navigate to the correct screen based on user type
    if (userType == 'hire') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ServiceCheckerPage()),
      );
    } else if (userType == 'solo_artist') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => artist_cred()),
      );
    } else if (userType == 'team') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => team_info()),
      );
    }

    // Show a snackbar indicating successful login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signed Up Successfully')),
    );
  }

  // void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
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
                            'Enter the code we just texted you',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.w400,
                              fontSize: 23,
                              height: 1.25,
                              letterSpacing: -0.7,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF292938)),
                                  borderRadius: BorderRadius.circular(9),
                                  color: Color(0xFF292938),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 0.75,
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
                                      border: InputBorder.none,
                                      counterText: '',
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        if (index < _focusNodes.length - 1) {
                                          _focusNodes[index].unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(
                                              _focusNodes[index + 1]);
                                        } else {
                                          _focusNodes[index].unfocus();
                                        }
                                      } else if (value.isEmpty) {
                                        if (index > 0) {
                                          _focusNodes[index].unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(
                                              _focusNodes[index - 1]);
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
                      SizedBox(height: 24),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:  Color(0xffe5195e),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
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
                      SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Didn\'t receive the code? Resend Code',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}