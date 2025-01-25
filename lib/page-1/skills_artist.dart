import 'dart:async';
import 'dart:async';
import 'dart:io';
// import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../config.dart';
import '../utils.dart';
import 'bottomNav_artist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock_plus/wakelock_plus.dart';

class ArtistCredentials2 extends StatefulWidget {
  final File? profilePhoto;


  ArtistCredentials2({
    this.profilePhoto,
  });
  @override
  _ArtistCredentials2State createState() => _ArtistCredentials2State();
  String? selectedOption;
}




class _ArtistCredentials2State extends State<ArtistCredentials2> with WidgetsBindingObserver  {
  TextEditingController _subskillController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _hourlyPriceController = TextEditingController();
  TextEditingController _pastController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  String? selectedOption;
  bool isUpiSelected = false;
  bool isAccountSelected = false;
  TextEditingController _upiController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _ifscController = TextEditingController();
  TextEditingController _accountHolderNameController = TextEditingController();
  TextEditingController _youtubeLink1Controller = TextEditingController();
  TextEditingController _youtubeLink2Controller = TextEditingController();
  bool _isLoading1 = false;
  bool _isLoading2 = false;
  bool _isLoading3 = false;
  bool _isUploading = false;

  String _selectedSkill = ''; // Selected skill
  // List<String> _skills = ['Musician', 'Comedian', 'Visual Artist', 'Dancer', 'Chef', 'Magician'];

  List<String> _skills = [
    'Singer',
    'Musician/Instrumentalist',
    'DJ',
    'Dancer',
    'Chef',
    'Magician/Illusionist',
    'Sketch Artist',
    'Stand-Up Comedian',
    'Anchor/MC',
    'Photographer/Videographer',
    'Kids Entertainment Specialist'
  ];
  final Map<String, List<String>> _skillToSubSkills = {
    'Singer': ['Punjabi', 'Bollywood','Devotional' 'Ghazal/Sufi','Indie/Pop','English Covers'],
    'Musician/Instrumentalist': ['Tabla Player','Sitarist', 'Violinist', 'Guitarist','Dhol Player','Sexophone Player','Harmonium Player','Piano Player','Electronic Keyboard','Harmonica'],
    'DJ':['House','Techno','EDM','Hip Hop','Retro','Punjabi','Wedding DJ'],
    'Dancer': ['Bhangra', 'Giddha','Nati', 'Fusion','Classical','Contemporary','Hip Hop',],
    'Chef': ['Punjabi Cuisine', 'North Indian', 'Fusion Food','Chinese','Italian','Mexican','Continental','Thai Cuisine','Japanese','Dessert Chef'],
    'Magician/Illusionist': ['Stage Magician', 'Close-Up Magician', 'Mentalist'],
    'Sketch Artist':['Portrait Artist','Live Painting Artist','Caricature','Henna Artist'],
    'Stand-Up Comedian':['Mimicry Artist','Roast Comedy','Family Friendly','Punjabi Stand-Up'],
    'Anchor/MC':['Wedding Anchor', 'Corporate Event Host','Emcees','Emcees for Kids Event'],
    'Photographer/Videographer':['Wedding','Event','Short film Creator'],
    'Kids Entertainment Specialist':['Clown','Puppet Shows']
  };
  // final Map<String, List<String>> _skillToSubSkills = {
  //   'Musician': ['Singing', 'Instrumental', 'Songwriting'],
  //   'Comedian': ['Stand-Up', 'Improv', 'Sketch Comedy'],
  //   'Visual Artist': ['Painting', 'Sketching', 'Digital Art'],
  //   'Dancer': ['Ballet', 'Hip-Hop', 'Contemporary'],
  //   'Chef': ['Baking', 'Grilling', 'Vegan Cooking'],
  //   'Magician': ['Card Tricks', 'Illusions', 'Mentalism'],
  // };
  List<String> _subSkills = []; // Sub-skills for the selected skill
  List<String> _selectedSubSkills = []; // Selected sub-skills
  // Variables for equipment and selected equipment
  List<String> _equipmentOptions = ['Sound System', 'Lighting', 'Stage Setup', 'Microphone', 'Projector'];
  List<String> _selectedEquipment = [];


