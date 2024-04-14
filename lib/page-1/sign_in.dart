import 'package:flutter/material.dart';
import '../utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'bottomNav_artist.dart';
import 'page1.dart';



class Scene extends StatefulWidget {
  @override
  _SceneState createState() => _SceneState();
}

class _SceneState extends State<Scene> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  final storage = FlutterSecureStorage();

  Future<bool> _login() async {
    Future<String?> _getToken() async {
      return await storage.read(key: 'token');
    }

    Future<String?> getSelectedValue() async {
      return await storage.read(key: 'selected_value');
    }

    // Get authentication token
    String? token = await _getToken();
    var kind = await getSelectedValue();
    print(kind);

    if (token != null) {
      Map<String, String> loginData = {
        'email': emailController.text,
        'password': passwordController.text,
      };
      String jsonData = json.encode(loginData);
      print(jsonData);
      // final response;

      String apiUrlHire = 'http://127.0.0.1:8000/api/login';
      String apiUrlArtist = 'http://127.0.0.1:8000/api/artist/login';
      if(kind=='hire') {
        final response = await http.post(
          Uri.parse(apiUrlHire),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            // 'Authorization': 'Bearer $token', // Include the token in the header
          },
          body: jsonData,
        );

        // Check if request was successful (status code 200)
        if (response.statusCode == 200) {
          // Data sent successfully, handle response if needed
          print('You Logged in successfully to hire ');
          // Example response handling
          print('Response: ${response.body}');

          Map<String, dynamic> responseData = jsonDecode(response.body);
          String token = responseData['data']['token'];

          // Store the token securely
          await storage.write(key: 'token', value: token);
          print(token);

          return true;
        } else {
          // Request failed, handle error
          print('Failed to send data. Status code: ${response.statusCode}');
          // Example error handling
          print('Error response: ${response.body}');
          return false;
        }
      }
      if(kind=='team' || kind=='solo_artist') {
        final response = await http.post(
          Uri.parse(apiUrlArtist),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            // 'Authorization': 'Bearer $token', // Include the token in the header
          },
          body: jsonData,
        );

        // Check if request was successful (status code 200)
        if (response.statusCode == 200) {
          // Data sent successfully, handle response if needed
          print('You Logged in successfully artist');
          // Example response handling
          print('Response: ${response.body}');

          Map<String, dynamic> responseData = jsonDecode(response.body);
          String token = responseData['data']['token'];

          // Store the token securely
          await storage.write(key: 'token', value: token);
          print(token);

          return true;
        } else {
          // Request failed, handle error
          print('Failed to send data. Status code: ${response.statusCode}');
          // Example error handling
          print('Error response: ${response.body}');
          return false;
        }
      }
    }
    return false; // Return false if token is null
  }


  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                    padding: EdgeInsets.fromLTRB(165.84 * fem, 28.75 * fem, 165.84 * fem, 15.75 * fem),
                    width: double.infinity,
                    height: 72 * fem,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Text(
                        'Sign In',
                        style: SafeGoogleFont(
                          'Be Vietnam Pro',
                          fontSize: 18 * ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.25 * ffem / fem,
                          letterSpacing: -0.2700000107 * fem,
                          color: Color(0xff171111),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 3 * fem),
                      padding: EdgeInsets.fromLTRB(16 * fem, 12 * fem, 16 * fem, 12 * fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Email Text Field
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 24 * fem),
                            padding: EdgeInsets.fromLTRB(16 * fem, 0, 20 * fem, 0),
                            decoration: BoxDecoration(
                              color: Color(0xfff4eff2),
                              borderRadius: BorderRadius.circular(12 * fem),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Icon(Icons.mail, color: Color(0xff876370)),
                              ],
                            ),
                          ),
                          // Password Text Field
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 24 * fem),
                            padding: EdgeInsets.fromLTRB(16 * fem, 0, 8 * fem, 0),
                            decoration: BoxDecoration(
                              color: Color(0xfff4eff2),
                              borderRadius: BorderRadius.circular(12 * fem),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: passwordController,
                                    obscureText: _isObscure,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isObscure ? Icons.visibility_off : Icons.visibility,
                                    color: Color(0xff876370),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Sign In Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    bool loggedIn = await _login();
                                    // Navigate only if login is successful
                                    if (loggedIn) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => BottomNavart()),
                                      );
                                    } else {
                                      // Optionally, you can show a snackbar or toast to inform the user about the login failure
                                      // Optionally, you can show a toast to inform the user about the login failure
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Login failed. Please try again.'),
                                          duration: Duration(seconds: 3), // Adjust the duration as needed
                                        ),
                                      );
                                    }
                                  } catch (error) {
                                    // Handle error if login fails
                                    print('Error during login: $error');

                                    // Optionally, you can show a snackbar or toast to inform the user about the login failure
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
                              child: Text(
                                'Sign In',
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
                          SizedBox(
                            height: 16 * fem,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to sign-up screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Scene1()), // Replace SignUpScreen with your actual sign-up screen widget
                              );
                            },
                            child: Text(
                              'Forget Password?\nDon\'t have an account Sign Up',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Be Vietnam Pro',
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff876370),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // End Image and Icon Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/page-1/images/vector-2.png',
                        ),
                      ),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 390 * fem,
                        height: 320 * fem,
                        child: Image.asset(
                          'assets/page-1/images/vector-3.png',
                          width: 390 * fem,
                          height: 320 * fem,
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
