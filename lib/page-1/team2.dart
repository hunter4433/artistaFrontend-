import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../config.dart';
import '../utils.dart';
// import 'team1.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'team1.dart';
import 'package:test1/page-1/team1.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';

import 'bottomNav_artist.dart';

class team2signup extends StatefulWidget {
  final File? profilePhoto;

  team2signup({
    this.profilePhoto,
  });
  @override
  _ArtistCredentials2State createState() => _ArtistCredentials2State();
}

class _ArtistCredentials2State extends State<team2signup> {
  TextEditingController _subskillController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _hourlyPriceController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  String? selectedOption;
  bool isUpiSelected = false;
  bool isAccountSelected = false;
  TextEditingController _upiController = TextEditingController();
  TextEditingController _pastController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _ifscController = TextEditingController();
  TextEditingController _accountHolderNameController = TextEditingController();

  String _selectedSkill = ''; // Selected skill
  List<String> _skills = [
    'Musician',
    'Comedian',
    'Visual Artist',
    'Dancer',
    'Chef',
    'Magician'
  ];
  final Map<String, List<String>> _skillToSubSkills = {
    'Musician': ['Singing', 'Instrumental', 'Songwriting'],
    'Comedian': ['Stand-Up', 'Improv', 'Sketch Comedy'],
    'Visual Artist': ['Painting', 'Sketching', 'Digital Art'],
    'Dancer': ['Ballet', 'Hip-Hop', 'Contemporary'],
    'Chef': ['Baking', 'Grilling', 'Vegan Cooking'],
    'Magician': ['Card Tricks', 'Illusions', 'Mentalism'],
  };
  List<String> _subSkills = []; // Sub-skills for the selected skill
  List<String> _selectedSubSkills = [];

