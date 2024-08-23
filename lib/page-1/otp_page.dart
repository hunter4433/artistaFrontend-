import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/artist_sign_up.dart';
import '../config.dart';
import 'bottomNav_artist.dart';
import'loc_service_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class VerificationCodeInputScreen extends StatefulWidget {
  final String verificationId;

  VerificationCodeInputScreen({required this.verificationId});

  @override
  _VerificationCodeInputScreenState createState() => _VerificationCodeInputScreenState();
}

class _VerificationCodeInputScreenState extends State<VerificationCodeInputScreen> {

  final List<TextEditingController> _codeController = List.generate(6, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());



  // final _codeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = FlutterSecureStorage();

  Future<String?> _getFCMToken() async {
    return await storage.read(key: 'fCMToken'); // Assuming you stored the token with key 'token'
  }

  Future<String?> _getPhoneNumber() async {
    return await storage.read(key:'phone_number'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getSelectedValue() async {
    return await storage.read(key:'selected_value'); // Assuming you stored the token with key 'token'
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

  Future<bool> login(String? fCMToken, String? phoneNumber) async {
    if (fCMToken == null || phoneNumber == null) return false;

    final String artistLoginUrl = '${Config().apiDomain}/artist/login';
    final String userLoginUrl = '${Config().apiDomain}/user/login';
    String? userType = await _getSelectedValue();


    String url = (userType == 'hire') ? userLoginUrl : artistLoginUrl;
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
    print(userType);
    if(userType=='hire') {
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        print(body);
         int id = body['user']['id'] ;
        await storage.write(key: 'user_id', value: id.toString());
        return true;
      } else {
        print('Failed to update FCM token: ${response.reasonPhrase}');
        return false;
      }
    }
    else{
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        print(body);
         int id = body['artist']['id'];
         print(id);
        await storage.write(key: 'id', value: id.toString());
        return true;
      } else {
        print('Failed to update FCM token: ${response.body}');
        return false;
      }
    }
  }



  Future<bool> sendFCMTokenBackend(String? fCMToken, String? phoneNumber) async {
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

    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: smsCode,
    );

    try {
      await _auth.signInWithCredential(credential);
      String? fCMToken = await _getFCMToken();
      String? phoneNumber = await _getPhoneNumber();
      String? userType = await _getSelectedValue();


      bool loginSuccessful = await login(fCMToken, phoneNumber);
      if (loginSuccessful) {
        await storage.write(key: 'authorised', value: 'true');
        _navigateToHome(userType);
      } else {
        bool success = await sendFCMTokenBackend(fCMToken, phoneNumber);
        if (success) {
          await storage.write(key: 'authorised', value: 'true');
          _navigateToHome(userType);
        } else {
          _showSnackBar('Check your internet connection');
        }
      }
    } catch (e) {
      print('Failed to sign in: $e');
      _showSnackBar('Failed to sign in: $e');
    }
  }

  void _navigateToHome(String? userType) {
    if (userType == 'hire') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ServiceCheckerPage ()),
      );
    } else if (userType == 'solo_artist') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => artist_cred()),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged In Successfully')),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121217),
      body: Padding(
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
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF121217),
                          ),
                          child: Container(
                            height: 72,
                            padding: EdgeInsets.fromLTRB(16, 28, 16, 20),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 15, 16, 24),
                        child: Center(
                          child: Text(
                            'Enter the code we just texted you',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 22,
                              height: 1.3,
                              letterSpacing: -0.3,
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
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xFF292938),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 0.9,
                                  child: TextField(
                                    controller: _codeController[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
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
                                          FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                                        } else {
                                          _focusNodes[index].unfocus();
                                          // Perform any action when the last character is entered
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
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 21.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 21.5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF388FE5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () async {
                                  // Call your function here
                                  _signInWithPhoneNumber();
                                },
                                child: Text(
                                  'Next',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Send Code Again',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
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

