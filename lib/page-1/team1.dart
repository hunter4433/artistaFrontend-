import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/page-1/team2.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'bottomNav_artist.dart';

class TeamMember {
  String? name;
  String? email;
  String? role;
  File? imageFile;

  TeamMember({this.name, this.email, this.role, this.imageFile});

  Map<String, dynamic> toJson() {
    return {
      'member_name': name,
      'email': email,
      'role': role,
      // 'profile_photo': imageFile,
      // Add other properties as needed
    };
  }

}

class team1signup extends StatefulWidget {
  @override
  _team1signupState createState() => _team1signupState();
}

class _team1signupState extends State<team1signup> {
  TextEditingController teamController = TextEditingController();
  int selectedTeamMembers = 2; // Default selected value
  List<Widget> teamMemberFields = []; // List to hold team member fields
  List<TeamMember> teamMembersData = []; // List to hold team member data

  List<File?> _imageFiles = []; // List to hold uploaded image files

  final storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getid() async {
    return await storage.read(key: 'id'); // Assuming you stored the token with key 'token'
  }

  Future<void> sendDataToBackend() async {
    // Print team member fields and controller for debugging
    // print(teamMemberFields);
    // print(teamController);
    String? token = await _getToken();
    print(token);
    String? team_id = await _getid();
    print(team_id);

    // Replace 'your_api_endpoint' with your actual API endpoint
    final String apiUrl = 'http://127.0.0.1:8000/api/artist/team_member';

    try {
      // Modify the map function to include the team_id
      final jsonData = teamMembersData.map((member) {
        Map<String, dynamic> memberData = member.toJson();
        memberData['team_id'] = team_id; // Add the team_id to the member's data
        return memberData;
      }).toList();



      // Make POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(jsonData), // Send the JSON-encoded data
      );
      // print(response);

      print(_imageFiles);
      // Check if request is successful
      if(response.statusCode == 200) {
        print('Data sent successfully');
        print('Response: ${response.body}');
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        // print('Error: $e');
        throw Exception('Failed to send data. Error ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // // Function to pick image from gallery
  // Future<void> _getImage(int index) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _imageFiles[index] = File(pickedFile.path);
  //       print(_imageFiles[index]);
  //       teamMembersData[index].imageFile = _imageFiles[index];
  //     } else {
  //       _imageFiles[index] = null; // Set to null if no image is selected
  //       teamMembersData[index].imageFile = null;
  //       print('No image selected.');
  //     }
  //   });
  // }



  @override
  void dispose() {
    teamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    // void buildTeamMemberFields();

    // Function to pick image from gallery
// Function to pick image from gallery
    Future<void> _getImage(int index) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _imageFiles[index] = File(pickedFile.path);
          teamMembersData[index].imageFile = _imageFiles[index];
          print(_imageFiles[index]);
          // buildTeamMemberFields(); // Rebuild fields dynamically when image is picked
        } else {
          _imageFiles[index] = null;
          teamMembersData[index].imageFile = null;
          print('No image selected.');
        } });
    }

    // Function to build team member fields dynamically
    void buildTeamMemberFields() {
      teamMemberFields.clear(); // Clear existing fields
      teamMembersData.clear(); // Clear existing team member data
      _imageFiles.clear(); // Clear existing image files
      for (int i = 0; i < selectedTeamMembers; i++) {
        _imageFiles.add(null);
        print('hi');// Initialize with null
        print(_imageFiles[i]);
        teamMembersData.add(TeamMember()); // Add a new TeamMember object
        teamMemberFields.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24 * fem),
              Text(
                'Team Member ${i + 1}',
                style: TextStyle(
                  fontSize: 16 * ffem,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1e0a11),
                ),
              ),
              SizedBox(height: 16 * fem),
              Row(
                children: [
                      GestureDetector(
                    onTap: () {
                      _getImage(i); // Function to pick image
                    },
                    child: Container(
                      width: 190 * fem,
                      height: 220 * fem,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12 * fem),
                      ),
                      child: _imageFiles[i] != null
                          ? Image.file(
                        _imageFiles[i]!,
                        width: 190 * fem,
                        height: 220 * fem,
                        fit: BoxFit.cover,
                      )
                          : Icon(
                        Icons.add_photo_alternate,
                        size: 50 * fem,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 13 * fem),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          onChanged: (value) {
                            teamMembersData[i].name = value; // Update name
                          },
                          decoration: InputDecoration(
                            hintText: 'Name..',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20 * fem),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe5195e)),
                              borderRadius: BorderRadius.circular(20 * fem),
                            ),
                          ),
                        ),
                        SizedBox(height: 10 * fem),
                        TextField(
                          onChanged: (value) {
                            teamMembersData[i].email = value; // Update email
                          },
                          decoration: InputDecoration(
                            hintText: 'Email..',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20 * fem),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe5195e)),
                              borderRadius: BorderRadius.circular(20 * fem),
                            ),
                          ),
                        ),
                        SizedBox(height: 10 * fem),
                        TextField(
                          onChanged: (value) {
                            teamMembersData[i].role = value; // Update role
                          },
                          decoration: InputDecoration(
                            hintText: 'Role..',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20 * fem),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe5195e)),
                              borderRadius: BorderRadius.circular(20 * fem),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }



    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Your Team',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Be Vietnam Pro',
            fontSize: 19 * ffem,
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
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16 * fem),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How Many People are on Your Team?',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.5 * ffem / fem,
                    color: Color(0xff1e0a11),
                  ),
                ),
                SizedBox(height: 16 * fem),
                TextField(
                  controller: teamController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        selectedTeamMembers = int.parse(value) ?? 0;
                        buildTeamMemberFields(); // Rebuild fields when value changes
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20 * fem),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffe5195e)),
                      borderRadius: BorderRadius.circular(20 * fem),
                    ),
                  ),
                ),
                SizedBox(height: 24 * fem),
                ...teamMemberFields,
                // Spread operator to add all fields from the list
                SizedBox(height: 24 * fem),
                ElevatedButton(
                  onPressed: () {

                    sendDataToBackend();
                    // Here you can access teamMembersData and send it in an API call
                    // Example:
                    // for (var member in teamMembersData) {
                    //   print('Name: ${member.name}, Email: ${member.email}, Role: ${member.role}, Image: ${member.imageFile}');
                    //   // Make API call here with member data
                    // }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavart()),
                    );
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
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: 'Be Vietnam Pro',
                      fontSize: 16 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.5 * ffem / fem,
                      letterSpacing: 0.2399999946 * fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
