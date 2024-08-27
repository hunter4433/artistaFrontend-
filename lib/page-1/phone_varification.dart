import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/gestures.dart'; // Import for GestureRecognizer

class PhoneNumberInputScreen extends StatefulWidget {
  @override
  _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  bool isChecked = false;
  final _phoneController = TextEditingController(text: '+91 ');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = FlutterSecureStorage();

  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        String errorMessage;
        if (e.code == 'invalid-phone-number') {
          errorMessage = 'The provided phone number is not valid.';
        } else {
          errorMessage = 'Something went wrong: ${e.message}';
        }
        _showSnackBar(errorMessage);
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeInputScreen(
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Code auto retrieval timeout');
      },
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navigateToPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PrivacyPolicyPage()), // Define this page separately
    );
  }

  void _navigateToTermsConditions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsConditionsPage()), // Define this page separately
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 88, 0, 6.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 35,
              margin: EdgeInsets.fromLTRB(0, 15, 0, 15.5),
              child: Text(
                'Enter your mobile number',
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                  letterSpacing: -0.7,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18.7, 10, 18.7, 24),
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
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 24),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF292938)),
                borderRadius: BorderRadius.circular(7),
                color: Color(0xFF292938),
              ),
              padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: TextField(
                controller: _phoneController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Mobile number',
                  hintStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF637587),
                  ),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  if (!value.startsWith('+91 ')) {
                    _phoneController.text = '+91 ';
                    _phoneController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _phoneController.text.length));
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              ..onTap = _navigateToPrivacyPolicy,
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
                              ..onTap = _navigateToTermsConditions,
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isChecked ? Color(0xffe5195e) : Colors.grey, // Color when enabled/disabled
                        disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Explicitly set color for disabled state
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: isChecked
                          ? () async {
                        await storage.write(key: 'phone_number', value: _phoneController.text);
                        _verifyPhoneNumber();
                      }
                          : null, // Disabled state when not checked
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
    );
  }
}

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