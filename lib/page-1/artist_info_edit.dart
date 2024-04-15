import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/page-1/artsit_skills_edit.dart';

import '../utils.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Variables to hold profile data
  String _name = '';
  int _age = 0;
  String _phoneNo = '';
  String _address = '';
  File? _image;

  // Function to fetch profile data from backend
  void fetchProfileData() {
    // Call your backend API to fetch data
    // Update the state variables with fetched data
    setState(() {
      _name = 'John Doe'; // Example data
      _age = 30; // Example data
      _phoneNo = '1234567890'; // Example data
      _address = '123 Main St, City'; // Example data
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProfileData(); // Fetch profile data when screen initializes
  }

  // Function to update profile data to backend
  void updateProfileData() {
    // Call your backend API to update data
    // Display success or error message accordingly
    // For simplicity, we'll just print the data here
    print('Updated Profile:');
    print('Name: $_name');
    print('Age: $_age');
    print('Phone No: $_phoneNo');
    print('Address: $_address');
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            color:Color(0xffe5195e), // Change icon button color
            onPressed: () {
              updateProfileData(); // Call function to update profile data
              Navigator.pop(context); // Go back to previous screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Picture (You can implement this with ImagePicker)
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 190,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0), // Round the container
                  border: Border.all(color: Colors.grey), // Change border color
                ),
                alignment: Alignment.center,
                child: _image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.file(
                    _image!,
                    width: 190,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(Icons.person, size: 100, color: Colors.grey),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tap to change profile picture',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Name
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0), // Round the container
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffe5195e),), // Change focused border color
                  borderRadius: BorderRadius.circular(15.0), // Round the container
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Age
            TextFormField(
              initialValue: _age.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0), // Round the container
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:Color(0xffe5195e),), // Change focused border color
                  borderRadius: BorderRadius.circular(15.0), // Round the container
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _age = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),

            // Phone Number
            TextFormField(
              initialValue: _phoneNo,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0), // Round the container
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffe5195e),), // Change focused border color
                  borderRadius: BorderRadius.circular(15.0), // Round the container
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _phoneNo = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Address
            TextFormField(
              initialValue: _address,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0), // Round the container
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffe5195e),), // Change focused border color
                  borderRadius: BorderRadius.circular(15.0), // Round the container
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _address = value;
                });
              },
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditProfileScreen(),
  ));
}
