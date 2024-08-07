import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/page0.dart';

class account_delete extends StatelessWidget {

  // Function to delete account
  Future<bool> _deleteAccount() async {
    final storage = FlutterSecureStorage();

    Future<String?> _getToken() async {
      return await storage.read(key: 'token');
    }

    Future<String?> _getId() async {
      return await storage.read(key: 'id');
    }

    Future<String?> _getKind() async {
      return await storage.read(key: 'selected_value');
    }

    String? token = await _getToken();
    String? id = await _getId();
    String? kind = await _getKind();

    print(token);
    print(id);
    print(kind);

    String apiUrlHire = 'http://127.0.0.1:8000/api/info/$id';
    String apiUrlArtist='http://127.0.0.1:8000/api/artist/info/$id';
    String apiUrlTeam='http://127.0.0.1:8000/api/artist/team_info/$id';

    try {
      // Make DELETE request to the API based on the value of 'kind'
      var response;
      if (kind == 'hire') {
        // Make API call for kind value 1
        response = await http.delete(
          Uri.parse(apiUrlHire),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            'Authorization': 'Bearer $token',
          },
        );
      } else if (kind == 'solo_artist') {
        // Make API call for kind value 2
        // Update apiUrl if needed
        response = await http.delete(
          Uri.parse(apiUrlArtist),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            'Authorization': 'Bearer $token',
          },
        );
      } else if (kind == 'team') {
        // Make API call for kind value 3
        // Update apiUrl if needed
        response = await http.delete(
          Uri.parse(apiUrlTeam),
          headers: <String, String>{
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
            'Authorization': 'Bearer $token',
          },
        );
      } else {
        // Handle other cases if needed
        print('Invalid value of kind: $kind');

      }

      // Check if request was successful (status code 204)
      if (response.statusCode == 204) {
        // Account deleted successfully
        print('Account deleted successfully');
        return true;

      } else {
        // Request failed, handle error
        print('Failed to delete account. Status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle network errors
      print('Error deleting account: $e');
    }
    return false;
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
                        onPressed: () async {
                          bool deleted= await _deleteAccount();
                          // _deleteAccount();
                          if (deleted) {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>
                                Scene()));
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Logout failed. Please try again.'),
                                duration: Duration(seconds: 3), // Adjust the duration as needed
                              ),
                            );
                          }
                          // Call function to delete account
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
