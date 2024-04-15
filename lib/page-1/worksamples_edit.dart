import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ArtistCredentials44 extends StatefulWidget {
  @override
  _ArtistCredentialsState createState() => _ArtistCredentialsState();
}

class _ArtistCredentialsState extends State<ArtistCredentials44> {
  File? _audioFile1;
  File? _audioFile2;
  File? _videoFile1;
  File? _videoFile2;
  File? _imageFile1;
  File? _imageFile2;
  File? _imageFile3;
  File? _imageFile4;
  File? _searchedImage;

  Future<void> _pickAudio1() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _audioFile1 = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickAudio2() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _audioFile2 = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo1() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoFile1 = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo2() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoFile2 = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage1() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile1 = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage2() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile2 = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage3() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile3 = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage4() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile4 = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageForSearchedSection() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _searchedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign up',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Upload Audios Here',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickAudio1,
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey.withOpacity(0.3),
                          child: _audioFile1 != null
                              ? Text('Audio 1 selected!')
                              : Icon(Icons.upload_outlined),
                        ),
                      ),
                      if (_audioFile1 != null) Text('Audio 1 selected!'),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickAudio2,
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey.withOpacity(0.3),
                          child: _audioFile2 != null
                              ? Text('Audio 2 selected!')
                              : Icon(Icons.upload_outlined),
                        ),
                      ),
                      if (_audioFile2 != null) Text('Audio 2 selected!'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Upload Videos Here',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickVideo1,
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey.withOpacity(0.3),
                          child: _videoFile1 != null
                              ? Text('Video 1 selected!')
                              : Icon(Icons.upload_outlined),
                        ),
                      ),
                      if (_videoFile1 != null) Text('Video 1 selected!'),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickVideo2,
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey.withOpacity(0.3),
                          child: _videoFile2 != null
                              ? Text('Video 2 selected!')
                              : Icon(Icons.upload_outlined),
                        ),
                      ),
                      if (_videoFile2 != null) Text('Video 2 selected!'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Upload Images Here',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage1,
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey.withOpacity(0.3),
                          child: _imageFile1 != null
                              ? Image.file(_imageFile1!, fit: BoxFit.cover)
                              : Icon(Icons.upload_outlined),
                        ),
                      ),
                      if (_imageFile1 != null) Text('Image 1 selected!'),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage2,
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey.withOpacity(0.3),
                          child: _imageFile2 != null
                              ? Image.file(_imageFile2!, fit: BoxFit.cover)
                              : Icon(Icons.upload_outlined),
                        ),
                      ),
                      if (_imageFile2 != null) Text('Image 2 selected!'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage3,
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey.withOpacity(0.3),
                          child: _imageFile3 != null
                              ? Image.file(_imageFile3!, fit: BoxFit.cover)
                              : Icon(Icons.upload_outlined),
                        ),
                      ),
                      if (_imageFile3 != null) Text('Image 3 selected!'),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage4,
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey.withOpacity(0.3),
                          child: _imageFile4 != null
                              ? Image.file(_imageFile4!, fit: BoxFit.cover)
                              : Icon(Icons.upload_outlined),
                        ),
                      ),
                      if (_imageFile4 != null) Text('Image 4 selected!'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Upload Image for the Searched Section',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: _pickImageForSearchedSection,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  width: 200.0,
                  height: 200.0,
                  color: Colors.grey.withOpacity(0.3),
                  child: _searchedImage != null
                      ? Image.file(
                    _searchedImage!,
                    fit: BoxFit.cover,
                  )
                      : Center(
                    child: Icon(
                      Icons.upload_outlined,
                      size: 48.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