  bool _isLoading = false;

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
      'alternate_number': prefs.getString('age'),
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
  Future<bool> storeBankDetails() async {
    final url = Uri.parse('${Config().apiDomain}/artist-bank-details');
    String? artist_id= await storage.read(key: 'artist_id');
     print('artist_id  is $artist_id');
    // Collect data from controllers
    final Map<String, dynamic> bankData = {
      'UPI_id': _upiController.text,
      'account_number': _accountNumberController.text,
      'IFSC_code':  _ifscController.text,
      'account_holder_name': _accountHolderNameController.text,
      'artist_id': artist_id ?? '',
      'team_id':0,
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
        return true;
      } else {
        // Failure
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save bank details.')),
        );
        return false;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
      return false ;

    }

  }

  @override
  void initState() {
    _selectedSkill = _skills.first;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _subskillController.dispose();
    _experienceController.dispose();
    _hourlyPriceController.dispose();
    _messageController.dispose();

    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _disableWakeLock();
    super.dispose();
  }

  Future<void> _enableWakeLock() async {
    try {
      await WakelockPlus.enable();
    } catch (e) {
      print('Failed to enable wakelock: $e');
    }
  }

  Future<void> _disableWakeLock() async {
    try {
      if (_isUploading) {
        await WakelockPlus.disable();
      }
    } catch (e) {
      print('Failed to disable wakelock: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isUploading) {
      switch (state) {
        case AppLifecycleState.paused:
          _showUploadNotification();
          break;
        case AppLifecycleState.resumed:
          _cancelUploadNotification();
          break;
        default:
          break;
      }
    }
  }

  void _showUploadNotification() {
    NotificationService.showUploadInProgressNotification();
  }

  void _cancelUploadNotification() {
    NotificationService.cancelUploadNotification();
  }

  Future<bool> _onFinishButtonClicked() async {
    setState(() => _isUploading = true);
    await _enableWakeLock();

    String? artistId;
    bool success = false;

    // Show progress dialog
    if (!mounted) return false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Uploading Data...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please keep the app open.\nThis may take a few minutes.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      // Your existing implementation
      bool dataSent = await _sendDataToBackend();
      if (!dataSent) {
        await _showErrorDialog('Failed to send initial data to server. Please try again.');
        return false;
      }

      artistId = await storage.read(key: 'artist_id');
      if (artistId == null) {
        await _showErrorDialog('Failed to retrieve artist ID. Please try again.');
        return false;
      }

      bool bankDetailsStored = await storeBankDetails();
      if (!bankDetailsStored) {
        await _deleteArtistInformation(artistId);
        await _showErrorDialog('Failed to store bank details. Please check your bank information and try again.');
        return false;
      }

      List<File?> imageFiles = [_image1, _image2, _image3, widget.profilePhoto];
      List<File?> videoFiles = [_video1, _video2];

      final results = await Future.wait([
        uploadImages(imageFiles, artistId),
        uploadVideos(videoFiles, artistId)
      ]).catchError((error) async {
        await _deleteArtistInformation(artistId!);
        await _showErrorDialog('Error uploading files: ${error.toString()}');
        throw error;
      });

      bool imagesUploaded = results[0] as bool;
      bool videosUploaded = results[1] as bool;

      if (imagesUploaded && videosUploaded) {
        success = true;
        print('All operations completed successfully.');
      } else {
        await _deleteArtistInformation(artistId);
        if (!imagesUploaded && !videosUploaded) {
          await _showErrorDialog('Failed to upload both images and videos. Please check your files and try again.');
        } else if (!imagesUploaded) {
          await _showErrorDialog('Failed to upload images. Please check your image files and try again.');
        } else {
          await _showErrorDialog('Failed to upload videos. Please check your video files and try again.');
        }
      }

    } catch (e) {
      if (artistId != null) {
        await _deleteArtistInformation(artistId);
      }
      await _showErrorDialog('An unexpected error occurred: ${e.toString()}');
    } finally {
      setState(() => _isUploading = false);
      await _disableWakeLock();
      _cancelUploadNotification();
      if (mounted) {
        Navigator.of(context).pop(); // Remove progress dialog
      }
    }

    return success;
  }
