import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/return_code.dart';
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
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
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
  bool isUpiSelected = false;
  bool isAccountSelected = false;
  TextEditingController _upiController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _ifscController = TextEditingController();
  TextEditingController _accountHolderNameController = TextEditingController();


  String _selectedSkill = ''; // Variable to store the selected skill
  List<String> _skills = ['Musician', 'Comedian', 'Visual Artist', 'Dancer', 'Chef', 'Magician'];

  // List of skills
  String _selectedSubSkill = ''; // Variable to store the selected sub-skill
  List<String> _subSkills = []; // List of sub-skills based on the selected skill

  // Selected options in the sub-skill dropdown
  List<String> _selectedSubSkills = [];
  bool _isLoading = false;
  bool _isCompressing = false;
  // double _progress = 0.0;
  StreamSubscription? _subscription;

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
  Future<void> storeBankDetails() async {
    final url = Uri.parse('${Config().apiDomain}/artist-bank-details');
    String? artist_id= await storage.read(key: 'artist_id');

    // Collect data from controllers
    final Map<String, dynamic> bankData = {
      'UPI_id': _upiController.text,
      'account_number': _accountNumberController.text,
      'IFSC_code':  _ifscController.text,
      'account_holder_name': _accountHolderNameController.text,
      'artist_id': artist_id ?? '',
      // 'team_id': int.tryParse(_teamIdController.text) ?? null,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body:jsonEncode(bankData),
      );

      if (response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bank details saved successfully!')),
        );
      } else {
        // Failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save bank details.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }


  Future<bool> _onFinishButtonClicked() async {
    try {
      // Send data to the backend and get the ID
      bool dataSent = await _sendDataToBackend();
         await  storeBankDetails();
      // if (!dataSent) {
      //   print('Failed to send data to backend. mohit ');
      //   return false;
      // }

      // Retrieve the stored ID
      String? id = await storage.read(key: 'artist_id');
      if (id == null) {
        print('Failed to retrieve ID from storage.');
        return false;
      }

      List<File?> imageFiles = [_image1, _image2, _image3, widget.profilePhoto];
      List<File?> videoFiles = [_video1, _video2, _video3, _video4];

      // Run upload functions in parallel with ID
      final results = await Future.wait([
        uploadImages(imageFiles, id),      // Upload images with ID
        uploadVideos(videoFiles, id)         // Upload videos with ID
      ]);

      bool imagesUploaded = results[0] as bool; // Result from _uploadImages
      bool videosUploaded = results[1] as bool; // Result from uploadVideo

      // Handle the results
     if (imagesUploaded && videosUploaded) {
    //   if (imagesUploaded){
        print('All operations completed successfully.');
        return true;
      } else {
        print('Some operations failed.');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('An error occurred: $e');
    }
    return false;
  }


  Future<bool> _sendDataToBackend() async {
    String? profilePhotoPath = widget.profilePhoto?.path;
    String? phoneNumber = await _getPhoneNumber();

    try {
      // Get shared preferences data
      Map<String, dynamic?> sharedPreferencesData = await getAllSharedPreferences();
      Map<String, String?> profilePreferencesData = await profileSharedPreferences();

      // Get authentication token and FCM token
      String? token = await _getToken();
      String? fCMToken = await _getFCMToken();

      // Prepare data to send to the backend
      Map<String, String> artistData = {
        'phone_number': phoneNumber!,
        'skills': _selectedSubSkill,
        'about_yourself': _experienceController.text,
        'price_per_hour': _hourlyPriceController.text,
        'skill_category': _selectedSkill,
        'special_message': _messageController.text,
        'fcm_token': fCMToken!,
        'sound_system':'0',
      };

      // Merge sharedPreferencesData with artistData
      Map<String, String?> mergedData = {...sharedPreferencesData, ...artistData};

      // Ensure that the images and videos were successfully uploaded
      // if (profilePhotoPath != null) {
      //   mergedData['profile_photo'] = profilePhotoPath;
      // }

      // Convert data to JSON format
      String jsonData = json.encode(mergedData);
      print(jsonData);

      // Example URL, replace with your actual API endpoint
      String apiUrl = '${Config().apiDomain}/artist/info';

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

      // Check if the request was successful (status code 201)
      if (response.statusCode == 201) {
        // Data sent successfully, handle response if needed
        print('Data sent successfully');
        print('Response: ${response.body}');

        Map<String, dynamic> responseData = jsonDecode(response.body);
        String id = responseData['data']['id'];
        await storage.write(key: 'artist_id', value: id);

        String skill = responseData['data']['attributes']['skill_category'];
        print(id);
        print(skill);

        return true;
      } else {
        // Request failed, handle error
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (e) {
      // Handle network errors
      print('Error sending data: $e');
    }

    return false;
  }




  Future<bool> uploadVideos(List<File?> videoFiles, String id) async {
    try {
      for (File? videoFile in videoFiles) {
        if (videoFile != null) {
          // Trim the video if it is longer than 15 seconds
          // File trimmedVideo = await trimVideoIfNeeded(videoFile);
          bool uploadSuccess = await uploadVideo(videoFile, id);

          if (!uploadSuccess) {
            print('Failed to upload video: ${videoFile.path}');
            return false; // If any video fails to upload, return false
          }
        }
      }
      return true; // All videos uploaded successfully
    } catch (e) {
      print('Error uploading videos: $e');
      return false;
    }
  }

  // Future<File> trimVideoIfNeeded(File videoFile) async {
  //   String inputPath = videoFile.path;
  //   String outputPath =
  //       '${(await getTemporaryDirectory()).path}/trimmed_${videoFile.path.split('/').last}';
  //
  //   try {
  //     // FFmpeg command to retrieve video duration in seconds.
  //     String durationCommand = '-i $inputPath -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1';
  //
  //     // Execute the FFmpeg command.
  //     var session = await FFmpegKit.execute(durationCommand);
  //
  //     // Check the result of the session.
  //     final returnCode = await session.getReturnCode();
  //
  //     if (ReturnCode.isSuccess(returnCode)) {
  //       // Extract the output from FFmpeg session.
  //       final output = await session.getOutput();
  //       double duration = double.tryParse(output!.trim()) ?? 0.0;
  //
  //       print('Video duration is $duration seconds.');
  //
  //       if (duration > 20) {
  //         print('Trimming video to 20 seconds...');
  //
  //         // FFmpeg command to trim the video to 20 seconds.
  //         String trimCommand = '-i $inputPath -t 20 -c copy $outputPath';
  //         await FFmpegKit.execute(trimCommand);
  //
  //         print('Video trimmed to 20 seconds: $outputPath');
  //         return File(outputPath);
  //       } else {
  //         print('No trimming needed.');
  //         return videoFile; // Return original video if no trimming is required.
  //       }
  //     } else {
  //       print('Failed to get video information. FFmpeg return code: $returnCode');
  //       return videoFile;
  //     }
  //   } catch (e) {
  //     print('Error while processing video: $e');
  //     return videoFile;
  //   }
  // }

  Future<bool> uploadVideo(File videoFile, String id) async {
    try {
      var uploadUrl = Uri.parse('${Config().apiDomain}/upload-video/$id');

      var request = http.MultipartRequest('POST', uploadUrl);

      var videoStream = http.ByteStream(videoFile.openRead());
      var videoLength = await videoFile.length();

      var multipartFile = http.MultipartFile(
        'video',
        videoStream,
        videoLength,
        filename: videoFile.path.split('/').last,
      );

      request.files.add(multipartFile);

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 201) {
        var response = await streamedResponse.stream.bytesToString();
        print(response);
        return true;
      } else {
        print('Video upload failed with status: ${streamedResponse.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error uploading video: $e');
      return false;
    }
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
                                  print('soun dystem : $selectedOption');
                                },
                              ),
                            )
                        ] ),
                      ),
                      SizedBox(
                        height: 8 * fem,
                      ),


                    ],

                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(16 * fem, 0 * fem, 16 * fem, 0 * fem),
                  width: double.infinity,
                  height: 485 * fem,
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
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'Be Vietnam Pro',
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: _pickImage1,
                              child: Container(
                                width: 150 * fem,  // Set your desired width
                                height: 170 * fem, // Set your desired height
                                margin: EdgeInsets.only(right: 16.0), // Spacing between boxes
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: _image1 != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10 * fem), // Rounded corners
                                  child: Image.file(_image1!, fit: BoxFit.cover),
                                )
                                    : Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                            GestureDetector(
                              onTap: _pickImage2,
                              child: Container(
                                width: 150 * fem,
                                height: 170 * fem,
                                margin: EdgeInsets.only(right: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: _image2 != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10 * fem), // Rounded corners
                                  child: Image.file(_image2!, fit: BoxFit.cover),
                                )
                                    : Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                            GestureDetector(
                              onTap: _pickImage3,
                              child: Container(
                                width: 150 * fem,
                                height: 170 * fem,
                                margin: EdgeInsets.only(right: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: _image3 != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10 * fem), // Rounded corners
                                  child: Image.file(_image3!, fit: BoxFit.cover),
                                )
                                    : Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),


                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: SizedBox(
                          height: 20,
                          child: Text(
                            'Upload Your Videos Here',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'Be Vietnam Pro',
                            ),
                          ),
                        ),
                      ),

