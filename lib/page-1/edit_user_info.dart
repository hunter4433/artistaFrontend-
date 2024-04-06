import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class user_information extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<user_information> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();

  final storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getid() async {
    return await storage.read(key: 'id'); // Assuming you stored the token with key 'token'
  }



  @override
  void initState() {
    super.initState();
    // Fetch user information from the backend
    fetchUserInformation();
  }

  Future<void> fetchUserInformation() async {

    String? token = await _getToken();
    String? id = await _getid();
    print (token);
    print (id);
    // Example URL, replace with your actual API endpoint
    String apiUrl = 'http://127.0.0.1:8000/api/info/$id';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
          'Authorization': 'Bearer $token', // Include the token in the header
        },
      );
      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> userData = json.decode(response.body);
        print(userData);

        // Update text controllers with fetched data
        setState(() {
          _nameController.text = userData['data']['attributes']['first_name'] ?? '';
          _lastNameController.text = userData['data']['attributes']['last_name'] ?? '';
          _phoneController.text = userData['data']['attributes']['phone_no'] ?? '';
          _buildingController.text = userData['data']['attributes']['house_no_building'] ?? '';
          _cityController.text = userData['data']['attributes']['city'] ?? '';
          _stateController.text = userData['data']['attributes']['state'] ?? '';
          _pinCodeController.text = userData['data']['attributes']['pin'] ?? '';
        });
      } else {
        print('Failed to fetch user information. Status code: ${response
            .statusCode}');
      }
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: [
          GestureDetector(
            onTap: () {
              _saveUserInformation(); // Call function to save user information
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.red, // Change the text color as needed
                    fontSize: 16, // Change the font size as needed
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: 844 * fem,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildEditableRow("Name:", _nameController, fem, ffem),
                  buildEditableRow(
                      "Last Name:", _lastNameController, fem, ffem),
                  buildEditableRow("Phone No:", _phoneController, fem, ffem),
                  buildEditableRow("Building:", _buildingController, fem, ffem),
                  buildEditableRow("City:", _cityController, fem, ffem),
                  buildEditableRow("State:", _stateController, fem, ffem),
                  buildEditableRow("Pin Code:", _pinCodeController, fem, ffem),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditableRow(String label, TextEditingController controller,
      double fem, double ffem) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe5195e),
                  // Change the focused border color as needed
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveUserInformation() async {
    final storage = FlutterSecureStorage();

    Future<String?> _getToken() async {
      return await storage.read(key: 'token'); // Assuming you stored the token with key 'token'
    }

    Future<String?> _getid() async {
      return await storage.read(key: 'id'); // Assuming you stored the token with key 'token'
    }


    String? token = await _getToken();
    String? id = await _getid();
    print (token);
    print (id);
    // Example URL, replace with your actual API endpoint
    String apiUrl = 'http://127.0.0.1:8000/api/info/$id';

    // Prepare data to send to the backend
    Map<String, dynamic> userData = {
      'first_name': _nameController.text,
      'last_name': _lastNameController.text,
      'phone_no': _phoneController.text,
      'house_no_building': _buildingController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'pin': _pinCodeController.text,
    };

    try {
      // Make PUT request to the API
      var response = await http.patch(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
          'Authorization': 'Bearer $token', // Include the token in the header
        },
        body: jsonEncode(userData),
      );

      // Check if request was successful (status code 200)
      if (response.statusCode == 200) {
        // User information saved successfully, handle response if needed
        print('User information saved successfully');
        // Example response handling
        print('Response: ${response.body}');
      } else {
        // Request failed, handle error
        print('Failed to save user information. Status code: ${response
            .statusCode}');
        // Example error handling
        print('Error response: ${response.body}');
      }
    } catch (e) {
      // Handle network errors
      print('Error saving user information: $e');
    }
  }

}