// Helper function to show error dialog
  Future<void> _showErrorDialog(String message) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Delete artist information function
  Future<void> _deleteArtistInformation(String artistId) async {
    try {
      final response = await http.delete(
        Uri.parse('${Config().apiDomain}/artist/info/$artistId'),
        headers: <String, String>{
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',

        },
      );

      if (response.statusCode != 204) {
        await _showErrorDialog(
            'Warning: Failed to clean up artist data. Please contact support. Status: ${response.statusCode}'
        );
      }
    } catch (e) {
      await _showErrorDialog(
          'Warning: Failed to clean up artist data. Please contact support. Error: ${e.toString()}'
      );
    }
  }

  Future<bool> _sendDataToBackend() async {
    String? profilePhotoPath = widget.profilePhoto?.path;
    String? phoneNumber = await _getPhoneNumber();

    try {
      // Get shared preferences data
      Map<String, dynamic?> sharedPreferencesData = await getAllSharedPreferences();
      Map<String, String?> profilePreferencesData = await profileSharedPreferences();

      // Get authentication token and FCM token

      String? fCMToken = await _getFCMToken();

      // Prepare data to send to the backend
      Map<String, String> artistData = {
        'phone_number': phoneNumber!,
        'skills':_selectedSubSkills.join(','),
        'about_yourself': '${_experienceController.text}, ${_pastController.text}',
        'price_per_hour': _hourlyPriceController.text,
        'skill_category': _selectedSkill,
        'special_message': _messageController.text,
        'fcm_token': fCMToken ?? '',
        'sound_system': _selectedEquipment.join(', '),
        'video3': _youtubeLink1Controller.text,
        'video4': _youtubeLink2Controller.text,
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




  // @override
  // void initState() {
  //   super.initState();
  //   _selectedSkill = _skills.first; // Initialize selected skill with the first item in the list
  //    // Update sub-skills based on the selected skill
  // }

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

// <<<<<<< HEAD

// =======
//   bool _isLoading1 = false;
//   bool _isLoading2 = false;
//   bool _isLoading3 = false;
// >>>>>>> 71fc5321e6356695c1a1f769543a7c429f07c784

  Future<void> _pickVideo1() async {
    setState(() {
      _isLoading1 = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (_controller1 != null) {
      await _controller1!.dispose();
    }

    if (result != null) {
      setState(() {
        _video1 = File(result.files.single.path!);
        _controller1 = VideoPlayerController.file(_video1!);
      });

      await _controller1!.initialize();

      setState(() {
        _isLoading1 = false;
      });
    } else {
      setState(() {
        _isLoading1 = false; // Stop loading if no video is picked
      });
    }
  }

  Future<void> _pickVideo2() async {
    setState(() {
      _isLoading2 = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (_controller2 != null) {
      await _controller2!.dispose();
    }

    if (result != null) {
      setState(() {
        _video2 = File(result.files.single.path!);
        _controller2 = VideoPlayerController.file(_video2!);
      });

      await _controller2!.initialize();

      setState(() {
        _isLoading2 = false;
      });
    } else {
      setState(() {
        _isLoading2 = false; // Stop loading if no video is picked
      });
    }
  }

  Future<void> _pickVideo3() async {
    setState(() {
      _isLoading3 = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (_controller3 != null) {
      await _controller3!.dispose();
    }

    if (result != null) {
      setState(() {
        _video3 = File(result.files.single.path!);
        _controller3 = VideoPlayerController.file(_video3!);
      });

      await _controller3!.initialize();

      setState(() {
        _isLoading3 = false;
      });
    } else {
      setState(() {
        _isLoading3 = false; // Stop loading if no video is picked
      });
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



  // @override
  // void dispose() {
  //   _subskillController.dispose();
  //   _experienceController.dispose();
  //   _hourlyPriceController.dispose();
  //   _messageController.dispose();
  //
  //   super.dispose();
  // }



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
                fontSize: 22 * fem,
                fontWeight: FontWeight.w500,
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
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 10 * fem),
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
                              height: 60,
                              child: DropdownButtonFormField<String>(
                                value: _selectedSkill.isEmpty ? null : _selectedSkill,
                                items: _skills.map((String skill) {
                                  return DropdownMenuItem<String>(
                                    value: skill,
                                    child: Text(skill, style: TextStyle(fontSize: 18, color: Colors.white)),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedSkill = value!;
                                    _subSkills = _skillToSubSkills[_selectedSkill] ?? [];
                                    _selectedSubSkills.clear(); // Clear sub-skills when skill changes
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Select Skill',
                                  hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(width: 1.25, color: Color(0xFF9E9EB8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(width: 1.25, color: Colors.white),
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
                                border: Border.all(width: 1.25, color: Color(0xFF9E9EB8)),
                              ),
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
                                                  'Select Sub-Skills',
                                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView(
                                                  children: _subSkills.map((subSkill) {
                                                    return CheckboxListTile(
                                                      title: Text(
                                                        subSkill,
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                      value: _selectedSubSkills.contains(subSkill),
                                                      activeColor: Colors.white,
                                                      checkColor: Colors.black,
                                                      onChanged: (bool? value) {
                                                        setModalState(() {
                                                          if (value == true) {
                                                            _selectedSubSkills.add(subSkill);
                                                          } else {
                                                            _selectedSubSkills.remove(subSkill);
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
                                                  child: Text('OK', style: TextStyle(color: Colors.white,fontSize: 17*fem)),
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
                                        _selectedSubSkills.isEmpty ? 'Sub-Skill' : _selectedSubSkills.join(', '),
                                        style: TextStyle(
                                          color: _selectedSubSkills.isEmpty ? Color(0xFF9E9EB8) : Colors.white,
                                          fontSize: 18,
                                        ),
                                        overflow: TextOverflow.ellipsis, // Handle long lists gracefully
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
                              margin: EdgeInsets.fromLTRB(0 * fem, 10 * fem, 0 * fem, 10 * fem),
                              child: Text(
                                'Tell Users about Yourself',
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
                              // Adjusted height to match the height of the outer container
                              height: 60 * fem,

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
                                    borderSide: BorderSide(width: 1.25, color: Colors.white ),
                                  ),
                                ),
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 10,),

                            Container(

                              width: double.infinity,
                              // Adjusted height to match the height of the outer container
                              height: 60 * fem,

                              child: TextField(
                                controller: _pastController,
                                decoration: InputDecoration(
                                  hintText: 'Total no of bookings handled before?',
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
                            SizedBox(height: 10*fem),
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 11 * fem),
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
                  border: Border.all(width: 1.25, color: Color(0xFF9E9EB8)),
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
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                                    child: Text('OK', style: TextStyle(color: Colors.white,fontSize: 17*fem)),
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
                          _selectedEquipment.isEmpty
                              ? 'Select Equipment'
                              : _selectedEquipment.join(', '), // Show selected equipment
                          style: TextStyle(
                            color: _selectedEquipment.isEmpty ? Color(0xFF9E9EB8) : Colors.white,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis, // Handle long list gracefully
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


              ] ),
                      ),
                      SizedBox(
                        height: 8 * fem,
                      ),


                    ],

                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 16 * fem, 0 * fem),
                  width: double.infinity,
                  height: 515 * fem,
                  decoration: BoxDecoration(
                    color: Color(0xFF121217),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      const Padding(
                        padding: EdgeInsets.all(.0),
                        child: SizedBox(
                          height: 60,

                          child: Text(
                            'Upload your photos to showcase talent and boost bookings!',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
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
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                          height: 25,
                          child: Text(
                            'Upload your videos here',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'Be Vietnam Pro',
                            ),
                          ),
                        ),
                      ),

// Description to indicate the duration limit
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          'Keep the video duration within 30 seconds.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffe5195e),
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
                                child: _isLoading1
                                    ? Center(child: CircularProgressIndicator()) // Show loading for video 1
                                    : _controller1 != null && _controller1!.value.isInitialized
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
                                child: _isLoading2
                                    ? Center(child: CircularProgressIndicator()) // Show loading for video 2
                                    : _controller2 != null && _controller2!.value.isInitialized
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  child: VideoPlayer(_controller2!),
                                )
                                    : Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: _pickVideo3,
                            //   child: Container(
                            //     width: 150 * fem,
                            //     height: 170 * fem,
                            //     margin: EdgeInsets.only(right: 16.0),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10 * fem),
                            //       border: Border.all(color: Colors.grey),
                            //     ),
                            //     child: _isLoading3
                            //         ? Center(child: CircularProgressIndicator()) // Show loading for video 3
                            //         : _controller3 != null && _controller3!.value.isInitialized
                            //         ? ClipRRect(
                            //       borderRadius: BorderRadius.circular(10 * fem),
                            //       child: VideoPlayer(_controller3!),
                            //     )
                            //         : Icon(Icons.add, color: Colors.white),
                            //   ),
                            // ),
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
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 9 * fem),
                          child: Text(
                            'For video longer than 30 seconds',
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
                          height: 60 * fem,
                          child: TextField(
                            controller: _youtubeLink1Controller, // Add this controller
                            decoration: InputDecoration(
                              hintText: 'Please paste the YouTube video link here.',
                              hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10 * fem),
                                borderSide: BorderSide(width: 1.25, color:Color(0xFF9E9EB8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10 * fem),
                                borderSide: BorderSide(width: 1.25, color: Colors.white),
                              ),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: double.infinity,
                          height: 60 * fem,
                          child: TextField(
                            controller: _youtubeLink2Controller, // Add this controller
                            decoration: InputDecoration(
                              hintText: 'Please paste the YouTube video link here.',
                              hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10 * fem),
                                borderSide: BorderSide(width: 1.25, color:Color(0xFF9E9EB8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10 * fem),
                                borderSide: BorderSide(width: 1.25, color: Colors.white),
                              ),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 20 * fem, 0 * fem, 8* fem),
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
                                '⦾ The price shown to the user includes all fees and taxes, so you\'ll receive the full amount.',
                            style: SafeGoogleFont(
                              'Be Vietnam Pro',
                              fontSize: 16.5 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: Color(0xffe5195e),
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
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 5 * fem),
                              child: Text(
                                'For Receiving Payments\n(Choose any one of the below)',
                                style: TextStyle(
                                  fontSize: 18 * ffem,
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
                                    height: 60 * fem,
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
                                    height: 60 * fem,
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
                                    height: 60 * fem,
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
                                'Special message for the host (Optional)',
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
                  _isLoading ? 'Loading...' : 'Finish',
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
      var uploadUrl = Uri.parse('${Config().apiDomain}/api/upload-images/$id');
      print('Upload URL: $uploadUrl');

      // Create form data
      var formData = http.MultipartRequest('POST', uploadUrl);

      // Add usertype
      formData.fields['usertype'] = 'artist'; // or 'team' based on your need

      // Add images
      for (int i = 0; i < imageFiles.length - 1; i++) {
        if (imageFiles[i] != null) {
          var stream = http.ByteStream(imageFiles[i]!.openRead());
          var length = await imageFiles[i]!.length();

          var multipartFile = http.MultipartFile(
              'image${i + 1}',
              stream,
              length,
              filename: 'image${i + 1}.jpg'
          );
          formData.files.add(multipartFile);
        }
      }

      // Add profile photo (last image in the list)
      if (imageFiles.last != null) {
        var stream = http.ByteStream(imageFiles.last!.openRead());
        var length = await imageFiles.last!.length();

        var multipartFile = http.MultipartFile(
            'profile_photo',
            stream,
            length,
            filename: 'profile_photo.jpg'
        );
        formData.files.add(multipartFile);
      }

      // Add headers if needed
      formData.headers.addAll({
        'Accept': 'application/json',
        // Add any other headers your API requires
      });

      // Send request
      var response = await formData.send();
      var responseData = await response.stream.bytesToString();
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseData');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Upload successful');
        return true;
      } else {
        print('Upload failed with status: ${response.statusCode}');
        print('Error details: $responseData');
        return false;
      }
    } catch (e, stackTrace) {
      print('Error uploading images: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }



}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static const _notificationId = 1;

  static Future<void> initialize() async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(settings);
  }

  static Future<void> showUploadInProgressNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'upload_channel',
      'Upload Status',
      channelDescription: 'Shows upload progress',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
    );

    const iOSDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await _notifications.show(
      _notificationId,
      'Upload in Progress',
      'Please return to the app to complete the upload process.',
      details,
    );
  }

  static Future<void> cancelUploadNotification() async {
    await _notifications.cancel(_notificationId);
  }
}
