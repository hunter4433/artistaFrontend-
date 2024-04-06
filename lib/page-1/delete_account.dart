import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/page0.dart';

class account_delete extends StatelessWidget {

  // Function to delete account
  Future<void> _deleteAccount() async {
    // Example URL, replace with your actual API endpoint


    final storage = FlutterSecureStorage();
    // static const String Scene = '/page0';

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

    String apiUrl = 'http://127.0.0.1:8000/api/info/$id';

    try {
      // Make DELETE request to the API
      var response = await http.delete(
        Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            'Authorization': 'Bearer $token', // Include the token in the header
          },

      );

      // Check if request was successful (status code 200)
      if (response.statusCode == 204) {
        // Account deleted successfully, handle response if needed
        print('Account deleted successfully');

        // Example response handling
        // print('Response: ${response.body}');
      } else {
        // Request failed, handle error
        print('Failed to delete account. Status code: ${response.statusCode}');
        // Example error handling
        print('Error response: ${response.body}');
      }
    } catch (e) {
      // Handle network errors
      print('Error deleting account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(title: const Text('Account'),),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Container(
            width: double.infinity,
            height: 844*fem,
            decoration: BoxDecoration (
              color: Color(0xffffffff),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration (
                color: Color(0xffffffff),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(height: 674*fem,width: double.infinity,
                      padding: EdgeInsets.all(20),
                      child: const Text(
                        'Before proceeding with the deletion of your account, we want to ensure that '
                            'you\'re fully informed about the implications of this action. Deleting your '
                            'account will result in the permanent removal of all your data from our servers, '
                            'regardless of its secure encryption by Stargrime. '
                            '\n\nWe understand that this decision may be significant for you,'
                            ' and we want to reassure you that your security and privacy are '
                            'of the utmost importance to us. If you have any concerns or encounter '
                            'any issues during this process, please don\'t '
                            'hesitate to reach out to us through the customer'
                            ' support option available in the settings.'
                            '\n\nOur dedicated support team is here to assist'
                            ' you every step of the way and address any questions or concerns you may have. '
                            'Your satisfaction and peace of mind are our top priorities, and we\'re '
                            'committed to ensuring that you have a'
                            ' positive experience with our service.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff171111),
                          fontFamily: 'Be Vietnam Pro', // Change font family as needed
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 45, right: 45),
                      child: ElevatedButton(
                        onPressed: () {
                          _deleteAccount();
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>
                              Scene()));// Call function to delete account
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
                            'Delete Account',
                            style: TextStyle(
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w700,
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
      ),
    );
  }
}
