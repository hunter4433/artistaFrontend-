import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/page-1/team2.dart';
import '../utils.dart';

class team1signup extends StatefulWidget {
  @override
  _team1signupState createState() => _team1signupState();
}

class _team1signupState extends State<team1signup> {
  TextEditingController teamController = TextEditingController();
  int selectedTeamMembers = 2; // Default selected value
  List<Widget> teamMemberFields = []; // List to hold team member fields

  List<File?> _imageFiles = []; // List to hold uploaded image files

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

  // Function to pick image from gallery
  Future<void> _getImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFiles[index] = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to build team member fields dynamically
  void buildTeamMemberFields() {
    teamMemberFields.clear(); // Clear existing fields
    _imageFiles.clear(); // Clear existing image files
    for (int i = 0; i < selectedTeamMembers; i++) {
      _imageFiles.add(null); // Initialize with null
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
                InkWell(
                  onTap: () {
                    _getImage(i); // Function to pick image
                  },
                  child: Container(
                    width: 180 * fem,
                    height: 200 * fem,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20 * fem),
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
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(right: 8 * fem),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Age..',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20 * fem),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffe5195e)),
                                    borderRadius: BorderRadius.circular(20 * fem),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextField(
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
                          ),
                        ],
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
                ...teamMemberFields, // Spread operator to add all fields from the list
                SizedBox(height: 24 * fem),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => team2signup()),
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