// Description to indicate the duration limit
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                        child: Text(
                          'Keep the video duration maximum to 15 seconds.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                            fontFamily: 'Be Vietnam Pro',
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: _pickVideo1,
                              child: Container(
                                width: 150 * fem,
                                height: 170 * fem,
                                margin: EdgeInsets.only(right: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: _controller1 != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  child: VideoPlayer(_controller1!),
                                )
                                    : Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                            GestureDetector(
                              onTap: _pickVideo2,
                              child: Container(
                                width: 150 * fem,
                                height: 170 * fem,
                                margin: EdgeInsets.only(right: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: _controller2 != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  child: VideoPlayer(_controller2!),
                                )
                                    : Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                            GestureDetector(
                              onTap: _pickVideo3,
                              child: Container(
                                width: 150 * fem,
                                height: 170 * fem,
                                margin: EdgeInsets.only(right: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: _controller3 != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  child: VideoPlayer(_controller3!),
                                )
                                    : Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),

                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16 * fem, 0 * fem, 16 * fem, 18 * fem),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8* fem),
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
                ),


                Container(
                  padding: EdgeInsets.fromLTRB(16 * fem, 0 * fem, 16 * fem, 10 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: Color(0xFF121217),
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 20 * fem),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 14 * fem),
                              child: Text(
                                'For Receiving Payments',
                                style: TextStyle(
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Radio Buttons for Payment Options
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<bool>(
                                    title: Text(
                                      'UPI ID',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    value: true,
                                    groupValue: isUpiSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        isUpiSelected = value!;
                                        isAccountSelected = !value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<bool>(
                                    title: Text(
                                      'Account',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    value: true,
                                    groupValue: isAccountSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        isAccountSelected = value!;
                                        isUpiSelected = !value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // UPI ID Input Box
                            Visibility(
                              visible: isUpiSelected,
                              child: Container(
                                width: double.infinity,
                                height: 70 * fem,
                                margin: EdgeInsets.only(top: 10 * fem),
                                child: TextField(
                                  controller: _upiController,
                                  decoration: InputDecoration(
                                    hintText: 'Your UPI ID',
                                    hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(
                                        width: 1.25,
                                        color: Color(0xFF9E9EB8),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(
                                        width: 1.25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            // Account Details Input Box (Account No, IFSC, Holder Name)
                            Visibility(
                              visible: isAccountSelected,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 70 * fem,
                                    margin: EdgeInsets.only(top: 10 * fem),
                                    child: TextField(
                                      controller: _accountNumberController,
                                      decoration: InputDecoration(
                                        hintText: 'Account Number',
                                        hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12 * fem),
                                          borderSide: BorderSide(
                                            width: 1.25,
                                            color: Color(0xFF9E9EB8),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12 * fem),
                                          borderSide: BorderSide(
                                            width: 1.25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 70 * fem,
                                    margin: EdgeInsets.only(top: 10 * fem),
                                    child: TextField(
                                      controller: _ifscController,
                                      decoration: InputDecoration(
                                        hintText: 'IFSC Code',
                                        hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12 * fem),
                                          borderSide: BorderSide(
                                            width: 1.25,
                                            color: Color(0xFF9E9EB8),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12 * fem),
                                          borderSide: BorderSide(
                                            width: 1.25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 70 * fem,
                                    margin: EdgeInsets.only(top: 10 * fem),
                                    child: TextField(
                                      controller: _accountHolderNameController,
                                      decoration: InputDecoration(
                                        hintText: 'Account Holder Name',
                                        hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12 * fem),
                                          borderSide: BorderSide(
                                            width: 1.25,
                                            color: Color(0xFF9E9EB8),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12 * fem),
                                          borderSide: BorderSide(
                                            width: 1.25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                child : Text(
                  _isLoading ? 'loading...' : 'finish',
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
    // double _progress = 0.0;
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Color(0xfff5f5f5),
              content: SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe5195e)),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Your profile is generating...'
                          'It may take upto few minutes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff333333),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Percentage text
                    // Text(
                    //   '${_progress.toInt()}%', // Display the percentage
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w600,
                    //     color: Color(0xff333333),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    // // Simulate the process and update the percentage
    // for (int i = 0; i <= 100; i++) {
    //   await Future.delayed(Duration(milliseconds: 50)); // Adjust the speed
    //   setState(() {
    //     _progress = i.toDouble();
    //   });
    // }
    bool wait = await _onFinishButtonClicked();
    // Close the dialog once the process is complete
    Navigator.of(context).pop();

    // bool wait = await _onFinishButtonClicked();

    setState(() {
      _isLoading = false;
    });
if (wait) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BottomNavart(data: {})),
  );
}
  }


  Future<bool> uploadImages(List<File?> imageFiles, String id) async {
    try {
      var uploadUrl = Uri.parse('${Config().apiDomain}/upload-images/$id');
      var request = http.MultipartRequest('POST', uploadUrl);

      for (int i = 0; i < imageFiles.length; i++) {
        var imageFile = imageFiles[i];
        if (imageFile != null) {
          // Use 'profile_photo' for the last image, otherwise use 'image{i + 1}'
          String fieldName = (i == imageFiles.length - 1) ? 'profile_photo' : 'image${i + 1}';
          var image = await http.MultipartFile.fromPath(fieldName, imageFile.path);
          request.files.add(image);
        }
      }

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();
        print('Upload successful: $response');
        return true;
      } else {
        print('Upload failed with status: ${streamedResponse.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error uploading images: $e');
      return false;
    }
  }


}
