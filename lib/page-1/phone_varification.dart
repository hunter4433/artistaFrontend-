import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/otp_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;  // Import for HTTP requests
import 'dart:convert';

import '../config.dart'; // For JSON encoding/decoding

class PhoneNumberInputScreen extends StatefulWidget {
  @override
  _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  bool isChecked = false;
  final _phoneController = TextEditingController(text: '+91 ');
  final storage = FlutterSecureStorage();

  // Function to send phone number to backend for Twilio OTP
  void _sendPhoneNumberToBackend() async {
    final phoneNumber = _phoneController.text.trim();

    // Prepare the API request
    final url = '${Config().apiDomain}/send-otp'; // Update this with your backend URL
    final body = json.encode({
      'phone_number': phoneNumber,
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

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFF121217),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 88, 0, 6.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 35,
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text(
                  'Enter your mobile number',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    letterSpacing: -0.7,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(18.7, 15, 18.7, 12),
                child: Text(
                  "We'll send you a code to verify your number.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
// // <<<<<<< HEAD
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 children: [
//                   Checkbox(
//                     value: isChecked,
//                     onChanged: (value) {
//                       setState(() {
//                         isChecked = value ?? false;
//                       });
//                     },
//                     activeColor: Color(0xFF2B8AE8),
//                     checkColor: Colors.white,
//                   ),
//                   Expanded(
//                     child: RichText(
//                       text: TextSpan(
//                         text: 'You agree to our ',
//                         style: GoogleFonts.beVietnamPro(
//                           fontWeight: FontWeight.w300,
//                           fontSize: 16.5,
//                           height: 1.5,
//                           color: Colors.white,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: 'privacy policy',
//                             style: GoogleFonts.beVietnamPro(
//                               color: Colors.blue,
//                               fontStyle: FontStyle.italic,
//                             ),
//                             recognizer: TapGestureRecognizer()..onTap = () => PrivacyPolicyPage(),
//
//                           ),
//                           TextSpan(
//                             text: ' and ',
//                             style: GoogleFonts.beVietnamPro(
//                               fontWeight: FontWeight.w300,
//                               fontSize: 16.5,
//                               height: 1.5,
//                               color: Colors.white,
//                             ),
//                           ),
//                           TextSpan(
//                             text: 'terms and conditions',
//                             style: GoogleFonts.beVietnamPro(
//                               color: Colors.blue,
//                               fontStyle: FontStyle.italic,
//                             ),
//                             recognizer: TapGestureRecognizer()..onTap = () => PrivacyPolicyPage(),
//                           ),
//                         ],
// // =======
              Container(height: 55,
                margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Color(0xFF292938),
                ),

                child: TextField(
                  controller: _phoneController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    // Remove the default border to show the customized one
                    border: InputBorder.none,
                    hintText: 'Mobile number',
                    hintStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFF637587),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF637587), // Border color when not focused
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFFE0E0E0), // Border color when focused
                        width: 1.5,
// >>>>>>> 9e3f3a1ad3317a5838219c59acad554d7748e289
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    if (!value.startsWith('+91 ')) {
                      _phoneController.text = '+91 ';
                      _phoneController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _phoneController.text.length),
                      );
                    }
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                      activeColor: Color(0xFF2B8AE8),
                      checkColor: Colors.white,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'You agree to our ',
                          style: GoogleFonts.beVietnamPro(
                            fontWeight: FontWeight.w300,
                            fontSize: 16.5,
                            height: 1.5,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: 'privacy policy',
                              style: GoogleFonts.beVietnamPro(
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
                              ),
                              recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                _navigateToPrivacyPolicy(context);
                              },
                            ),
                            TextSpan(
                              text: ' and ',
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.5,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: 'terms and conditions',
                              style: GoogleFonts.beVietnamPro(
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _navigateToTermsConditions(context);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 20, 15.8, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: isChecked
                          ? LinearGradient(
                        colors: [Color(0xffe5195e), Color(0xffc2185b)], // Gradient colors when checked
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null, // No gradient when unchecked
                      color: isChecked ? null : Color(0xFF637587), // Grey background when unchecked
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Transparent to show container's color/gradient
                        shadowColor: Colors.transparent, // No shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: isChecked
                          ? () async {
                        await storage.write(key: 'phone_number', value: _phoneController.text);
                        _sendPhoneNumberToBackend(); // Send phone number to backend
                      }
                          : null, // Disabled when unchecked
                      child: Text(
                        'Send OTP',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.5,
                          letterSpacing: 0.2,
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
                width: 390,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
    );
  }

  void _navigateToTermsConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsConditionsPage()),
    );
  }
}




// class _navigateToTermsConditions {
// }

// Create separate pages for Privacy Policy and Terms & Conditions



class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: Center(child: Text('Privacy Policy content goes here.')),
    );
  }
}

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms and Conditions')),
      body: Center(child: Text('Terms and Conditions content goes here.')),
    );
  }
}
