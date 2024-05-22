import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../utils.dart';
// import 'team1.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'team1.dart';
import 'package:test1/page-1/team1.dart';




class team2signup extends StatefulWidget {
  final File? profilePhoto;

  team2signup ({
    this.profilePhoto,
  });
  @override
  _ArtistCredentials2State createState() => _ArtistCredentials2State();
}

class _ArtistCredentials2State extends State<team2signup> {
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _hourlyPriceController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  List<String> _skills = ['Musician', 'Comedian', 'Visual Artist', 'Dancer', 'Chef', 'Magician'];
  String? selectedSkill;

  File? _image1;
  File? _image3;
  File? _image4;
  File? _image2;
  File? _video1;
  File? _video2;
  VideoPlayerController? _controller1;
  VideoPlayerController? _controller2;
  AudioPlayer _audioPlayer = AudioPlayer();
  File? _audioFile;
  File? _imageForSearchedSection; // Variable to store the selected image for the searched section

  final storage = FlutterSecureStorage();
  Future<Map<String, String?>> getAllSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'alt_phone_number': prefs.getString('alt_phone_number'),
      'team_name': prefs.getString('name'),
      'address': prefs.getString('address'),
      'phone_number': prefs.getString('phone_number'),
      'profile_photo': prefs.getString('imageFilePath'),
    };
  }


  // Function to pick an image for the searched section
  Future<void> _pickImageForSearchedSection() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageForSearchedSection = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _sendDataToBackend() async {

    String? profilePhotoPath = widget.profilePhoto?.path;

    File profilePhotoFile = File(profilePhotoPath!);
    Future<String?> _getToken() async {
      return await storage.read(key: 'token'); // Assuming you stored the token with key 'token'
    }
    try {
      // Get shared preferences data
      Map<String, String?> sharedPreferencesData = await getAllSharedPreferences();


      // var profilePhoto=profilePreferencesData['profile_photo'];
      // File profilePhotoFile = File(profilePhoto!);
      // print(profilePhotoFile);

      // print(profile_photo);

      // Get authentication token
      String? token = await _getToken();
      // Check if token is not null
      if (token != null) {
        // Select images from gallery
        List<File?> imageFiles = [_image1, _image2, _image3, _image4,profilePhotoFile];
        print(_skills);


        // Check if images are selected
        if (true) {
          // Prepare data to send to the backend
          Map<String, dynamic> artistData = {
            // 'skills': _selectedSubSkill,
            'about_team': _experienceController.text,
            'price_per_hour': _hourlyPriceController.text,
            'skill_category': selectedSkill,
            'special_message': _messageController.text,
          };

          // Merge sharedPreferencesData with artistData
          Map<String, String?> mergedData = {...sharedPreferencesData, ...artistData};
          // Upload images and store paths
          print(imageFiles.length);
          List<String> imagePaths = await _uploadImages(imageFiles);
          // print(imageFiles.length);
          //
          // Ensure imagePaths contains the profile photo path
          if (imagePaths.length == imageFiles.length) {
            // If it does, proceed to merge data
            for (int i = 0; i < imageFiles.length; i++) {
              if (i == imageFiles.length - 1) {
                // Last item (profile photo)
                mergedData['profile_photo'] = imagePaths[i];
              } else {
                // Other image files
                mergedData['image${i + 1}'] = imagePaths[i];
              }
            }
          } else {
            print('this side mohit');
            // Handle the case where imagePaths length doesn't match imageFiles length
          }

          // Convert data to JSON format
          String jsonData = json.encode(mergedData);
          print(jsonData);

          // Example URL, replace with your actual API endpoint
          String apiUrl = 'http://127.0.0.1:8000/api/artist/team_info';
          // await Future.delayed(Duration(seconds: 3));

          // Make POST request to the API
          var response = await http.post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/vnd.api+json',
              'Accept': 'application/vnd.api+json',
              'Authorization': 'Bearer $token', // Include the token in the header
            },
            body: jsonData,
          );

          // Check if request was successful (status code 200)
          if (response.statusCode == 201) {
            // Data sent successfully, handle response if needed
            print('Data sent successfully');
            // Example response handling
            print('Response: ${response.body}');

            Map<String, dynamic> responseData = jsonDecode(response.body);
            int id = responseData['id']; // Assuming 'id' is of type int in the JSON response
            await storage.write(key: 'id', value: id.toString()); // Convert int to String before storing
            print(id.toString()); // Convert int to String before printing

          } else {
            // Request failed, handle error
            print('Failed to send data. Status code: ${response.statusCode}');
            // Example error handling
            print('Error response: ${response.body}');
          }
        } else {
          print('No images selected');
        }
      } else {
        // Handle the case where token is null, perhaps by showing an error message
        print("Token is null");
      }
    } catch (e) {
      // Handle network errors
      print('Error sending data: $e');
    }
  }



  @override
  void dispose() {
    _experienceController.dispose();
    _hourlyPriceController.dispose();
    _messageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (_audioFile != null) {
      try {
        await _audioPlayer.play(_audioFile!.path as Source);
        print('Audio playback started');
      } catch (e) {
        print('Error playing audio: $e');
      }
    }
  }

  Future<void> _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickImage1() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image1 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickImage2() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image2 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickImage3() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image3 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickImage4() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image4 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickVideo1() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _video1 = File(result.files.single.path!);
        _controller1 = VideoPlayerController.file(_video1!);
        _controller1!.initialize();
      });
    }
  }

  Future<void> _pickVideo2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _video2 = File(result.files.single.path!);
        _controller2 = VideoPlayerController.file(_video2!);
        _controller2!.initialize();
      });
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
          style: SafeGoogleFont(
            'Be Vietnam Pro',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(16 * fem, 12 * fem, 16 * fem, 12 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                              child: Text(
                                'Your Skills',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 18 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5 * ffem / fem,
                                  color: Color(0xff1e0a11),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 60 * fem,
                              child: DropdownButtonFormField<String>(
                                value: _skills.first,
                                items: _skills.map((String skill) {
                                  return DropdownMenuItem<String>(
                                    value: skill,
                                    child: Text(skill),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedSkill = value; // Update selected skill when it changes
                                  });
                                  // No need to update sub-skills here
                                },
                                decoration: InputDecoration(
                                  hintText: 'Choose Skill',
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
                      SizedBox(
                        height: 19 * fem,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 9 * fem),
                              child: Text(
                                'Tell Users about Yourself',
                                style: SafeGoogleFont(
                                  'Plus Jakarta Sans',
                                  fontSize: 18 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5 * ffem / fem,
                                  color: Color(0xff1e0a11),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 80 * fem,
                              child: TextField(
                                controller: _experienceController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'Summary of your experience',
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
                      SizedBox(
                        height: 24 * fem,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 3 * fem),
                              child: Text(
                                'How Much Do You Charge Per Hour ?',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 18 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5 * ffem / fem,
                                  color: Color(0xff1e0a11),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                              child: Text(
                                '(Please Include Transportation Charges in this Price Only)',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 15 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 56 * fem,
                              child: TextField(
                                controller: _hourlyPriceController,
                                decoration: InputDecoration(
                                  hintText: 'Your Total Per Hour Price ',
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(1 * fem, 20 * fem, 16 * fem, 0 * fem),
                        child: const SizedBox(
                          height: 23,
                          child: Text(
                            'Upload Your Work samples',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: Color(0xff1e0a11),
                              fontFamily: 'Be Vietnam Pro',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(16 * fem, 0 * fem, 16 * fem, 1 * fem),
                  width: double.infinity,
                  height: 970 * fem,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upload Audio',
                              style: TextStyle(fontSize: 18),
                            ),
                            ElevatedButton(
                              onPressed: _audioFile == null ? _pickAudio : _playAudio,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xffe5195e), // Adjust background color if needed
                                ),
                                foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white, // Change the text color here
                                ),
                              ),
                              child: Text(
                                _audioFile == null ? 'Upload' : 'Play',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 20,
                          child: Text(
                            'Photo For the Searched Section',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontFamily: 'Be Vietnam Pro',
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _pickImageForSearchedSection(); // Call the function to pick an image for the searched section
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 10 * fem),
                          width: 358 * fem,
                          height: 238.66 * fem,
                          color: Colors.grey.withOpacity(0.3),
                          child: _imageForSearchedSection != null
                              ? Image.file(_imageForSearchedSection!, fit: BoxFit.cover)
                              : Center(
                            child: Icon(
                              Icons.upload_outlined,
                              size: 48.0 * fem,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 20,
                          child: Text(
                            'Photos For the Portfolio',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontFamily: 'Be Vietnam Pro',
                            ),
                          ),
                        ),
                      ),
                      GridView.count(physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        children: [
                          GestureDetector(
                            onTap: _pickImage1,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _image1 != null
                                  ? Image.file(_image1!, fit: BoxFit.cover)
                                  : Icon(Icons.add),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickImage2,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _image2 != null
                                  ? Image.file(_image2!, fit: BoxFit.cover)
                                  : Icon(Icons.add),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickImage3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _image3 != null
                                  ? Image.file(_image3!, fit: BoxFit.cover)
                                  : Icon(Icons.add),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickImage4,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _image4 != null
                                  ? Image.file(_image4!, fit: BoxFit.cover)
                                  : Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 20,
                          child: Text(
                            'Upload Your Videos Here',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontFamily: 'Be Vietnam Pro',
                            ),
                          ),
                        ),
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        children: [
                          GestureDetector(
                            onTap: _pickVideo1,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _controller1 != null
                                  ? VideoPlayer(_controller1!)
                                  : Icon(Icons.add),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickVideo2,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _controller2 != null
                                  ? VideoPlayer(_controller2!)
                                  : Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16 * fem, 0 * fem, 16 * fem, 12 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 24 * fem),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                              child: Text(
                                'Leave a special message for the host',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5 * ffem / fem,
                                  color: Color(0xff1e0a11),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 80 * fem,
                              child: TextField(
                                controller: _messageController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'I don\'t work after 11 !',
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
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _sendDataToBackend();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => team1signup()),
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
                            minimumSize: Size(double.infinity, 14 * fem),
                          ),
                          child: Center(
                            child: Text(
                              'Finish',
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<List<String>> _uploadImages( imageFiles) async {
    List<String> imagePaths = [];
    // print(imageFiles.length);
    for (int i = 0; i < imageFiles.length; i++) {
      if (imageFiles[i] != null) {
        // Upload the image and store its path
        String paths = await uploadImagesAndStorePaths(imageFiles[i]);
        // for (String imagePath in paths) {
        imagePaths.add(paths);

      }
    }
    return imagePaths;
  }


  Future<String> uploadImagesAndStorePaths(File? imageFile) async {
    if (imageFile == null) {
      throw ArgumentError('Image file cannot be null');
    }
    String imagePath = '';
    // Your image upload API endpoint
    var uploadUrl = Uri.parse('http://127.0.0.1:8000/api/upload-image');

    // Create a multipart request
    var request = http.MultipartRequest('POST', uploadUrl);

    // Add the image file to the request
    var image = await http.MultipartFile.fromPath('image', imageFile.path);

    request.files.add(image);

    // Send the request to upload the image
    var streamedResponse = await request.send();
    print(streamedResponse);

    // Check if the image upload was successful
    if (streamedResponse.statusCode == 200) {
      // Parse the response to get the image URL or file path
      var response = await streamedResponse.stream.bytesToString();

      imagePath = json.decode(response)['imagePath'];
    }
    //   else {
    //     throw Exception('Failed to upload image');
    //   }
    // } catch (e) {
    //   // Handle errors if needed
    //   print('Error uploading image: $e');
    //   throw Exception('Error uploading image: $e');
    // }
    return imagePath;
  }
}
