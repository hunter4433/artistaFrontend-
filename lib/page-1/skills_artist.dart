import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../config.dart';
import '../utils.dart';
import 'bottomNav_artist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ArtistCredentials2 extends StatefulWidget {
  final File? profilePhoto;


  ArtistCredentials2({
    this.profilePhoto,
  });
  @override
  _ArtistCredentials2State createState() => _ArtistCredentials2State();
  String? selectedOption;
}




class _ArtistCredentials2State extends State<ArtistCredentials2> {
  TextEditingController _subskillController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _hourlyPriceController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  String? selectedOption;

  String _selectedSkill = ''; // Variable to store the selected skill
  List<String> _skills = ['Musician', 'Comedian', 'Visual Artist', 'Dancer', 'Chef', 'Magician'];

  // List of skills
  String _selectedSubSkill = ''; // Variable to store the selected sub-skill
  List<String> _subSkills = []; // List of sub-skills based on the selected skill

  // Selected options in the sub-skill dropdown
  List<String> _selectedSubSkills = [];
  bool _isLoading = false;



  Future<String?> _getFCMToken() async {
    return await storage.read(key: 'fCMToken'); // Assuming you stored the token with key 'token'
  }
  Future<String?> _getPhoneNumber() async {
    return await storage.read(key:'phone_number'); // Assuming you stored the token with key 'token'
  }

  Future<Map<String, String?>> profileSharedPreferences() async {
    SharedPreferences prof=await SharedPreferences.getInstance();
    return{
      'profile_photo': prof.getString('imageFilePath'),
    };
  }

