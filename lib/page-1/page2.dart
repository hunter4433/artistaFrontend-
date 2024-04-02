import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/cred_user.dart';

class Scene2 extends StatefulWidget {
  @override
  _Scene2State createState() => _Scene2State();
}

class _Scene2State extends State<Scene2> {
  final secureStorage = FlutterSecureStorage();
  var emailUser = TextEditingController();
  var passwordUser = TextEditingController();
  var confirmPassword = TextEditingController();

  bool passwordsMatch = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  Future<void> _handleContinue() async {
    if (passwordUser.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty &&
        emailUser.text.isNotEmpty &&
        passwordsMatch) {
      // Prepare the request body
      Map<String, dynamic> requestBody = {
        'email': emailUser.text,
        'password': confirmPassword.text,
        'password_confirmation': confirmPassword.text,
      };

      // Convert the request body to JSON
      String requestBodyJson = jsonEncode(requestBody);

      try {
        // Make the API call
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/register'),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json'
          },
          body: requestBodyJson,
        );

        // Handle the response
        if (response.statusCode == 200) {
          // API call successful, handle the response here
          print('API call successful');
          print(response.body);

          Map<String, dynamic> responseData = jsonDecode(response.body);
          String token = responseData['data']['token'];

          // Store the token securely
          await secureStorage.write(key: 'token', value: token);

          // Navigate to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Signup_user(),
            ),
          );
        } else {
          // API call failed, handle the error
          print('Failed with status code: ${response.statusCode}');
          print(response.body);
          // Show a snackbar or toast to inform the user about the error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to register. Please try again.'),
            ),
          );
        }
      } catch (e) {
        // Handle exceptions
        print('Exception occurred: $e');
        // Show a snackbar or toast to inform the user about the exception
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign up',
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            fontSize: 29 * ffem,
            fontWeight: FontWeight.w700,
            height: 1.25 * ffem / fem,
            letterSpacing: -0.8000000119 * fem,
            color: Color(0xff1e0a11),
          ),
        ),
        backgroundColor: Color(0xffffffff),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            width: double.infinity,
            height: 844 * fem,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 250 * fem),
                    padding: EdgeInsets.fromLTRB(16 * fem, 24 * fem, 16 * fem, 12 * fem),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 24 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                                child: Text(
                                  'Email',
                                  style: GoogleFonts.beVietnamPro(
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
                                  controller: emailUser,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.email_outlined, color: Color(0xffeac6d3)),
                                    hintText: 'Email',
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
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                                child: Text(
                                  'Password',
                                  style: GoogleFonts.beVietnamPro(
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
                                  controller: passwordUser,
                                  obscureText: obscurePassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                        });
                                      },
                                      icon: Icon(
                                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: Color(0xffe5195e),
                                      ),
                                    ),
                                    hintText: 'Enter Password',
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
                              SizedBox(height: 16 * fem),
                              Container(
                                width: double.infinity,
                                height: 56 * fem,
                                child: TextField(
                                  controller: confirmPassword,
                                  obscureText: obscureConfirmPassword,
                                  onChanged: (value) {
                                    setState(() {
                                      passwordsMatch = value == passwordUser.text;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscureConfirmPassword = !obscureConfirmPassword;
                                        });
                                      },
                                      icon: Icon(
                                        obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                        color: Color(0xffe5195e),
                                      ),
                                    ),
                                    hintText: 'Confirm Password',
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
                              if (!passwordsMatch) ...[
                                SizedBox(height: 8 * fem),
                                Text(
                                  'Passwords do not match',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14 * ffem,
                                  ),
                                ),
                              ],
                              SizedBox(height: 16 * fem),
                              Center(
                                child: Text(
                                  'Or continue with Google',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xff1e0a11),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: ElevatedButton(
                      onPressed: () { _handleContinue();
                        if (passwordUser.text.isNotEmpty &&
                            confirmPassword.text.isNotEmpty &&
                            emailUser.text.isNotEmpty &&
                            passwordsMatch) {
                          String userEmail = emailUser.text;
                          String userPassword = passwordUser.text;
                          // print("User email= $userEmail, User Password= $userPassword");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Signup_user(),
                            ),
                          );
                        }
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
                          'Continue',
                          style: GoogleFonts.beVietnamPro(
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
          ),
        ),
      ),
    );
  }
}
