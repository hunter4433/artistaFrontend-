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
// <<<<<<< HEAD
// // >>>>>>> 9e3f3a1ad3317a5838219c59acad554d7748e289
// =======
// // // >>>>>>> 9e3f3a1ad3317a5838219c59acad554d7748e289
// >>>>>>> 3aa9a5af385f0477afcbf9c7282fe90ba960e750
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

                                ..onTap = () => _navigateToPrivacyPolicy(context),
// >>>>>>> 3aa9a5af385f0477afcbf9c7282fe90ba960e750
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

                                ..onTap = () => _navigateToTermsConditions(context),
                                // ..onTap = _navigateToTermsConditions ,

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
      MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
    );
  }
  void _navigateToTermsConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsConditionsScreen()),
    );
  }



}




// class _navigateToTermsConditions {
// }

// Create separate pages for Privacy Policy and Terms & Conditions


class PrivacyPolicyScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: Center(child: Text(
      '''We at HomeStage are committed to protecting your privacy. This Privacy Policy outlines how we collect, 
  use, and protect your personal information when you use our app. By using our services, you agree to the terms outlined below.

  1. Information We Collect
  - Location Data: We collect your location and the artist's location to provide tailored search results. This data is collected only while the app is in use, not in the background.
  - Contact Information: We collect the phone numbers of both users and artists to facilitate bookings. User phone numbers will not be shared with third parties, except for facilitating communication between users and artists. Artist phone numbers will be shared with users to complete the booking process, and vice versa.
  - Payment Information: For artists, we collect payment details (e.g., bank account information) to send payments for services rendered. HomeStage does not store credit card or payment gateway details on our servers.

  2. Use of Third-Party Services
  - We use third-party payment gateways to process payments. These services comply with Indian laws, and we ensure that your payment information is handled securely. However, we are not responsible for any issues arising from their service.

  3. Data Security
  - We take the security of your personal data seriously and use appropriate measures to protect it from unauthorized access, alteration, or disclosure.

  4. Changes to This Policy
  - We may update this Privacy Policy from time to time. You will be notified of any significant changes, and your continued use of the app signifies your acceptance of the updated terms.

  5. Contact Us
  - If you have any questions or concerns about this Privacy Policy, please contact us at [support@homestage].

  By using HomeStage, you agree to this Privacy Policy.
  ''',
    ),),);

  }
}

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms and Conditions')),
      body: Center(child: Text('''Effective Date: October 10, 2024

Welcome to HomeStage! By using our app, you agree to comply with and be bound by the following Terms and Conditions. Please read them carefully.

1. Use of the App
Eligibility: You must be at least 18 years old to use HomeStage. By registering or using the app, you confirm that you meet this requirement.
Services: HomeStage is a platform that connects users with artists for private events. We act as an intermediary and are not responsible for the quality of services provided by the artists.
Account Information: Users and artists are required to provide accurate and up-to-date information when creating an account. Falsifying information or impersonating another person is prohibited.
2. Bookings and Payments
Booking Process: Users can book artists through the app for private events. Once a booking is made, the artist's phone number will be shared with the user, and the user's phone number will be shared with the artist for coordination.
Payments: Payments for artist services are processed through third-party payment gateways. By using our services, you agree to the terms and conditions of the payment provider. HomeStage is not liable for any issues arising from payment processing.
Artist Payments: HomeStage collects bank details from artists to transfer payments for completed services. Payments will be made after the successful completion of the event, and any disputes must be resolved between the user and the artist.
3. Cancellation and Refunds
User Cancellations: Users may cancel bookings according to the cancellation policy set by the artist. Any applicable refunds will be processed through the payment gateway.
Artist Cancellations: Artists may cancel bookings in unforeseen circumstances, but repeated cancellations may result in penalties or account suspension.
4. Responsibilities and Liabilities
For Users: Users are responsible for ensuring the event details and requirements are accurate and for providing a safe environment for the artists. Users agree not to use the app for any unlawful or inappropriate activities.
For Artists: Artists are responsible for delivering the services agreed upon during the booking. Failure to provide services or unsatisfactory performance may lead to removal from the platform.
HomeStage’s Liability: HomeStage acts only as a facilitator between users and artists. We are not responsible for any issues that arise during the event, such as service quality, cancellations, or disputes. We are also not liable for any damages or losses incurred during an event.
5. Privacy
Your use of the app is governed by our Privacy Policy, which outlines how we collect, use, and protect your personal information.

6. Third-Party Services
HomeStage uses third-party services, including payment gateways. By using the app, you agree to the terms of these third-party services. We are not responsible for any issues related to their use.

7. Changes to Terms
We may update these Terms and Conditions from time to time. You will be notified of any significant changes, and your continued use of the app signifies your acceptance of the updated terms.

8. Termination
HomeStage reserves the right to suspend or terminate accounts that violate these Terms and Conditions or engage in fraudulent or unlawful activities.

9. Dispute Resolution
Any disputes arising from the use of HomeStage shall be resolved amicably between the user and the artist. In the event of legal action, it will be governed by the laws of India.

10. Contact Us
If you have any questions or concerns about these Terms and Conditions, please contact us at [support@homstage].

By using HomeStage, you agree to abide by these Terms and Conditions.''')),
    );
  }
}