  Future<Map<String, dynamic?>> getAllSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'age': prefs.getString('age'),
      'name': prefs.getString('name'),
      'address': prefs.getString('address'),
      'latitude': prefs.getDouble('latitude')?.toString(),
      'longitude': prefs.getDouble('longitude')?.toString(),
    };
  }

  final storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token'); // Assuming you stored the token with key 'token'
  }

  Future<bool> _sendDataToBackend() async {
    String? profilePhotoPath = widget.profilePhoto?.path;

    print(profilePhotoPath);
    String? phone_number = await _getPhoneNumber();
    try {
      // Get shared preferences data
      Map<String, dynamic?> sharedPreferencesData = await getAllSharedPreferences();
      Map<String, String?> profilePreferencesData = await profileSharedPreferences();

      // var profilePhoto=profilePreferencesData['profile_photo'];
      File profilePhotoFile = File(profilePhotoPath!);
      // print(profilePhotoFile);
      // print(_image1);
      // print(_image2);

      // print(profile_photo);

      // Get authentication token
      String? token = await _getToken();

      String? fCMToken= await _getFCMToken();


        // Select images from gallery
        List<File?> imageFiles = [_image1, _image2, _image3, _image4,profilePhotoFile];
        List<File?> videoFiles = [_video1, _video2, _video3, _video4];



          // Prepare data to send to the backend
          Map<String, String> artistData = {
            'phone_number': phone_number!,
            'skills': _selectedSubSkill,
            'about_yourself': _experienceController.text,
            'price_per_hour': _hourlyPriceController.text,
            'skill_category': _selectedSkill,
            'special_message': _messageController.text,
            'fcm_token':fCMToken!,
          };

          // Merge sharedPreferencesData with artistData
          Map<String, String?> mergedData = {...sharedPreferencesData, ...artistData};
          // Upload images and store paths
          print(imageFiles.length);
          List<String> imagePaths = await _uploadImages(imageFiles);
          List<String> videoPaths = await uploadVideo(videoFiles);
           print(videoPaths);

           if(videoPaths.length == videoFiles.length){
             for(int i=0; i < videoFiles.length; i++){
               mergedData['video${i+1}']= videoPaths[i];
             }


           }
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


          // Convert data to JSON format
          String jsonData = json.encode(mergedData);
          print(jsonData);

          // Example URL, replace with your actual API endpoint
          String apiUrl = '${Config().apiDomain}/artist/info';
          // await Future.delayed(Duration(seconds: 3));

          // Make POST request to the API
          var response = await http.post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/vnd.api+json',
              'Accept': 'application/vnd.api+json',
              // 'Authorization': 'Bearer $token', // Include the token in the header
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
            String id = responseData['data']['id'];
            await storage.write(key: 'id', value: id);

            String skill = responseData['data']['skill_category'];
            print(id);
            print(skill);
            return true ;
          } else {
            // Request failed, handle error
            print('Failed to send data. Status code: ${response.statusCode}');
            // Example error handling
            print('Error response: ${response.body}');
          }
        } else {
          print('No images selected');
        }

    } catch (e) {
      // Handle network errors
      print('Error sending data: $e');
    }
    return false;
  }

  Future<List<String>> uploadVideo(List<File?> videoFiles) async {
    final uri = Uri.parse('${Config().apiDomain}/upload-video');
    List<String> videoPaths = [];

    try {
      for (File? videoFile in videoFiles) {
        if (videoFile != null) {
          var request = http.MultipartRequest('POST', uri);

          var videoStream = http.ByteStream(videoFile.openRead());
          var videoLength = await videoFile.length();

          var multipartFile = http.MultipartFile(
            'video',
            videoStream,
            videoLength,
            filename: videoFile.path.split('/').last,
          );

          request.files.add(multipartFile);

          var response = await request.send();

          if (response.statusCode == 201) {
            var d = await response.stream.bytesToString();
            String path = json.decode(d)['videoPath'];
            print(path);
            videoPaths.add(path); // Correctly add the path to the list
          } else {
            print('Video upload failed for ${videoFile.path} with status: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      print('An error occurred during video upload: $e');
    }

    return videoPaths; // Return the list of uploaded video paths
  }



  @override
  void initState() {
    super.initState();
    _selectedSkill = _skills.first; // Initialize selected skill with the first item in the list
    _updateSubSkills(_selectedSkill); // Update sub-skills based on the selected skill
  }

  File? _image1;
  File? _image3;
  File? _image4;
  File? _image2;
  File? _video1;
  File? _video2;
  File? _video3;
  File? _video4;
  VideoPlayerController? _controller1;
  VideoPlayerController? _controller2;
  VideoPlayerController? _controller3;
  VideoPlayerController? _controller4;
  final ImagePicker _picker = ImagePicker();



  File? _imageForSearchedSection; // Variable to store the selected image for the searched section

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

  void _updateSubSkills(String skill) {
    setState(() {
      _subSkills.clear(); // Clear the previous sub-skills
      switch (skill) {
        case 'Musician':
          _subSkills.addAll(['Guitar', 'Piano', 'Violin']);
          break;
        case 'Comedian':
          _subSkills.addAll(['Stand-up', 'Impersonation', 'Sketch']);
          break;
        case 'Visual Artist':
          _subSkills.addAll(['Painting', 'Sculpture', 'Drawing']);
          break;
        case 'Magician':
          _subSkills.addAll(['Magician', 'Sculpture', 'Drawing']);
          break;
        case 'Dancer':
          _subSkills.addAll(['freestyle', 'classical', 'hip-hop']);
          break;
      }
      _selectedSubSkill = _subSkills.first; // Initialize selected sub-skill with the first item in the list
    });
  }







  Future<void> _pickImage1() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image1 = File(pickedFile.path);
        // await uploadImageAndStorePath(File(pickedFile.path));
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
    if (_controller1 != null) {
      await _controller1!.dispose();
    }

    if (result != null) {

      setState(() {
        _video1 = File(result.files.single.path!);
        _controller1 = VideoPlayerController.file(_video1!);
        _controller1!.initialize();
      });
      print(_video1);
    }
  }

  Future<void> _pickVideo2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (_controller2 != null) {
      await _controller2!.dispose();
    }

    if (result != null) {
      setState(() {
        _video2 = File(result.files.single.path!);
        _controller2 = VideoPlayerController.file(_video2!);
        _controller2!.initialize();
      });
      print('this is video2:$_video2');
    }
  }

  Future<void> _pickVideo3() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (_controller3 != null) {
      await _controller3!.dispose();
    }

    if (result != null) {
      setState(() {
        _video3 = File(result.files.single.path!);
        _controller3 = VideoPlayerController.file(_video3!);
        _controller3!.initialize();
      });
      print(_video3);
    }
  }

  Future<void> _pickVideo4() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (_controller4 != null) {
      await _controller4!.dispose();
    }

    if (result != null) {
      setState(() {
        _video4 = File(result.files.single.path!);
        _controller4 = VideoPlayerController.file(_video4!);
        _controller4!.initialize();
      });
      print(_video4);
    }
  }


  @override
  void dispose() {
    _subskillController.dispose();
    _experienceController.dispose();
    _hourlyPriceController.dispose();
    _messageController.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context,) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Center(
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 20 * fem,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFF121217),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(color:Color(0xFF121217),
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
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 60 * fem,
                              child: DropdownButtonFormField<String>(
                                value: _selectedSkill,
                                items: _skills.map((String skill) {
                                  return DropdownMenuItem<String>(
                                    value: skill,
                                    child: Text(skill,style: TextStyle(fontSize: 18, color: Colors.white),),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedSkill = value!;
                                    _updateSubSkills(_selectedSkill); // Update sub-skills based on the selected skill
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Choose Skill',
                                  hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Colors.white),
                                  ),
                                ),
                                style: TextStyle(color:  Color(0xFF9E9EB8)),
                                dropdownColor: Color(0xFF292938),
                              ),
                            ),
                            SizedBox(
                              height: 14 * fem,
                            ),
                            Container(
                              width: double.infinity,
                              height: 60 * fem,
                              child: DropdownButtonFormField<String>(
                                value: _selectedSubSkill,
                                items: _subSkills.map((String subSkill) {
                                  return DropdownMenuItem<String>(
                                    value: subSkill,
                                    child: Text(subSkill, style: TextStyle(fontSize: 18, color: Colors.white),),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedSubSkill = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Sub-Skill',
                                  hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12 * fem),
                                    borderSide: BorderSide(width: 1.25, color:  Color(0xFF9E9EB8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Colors.white),
                                  ),
                                ),
                                style: TextStyle(color:  Color(0xFF9E9EB8)),
                                dropdownColor: Color(0xFF292938),
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
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(

                              width: double.infinity,
                              // Adjusted height to match the height of the outer container
                              height: 70 * fem,

                              child: TextField(
                                controller: _experienceController,
                                decoration: InputDecoration(
                                  hintText: 'Years of Experience you have',
                                  hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(width: 1.25, color:Color(0xFF9E9EB8),),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Color(0xffe5195e) ),
                                  ),
                                ),
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 11 * fem),
                              child: Text(
                                'Do you have your own equipment  (microphone, speakers, etc.) for the performance?',
                                style: SafeGoogleFont(
                                  'Plus Jakarta Sans',
                                  fontSize: 16 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 70 * fem, // Adjusted height to match the outer container
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Colors.white),
                                  ),
                                  hintText: 'Your Answer',
                                  hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8)),
                                  ),
                                ),
                                value: selectedOption, // The currently selected value (nullable)
                                items: ['Yes', 'No'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(color: Colors.white,fontSize: 16)), // Dropdown item text
                                  );
                                }).toList(),
                                dropdownColor: Color(0xff1a1a1a), // Background color of dropdown menu
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOption = newValue; // Update selected option
                                  });
                                },
                              ),
                            )
                        ] ),
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
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 10 * fem),
                              child: Text(
                                'How Much Do You Charge Per Hour ?',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 18 * fem),
                              child: Text(
                                '⦾ Include transportation in the total price for city bookings.'
                                    ' For out-of-city bookings, charges can be discussed with the host \n\n'
                                    '⦾ HomeStage will charge a 20% fee on the total price.',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 16.5 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 56 * fem,
                              child: TextField(
                                controller: _hourlyPriceController,
                                keyboardType: TextInputType.number, // Ensures that only numbers are entered
                                decoration: InputDecoration(
                                  hintText: _hourlyPriceController.text.isEmpty ? 'Your Total Per Hour Price' : null, // Hint text only when the field is empty
                                  hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                                  prefixText: 'Rs ', // Prefix Rs that stays in place as user types
                                  prefixStyle: TextStyle(color: Colors.white, fontSize: 19), // Style for the Rs
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Colors.white),
                                  ),
                                ),
                                style: TextStyle(color: Colors.white, fontSize: 19), // Style for the text entered by the user
                                onChanged: (value) {
                                  // Rebuild the widget when the text changes to manage the hintText visibility
                                  (context as Element).markNeedsBuild();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                       Padding(
                        padding: EdgeInsets.fromLTRB(1 * fem, 30 * fem, 16 * fem, 0 * fem),

                        child: const SizedBox(
                          height: 23,

                          child: Text(
                            'Upload Your Work Samples',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20 ,
                              fontWeight: FontWeight.w400,
                              height: 1.5 ,
                              color: Colors.white,
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
                  height: 860 * fem,
                  decoration: BoxDecoration(
                    color: Color(0xFF121217),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 30,

                          child: Text(
                            'Photos For the Portfolio',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontFamily: 'Be Vietnam Pro',
                            ),
                          ),
                        ),
                      ),
                      GridView.count(physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        children: [
                          GestureDetector(
                            onTap: _pickImage1,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10*fem),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _image1 != null
                                  ? Image.file(_image1!, fit: BoxFit.cover)
                                  : Icon(Icons.add,color: Colors.white,),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickImage2,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10*fem),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _image2 != null
                                  ? Image.file(_image2!, fit: BoxFit.cover)
                                  : Icon(Icons.add,color: Colors.white,),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickImage3,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10*fem),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _image3 != null
                                  ? Image.file(_image3!, fit: BoxFit.cover)
                                  : Icon(Icons.add,color: Colors.white,),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickImage4,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10*fem),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _image4 != null
                                  ? Image.file(_image4!, fit: BoxFit.cover)
                                  : Icon(Icons.add,color: Colors.white,),
                            ),
                          ),

                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0,20,0,0),
                        child: SizedBox(
                          height: 40,

                          child: Text(
                            'Upload Your Videos Here',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontFamily: 'Be Vietnam Pro',
                            ),
                          ),
                        ),
                      ),
                      GridView.count(physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        children: [
                          GestureDetector(
                            onTap: _pickVideo1,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10*fem),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _controller1 != null
                                  ? VideoPlayer(_controller1!)
                                  : Icon(Icons.add,color: Colors.white,),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickVideo2,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10*fem),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _controller2 != null
                                  ? VideoPlayer(_controller2!)
                                  : Icon(Icons.add,color: Colors.white,),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickVideo3,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10*fem),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _controller3 != null
                                  ? VideoPlayer(_controller3!)
                                  : Icon(Icons.add,color: Colors.white,),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickVideo4,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10*fem),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _controller4 != null
                                  ? VideoPlayer(_controller4!)
                                  : Icon(Icons.add,color: Colors.white,),
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
                      Container(color: Color(0xFF121217),
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 24 * fem),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 18 * fem),
                              child: Text(
                                'Special message for the host',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            Container(

                              width: double.infinity,
                              height: 70 * fem,

                              child: TextField(
                                controller: _messageController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'I don\'t work after 11 !',
                                  hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8),),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12 * fem),
                                    borderSide: BorderSide(width: 1.25, color: Colors.white),
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
          Padding(
            padding: const EdgeInsets.only(left: 7, right: 7, bottom: 30),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleButtonClick,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffe5195e),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                minimumSize: Size(double.infinity, 14),
              ),
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text(
                  'Finish',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    letterSpacing: 0.24,
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

  Future<void> _handleButtonClick() async {
    setState(() {
      _isLoading = true;
    });

    getAllSharedPreferences();
    bool wait = await _sendDataToBackend();

    setState(() {
      _isLoading = false;
    });


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavart(data: {},)),
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

    try {
      // Your image upload API endpoint
      var uploadUrl = Uri.parse('${Config().apiDomain}/upload-image');

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
      } else {
        throw Exception('Failed to upload image. Status code: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      // Handle errors if needed
      print('Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }

    return imagePath;
  }


}