  List<String> _equipmentOptions = [
    'Sound System',
    'Lighting',
    'Stage Setup',
    'Microphone',
    'Projector'
  ];
  List<String> _selectedEquipment = [];

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
  AudioPlayer _audioPlayer = AudioPlayer();
  File? _audioFile;
  File?
      _imageForSearchedSection; // Variable to store the selected image for the searched section
  bool _isLoading = false;
  final storage = FlutterSecureStorage();
  Future<Map<String, String?>> getAllSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'alt_phone_number': prefs.getString('alt_phone_number'),
      'team_name': prefs.getString('name'),
      'address': prefs.getString('address'),
      // 'phone_number': prefs.getString('phone_number'),
      'profile_photo': prefs.getString('imageFilePath'),
    };
  }

  Future<String?> _getPhoneNumber() async {
    return await storage.read(key: 'phone_number');
  }

  Future<String?> _getFCMToken() async {
    return await storage.read(key: 'fCMToken');
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
  // String? profilePhotoPath = widget.profilePhoto?.path;
  //
  // File profilePhotoFile = File(profilePhotoPath!);

  Future<void> storeBankDetails() async {
    final url = Uri.parse('${Config().apiDomain}/artist-bank-details');
    String? team_id = await storage.read(key: 'team_id');

    // Collect data from controllers
    final Map<String, dynamic> bankData = {
      'UPI_id': _upiController.text,
      'account_number': _accountNumberController.text,
      'IFSC_code': _ifscController.text,
      'account_holder_name': _accountHolderNameController.text,
      'artist_id': team_id ?? '',
      // 'team_id': int.tryParse(_teamIdController.text) ?? null,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bankData),
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
      await storeBankDetails();
      // if (!dataSent) {
      //   print('Failed to send data to backend. mohit ');
      //   return false;
      // }

      // Retrieve the stored ID
      String? id = await storage.read(key: 'team_id');
      print(id);
      if (id == null) {
        print('Failed to retrieve ID from storage.');
        return false;
      }

      List<File?> imageFiles = [_image1, _image2, _image3, widget.profilePhoto];
      List<File?> videoFiles = [_video1, _video2, _video3, _video4];

      // Run upload functions in parallel with ID
      final results = await Future.wait([
        uploadImages(imageFiles, id), // Upload images with ID
        uploadVideos(videoFiles, id) // Upload videos with ID
      ]);

      bool imagesUploaded = results[0] as bool; // Result from _uploadImages
      bool videosUploaded = results[1] as bool; // Result from uploadVideo

      // Handle the results
      if (imagesUploaded && videosUploaded) {
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
    File profilePhotoFile = File(profilePhotoPath!);
    String? phoneNumber = await _getPhoneNumber();
    print('phone number is :$phoneNumber');

    try {
      // Get shared preferences data
      Map<String, dynamic?> sharedPreferencesData =
          await getAllSharedPreferences();
      // Map<String, String?> profilePreferencesData = await profileSharedPreferences();

      // Get authentication token and FCM token
      // String? token = await _getToken();
      String? fCMToken = await _getFCMToken();

      // Prepare data to send to the backend
      // Prepare data to send to the backend
      Map<String, String> artistData = {
        'phone_number': phoneNumber!,
        'price_per_hour': _hourlyPriceController.text,

        'special_message': _messageController.text,
        'fcm_token': fCMToken!,
        // Convert "Yes" to "1" and "No" to "0" as strings
        'sound_system': selectedOption == 'Yes' ? '1' : '0',
      };

      // Merge sharedPreferencesData with artistData
      Map<String, String?> mergedData = {
        ...sharedPreferencesData,
        ...artistData
      };

      // Ensure that the images and videos were successfully uploaded
      // if (profilePhotoPath != null) {
      //   mergedData['profile_photo'] = profilePhotoPath;
      // }

      // Convert data to JSON format
      String jsonData = json.encode(mergedData);
      print(jsonData);

      // Example URL, replace with your actual API endpoint
      String apiUrl = '${Config().apiDomain}/artist/team_info';

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
        int id = responseData['id'];
        await storage.write(key: 'team_id', value: id.toString());

        String skill = responseData['skill_category'];
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
          // Trim the video if needed
          // File trimmedVideo = await trimVideoIfNeeded(videoFile);
          bool uploadSuccess = await uploadVideo(videoFile, id);

          if (!uploadSuccess) {
            print('Failed to upload video: ${videoFile.path}');
            return false; // If any video fails, stop further uploads
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
  //   String outputPath = '${(await getTemporaryDirectory()).path}/trimmed_${videoFile.path.split('/').last}';
  //
  //   // FFmpeg command to get the first 20 seconds of the video
  //   String trimCommand = '-i $inputPath -t 20 -c copy $outputPath';
  //
  //   await FFmpegKit.execute(trimCommand);
  //
  //   // Check if the output file exists; if not, return the original file
  //   File outputFile = File(outputPath);
  //   if (outputFile.existsSync()) {
  //     print('Video trimmed to 20 seconds: $outputPath');
  //     return outputFile;
  //   } else {
  //     print('No trimming needed or trimming failed.');
  //     return videoFile; // Use original if trimming fails
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
        print(
            'Video upload failed with status: ${streamedResponse.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error uploading video: $e');
      return false;
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

  Future<void> _pickVideo3() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _video3 = File(result.files.single.path!);
        _controller3 = VideoPlayerController.file(_video3!);
        _controller3!.initialize();
      });
    }
  }

  Future<void> _pickVideo4() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _video4 = File(result.files.single.path!);
        _controller4 = VideoPlayerController.file(_video4!);
        _controller4!.initialize();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        title: Text(
          'Sign up',
          textAlign: TextAlign.center,
          style: SafeGoogleFont(
            'Be Vietnam Pro',
            fontSize: 22 * ffem,
            fontWeight: FontWeight.w500,
            height: 1.25 * ffem / fem,
            letterSpacing: -0.8000000119 * fem,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF121217),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
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
                  padding: EdgeInsets.fromLTRB(
                      16 * fem, 12 * fem, 16 * fem, 12 * fem),
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
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 8 * fem),
                              child: Text(
                                'Your Skills',
                                style: SafeGoogleFont(
                                  'Be Vietnam Pro',
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 60,
                              child: DropdownButtonFormField<String>(
                                value: _selectedSkill.isEmpty
                                    ? null
                                    : _selectedSkill,
                                items: _skills.map((String skill) {
                                  return DropdownMenuItem<String>(
                                    value: skill,
                                    child: Text(skill,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white)),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedSkill = value!;
                                    _subSkills =
                                        _skillToSubSkills[_selectedSkill] ?? [];
                                    _selectedSubSkills
                                        .clear(); // Clear sub-skills when skill changes
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Select Skill',
                                  hintStyle:
                                      TextStyle(color: Color(0xFF9E9EB8)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1.25, color: Color(0xFF9E9EB8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1.25, color: Colors.white),
                                  ),
                                ),
                                style: TextStyle(color: Color(0xFF9E9EB8)),
                                dropdownColor: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 14 * fem,
                            ),
                            Container(
                              width: double.infinity,
                              height: 60,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    width: 1.25, color: Color(0xFF9E9EB8)),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Trigger the modal dropdown
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setModalState) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                  'Select Sub-Skills',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView(
                                                  children: _subSkills
                                                      .map((subSkill) {
                                                    return CheckboxListTile(
                                                      title: Text(
                                                        subSkill,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      value: _selectedSubSkills
                                                          .contains(subSkill),
                                                      activeColor: Colors.white,
                                                      checkColor: Colors.black,
                                                      onChanged: (bool? value) {
                                                        setModalState(() {
                                                          if (value == true) {
                                                            _selectedSubSkills
                                                                .add(subSkill);
                                                          } else {
                                                            _selectedSubSkills
                                                                .remove(
                                                                    subSkill);
                                                          }
                                                        });
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Color(
                                                        0xffe5195e), // Customize button color
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    minimumSize: Size(200,
                                                        50), // Adjust button size
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    setState(
                                                        () {}); // Trigger UI update after modal is dismissed
                                                  },
                                                  child: Text('OK',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17 * fem)),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedSubSkills.isEmpty
                                            ? 'Sub-Skill'
                                            : _selectedSubSkills.join(', '),
                                        style: TextStyle(
                                          color: _selectedSubSkills.isEmpty
                                              ? Color(0xFF9E9EB8)
                                              : Colors.white,
                                          fontSize: 18,
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // Handle long lists gracefully
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF9E9EB8),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20 * fem,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 10 * fem, 0 * fem, 9 * fem),
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
                              height: 60 * fem,

                              child: TextField(
                                controller: _experienceController,
                                decoration: InputDecoration(
                                  hintText: 'Years of Experience you have',
                                  hintStyle:
                                      TextStyle(color: Color(0xFF9E9EB8)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(
                                      width: 1.25,
                                      color: Color(0xFF9E9EB8),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(
                                        width: 1.25, color: Colors.white),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              // Adjusted height to match the height of the outer container
                              height: 60 * fem,

                              child: TextField(
                                controller: _pastController,
                                decoration: InputDecoration(
                                  hintText:
                                      'Total no of bookings handled before?',
                                  hintStyle:
                                      TextStyle(color: Color(0xFF9E9EB8)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(
                                      width: 1.25,
                                      color: Color(0xFF9E9EB8),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10 * fem),
                                    borderSide: BorderSide(
                                        width: 1.25, color: Colors.white),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 10 * fem),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 11 * fem),
                              child: Text(
                                'Please select the equipment you\'ll need for your performance in front of a small audience',
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
                              height: 60 * fem, // Adjusted height to match the outer container
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10 * fem),
                                border: Border.all(
                                  width: 1.25,
                                  color: Color(0xFF9E9EB8),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12 * fem), // Adjusted padding
                              child: GestureDetector(
                                onTap: () {
                                  // Trigger the modal dropdown
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context, StateSetter setModalState) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Text(
                                                  'Select Required Equipment',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView(
                                                  children: _equipmentOptions.map((equipment) {
                                                    return CheckboxListTile(
                                                      title: Text(
                                                        equipment,
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                      value: _selectedEquipment.contains(equipment),
                                                      activeColor: Colors.white,
                                                      checkColor: Colors.black,
                                                      onChanged: (bool? value) {
                                                        setModalState(() {
                                                          if (value == true) {
                                                            _selectedEquipment.add(equipment);
                                                          } else {
                                                            _selectedEquipment.remove(equipment);
                                                          }
                                                        });
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color(0xffe5195e), // Customize button color
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    minimumSize: Size(200, 50), // Adjust button size
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    setState(() {}); // Trigger UI update after modal is dismissed
                                                  },
                                                  child: Text('OK',
                                                      style: TextStyle(
                                                          color: Colors.white, fontSize: 17 * fem)),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedEquipment.isNotEmpty
                                            ? _selectedEquipment.join(', ') // Display selected items
                                            : 'Select Equipment', // Display hint text if nothing is selected
                                        style: TextStyle(
                                          color: _selectedEquipment.isNotEmpty
                                              ? Colors.white // Selected text color
                                              : Color(0xFF9E9EB8), // Hint text color
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis, // Handle long text
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down, // Dropdown arrow icon
                                      color: Color(0xFF9E9EB8), // Arrow color
                                      size: 24, // Arrow size
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24 * fem,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.fromLTRB(16 * fem, 0 * fem, 16 * fem, 0 * fem),
                  width: double.infinity,
                  height: 475 * fem,
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
                                width: 150 * fem, // Set your desired width
                                height: 170 * fem, // Set your desired height
                                margin: EdgeInsets.only(
                                    right: 16.0), // Spacing between boxes
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: _image1 != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            10 * fem), // Rounded corners
                                        child: Image.file(_image1!,
                                            fit: BoxFit.cover),
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
                                        borderRadius: BorderRadius.circular(
                                            10 * fem), // Rounded corners
                                        child: Image.file(_image2!,
                                            fit: BoxFit.cover),
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
                                        borderRadius: BorderRadius.circular(
                                            10 * fem), // Rounded corners
                                        child: Image.file(_image3!,
                                            fit: BoxFit.cover),
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
                          height: 40,
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: _pickVideo1,
                              child: Container(
                                width: 150 * fem, // Set your desired width
                                height: 170 * fem, // Set your desired height
                                margin: EdgeInsets.only(
                                    right: 16.0), // Spacing between boxes
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: _controller1 != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10 *
                                            fem), // Rounded corners for the video
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
                                        borderRadius:
                                            BorderRadius.circular(10 * fem),
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
                                        borderRadius:
                                            BorderRadius.circular(10 * fem),
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
                  padding: EdgeInsets.fromLTRB(
                      16 * fem, 0 * fem, 16 * fem, 18 * fem),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 9 * fem),
                          child: Text(
                            'For videos longer than 20 seconds',
                            style: SafeGoogleFont(
                              'Be Vietnam Pro',
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(

                          width: double.infinity,
                          // Adjusted height to match the height of the outer container
                          height: 60 * fem,

                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Please paste the YouTube video link here.',
                              hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10 * fem),
                                borderSide: BorderSide(width: 1.25, color:Color(0xFF9E9EB8),),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10 * fem),
                                borderSide: BorderSide(width: 1.25, color: Colors.white ),
                              ),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,10,0,0),
                          child: Container(

                            width: double.infinity,
                            // Adjusted height to match the height of the outer container
                            height: 60 * fem,

                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Please paste the YouTube video link here.',
                                hintStyle: TextStyle(color:  Color(0xFF9E9EB8)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  borderSide: BorderSide(width: 1.25, color:Color(0xFF9E9EB8),),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  borderSide: BorderSide(width: 1.25, color: Colors.white ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 30 * fem, 0 * fem, 8 * fem),
                          child: Text(
                            'How Much Do You Charge Per Hour ?',
                            style: SafeGoogleFont('Be Vietnam Pro',
                                fontSize: 20 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 18 * fem),
                          child: Text(
                            '⦾ Include transportation in the total price for city bookings.'
                            ' For out-of-city bookings, charges can be discussed with the host \n\n'
                            '⦾  The price shown to the user includes all fees and taxes, so you\'ll receive the full amount.',
                            style: SafeGoogleFont(
                              'Be Vietnam Pro',
                              fontSize: 16.5 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color:  Color(0xffe5195e),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 60 * fem,
                          child: TextField(
                            controller: _hourlyPriceController,
                            keyboardType: TextInputType
                                .number, // Ensures that only numbers are entered
                            decoration: InputDecoration(
                              hintText: _hourlyPriceController.text.isEmpty
                                  ? 'Your Total Per Hour Price'
                                  : null, // Hint text only when the field is empty
                              hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                              prefixText:
                                  '₹ ', // Prefix Rs that stays in place as user types
                              prefixStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19), // Style for the Rs
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10 * fem),
                                borderSide: BorderSide(
                                    width: 1.25, color: Color(0xFF9E9EB8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10 * fem),
                                borderSide: BorderSide(
                                    width: 1.25, color: Colors.white),
                              ),
                            ),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    19), // Style for the text entered by the user
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
                  padding: EdgeInsets.fromLTRB(
                      16 * fem, 0 * fem, 16 * fem, 10 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: Color(0xFF121217),
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 20 * fem),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 4 * fem),
                              child: Text(
                                'For Receiving Payments',
                                style: TextStyle(
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 14 * fem),
                              child: Text(
                                'If you expect to receive higher payments in the future, please select the account option.',
                                style: TextStyle(
                                  fontSize: 16 * ffem,
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
                                    activeColor: Color(0xffe5195e),
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
                                    activeColor: Color(0xffe5195e),
                                  ),
                                ),
                              ],
                            ),
                            // UPI ID Input Box
                            Visibility(
                              visible: isUpiSelected,
                              child: Container(
                                width: double.infinity,
                                height: 60 * fem,
                                margin: EdgeInsets.only(top: 10 * fem),
                                child: TextField(
                                  controller: _upiController,
                                  decoration: InputDecoration(
                                    hintText: 'Your UPI ID',
                                    hintStyle:
                                        TextStyle(color: Color(0xFF9E9EB8)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12 * fem),
                                      borderSide: BorderSide(
                                        width: 1.25,
                                        color: Color(0xFF9E9EB8),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12 * fem),
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
                                    height: 60 * fem,
                                    margin: EdgeInsets.only(top: 10 * fem),
                                    child: TextField(
                                      controller: _accountNumberController,
                                      decoration: InputDecoration(
                                        hintText: 'Account Number',
                                        hintStyle:
                                            TextStyle(color: Color(0xFF9E9EB8)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12 * fem),
                                          borderSide: BorderSide(
                                            width: 1.25,
                                            color: Color(0xFF9E9EB8),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12 * fem),
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
                                    height: 60 * fem,
                                    margin: EdgeInsets.only(top: 10 * fem),
                                    child: TextField(
                                      controller: _ifscController,
                                      decoration: InputDecoration(
                                        hintText: 'IFSC Code',
                                        hintStyle:
                                            TextStyle(color: Color(0xFF9E9EB8)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12 * fem),
                                          borderSide: BorderSide(
                                            width: 1.25,
                                            color: Color(0xFF9E9EB8),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12 * fem),
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
                                    height: 60 * fem,
                                    margin: EdgeInsets.only(top: 10 * fem),
                                    child: TextField(
                                      controller: _accountHolderNameController,
                                      decoration: InputDecoration(
                                        hintText: 'Account Holder Name',
                                        hintStyle:
                                            TextStyle(color: Color(0xFF9E9EB8)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12 * fem),
                                          borderSide: BorderSide(
                                            width: 1.25,
                                            color: Color(0xFF9E9EB8),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12 * fem),
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
                  color: Color(0xFF121217),
                  margin: EdgeInsets.fromLTRB(
                      16 * fem, 0 * fem, 16 * fem, 24 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 18 * fem),
                        child: Text(
                          'Special message for the host\n (Optional)',
                          style: SafeGoogleFont('Be Vietnam Pro',
                              fontSize: 20 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: Colors.white),
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
                              borderSide:
                                  BorderSide(width: 1.25, color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      16 * fem, 0 * fem, 16 * fem, 12 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _handleButtonClick, // Disable button when loading
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
                            child: Text(
                              _isLoading
                                  ? 'Loading...'
                                  : 'Finish', // Show 'Loading...' if loading
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                letterSpacing: 0.24,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      )
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
      barrierDismissible:
          false, // Prevents dismissing the dialog by tapping outside
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xffe5195e)),
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

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => team1signup()),
    );
  }

  Future<bool> uploadImages(List<File?> imageFiles, String id) async {
    try {
      // Your image upload API endpoint
      var uploadUrl = Uri.parse('${Config().apiDomain}/images_upload/$id');
      var request = http.MultipartRequest('POST', uploadUrl);

      // Add user type as a field in the request
      request.fields['usertype'] = 'team';

      // Add images to the request
      for (int i = 0; i < imageFiles.length; i++) {
        var imageFile = imageFiles[i];
        if (imageFile != null) {
          // Use 'profile_photo' for the last image, otherwise use 'image{i + 1}'
          String fieldName =
              (i == imageFiles.length - 1) ? 'profile_photo' : 'image${i + 1}';
          var image =
              await http.MultipartFile.fromPath(fieldName, imageFile.path);
          request.files.add(image);
        }
      }

      // Send the request to upload the images
      var streamedResponse = await request.send();

      // Check if the image upload was successful
      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();
        print('Upload successful: $response');
        return true;
      } else {
        print('Upload failed with status: ${streamedResponse.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle errors if needed
      print('Error uploading images: $e');
      return false;
    }
  }
}
