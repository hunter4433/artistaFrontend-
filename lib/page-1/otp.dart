import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import'loc_service_ui.dart';
class VerificationCodeInputScreen extends StatefulWidget {
  final String verificationId;

  VerificationCodeInputScreen({required this.verificationId});

  @override
  _VerificationCodeInputScreenState createState() => _VerificationCodeInputScreenState();
}

class _VerificationCodeInputScreenState extends State<VerificationCodeInputScreen> {
  final _codeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = FlutterSecureStorage();

  Future<String?> _getFCMToken() async {
    return await storage.read(key: 'fCMToken'); // Assuming you stored the token with key 'token'
  }

  Future<String?> _getPhoneNumber() async {
    return await storage.read(key:'phone_number'); // Assuming you stored the token with key 'token'
  }


  Future<void> sendFCMTokenBackend(String? fCMToken, String? phone_number) async {
    if (fCMToken == null || phone_number ==null) return;

    final String backendUrl = 'http://192.0.0.2:8000/api/basic';
    final response = await http.post(
      Uri.parse(backendUrl),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
      },
      body: jsonEncode(<String, String>{
        'fcm_token': fCMToken,
        'phone_number':phone_number,
      }),
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> body = json.decode(response.body);
      print(body);
      int id = body['id'];
      await storage.write(key: 'id', value: id.toString());
      print('FCM token and phone_number sent successfully');
    } else {
      print('Failed to send FCM token: ${response.reasonPhrase}');
    }
  }


  void _signInWithPhoneNumber() async {
    final smsCode = _codeController.text.trim();
    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: smsCode,
    );

    try {
      await _auth.signInWithCredential(credential);
      String? fCMToken= await _getFCMToken();
      String? phone_number = await _getPhoneNumber();
      print(fCMToken);
      print(phone_number);
      sendFCMTokenBackend(fCMToken,phone_number);
      // Navigate to home screen or wherever you want
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ServiceCheckerApp()), // Replace HomeScreen with your desired screen
      );
    } catch (e) {
      print('Failed to sign in: $e');
      // You can also show a snackbar or dialog here to notify the user of the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Verification Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Verification Code'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithPhoneNumber,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}


