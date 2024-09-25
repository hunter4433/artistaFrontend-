import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test1/page-1/searched_artist.dart';
import 'package:video_player/video_player.dart';

import '../config.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with WidgetsBindingObserver {
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchBarSelected = false;
  final storage = FlutterSecureStorage();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the video player with mute
    _controller = VideoPlayerController.asset('assets/page-1/images/search.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
    _controller.setVolume(0); // Mute the video

    _searchFocusNode.addListener(_onSearchFocusChange);
    WidgetsBinding.instance.addObserver(this); // Add observer to track app lifecycle
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChange);
    _searchFocusNode.dispose();
    _controller.dispose(); // Dispose the video controller when leaving the page
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Play video when the app comes back into view
      _controller.play();
    } else if (state == AppLifecycleState.paused) {
      // Pause video when the app is not in view
      _controller.pause();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reinitialize the video when the page comes back into view
    if (!_controller.value.isInitialized) {
      _controller.initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    }
  }

  void _onSearchFocusChange() {
    setState(() {
      _isSearchBarSelected = _searchFocusNode.hasFocus;
    });
  }

  Future<String?> _getLatitude() async {
    return await storage.read(key: 'latitude');
  }

  Future<String?> _getLongitude() async {
    return await storage.read(key: 'longitude');
  }

  Future<List<Map<String, dynamic>>> searchArtists(String searchTerm) async {
    String? latitude = await _getLatitude();
    String? longitude = await _getLongitude();
    final String apiUrl = '${Config().apiDomain}/artist/search';
    // final String baseUrl = 'your-base-url';
    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: {
      'skill': searchTerm,
      'lat': latitude,
      'lng': longitude,
    });

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data.map((artist) {
          artist['profile_photo'] = artist['profile_photo'];
          return artist;
        }));
      } else {
        print('Failed to load artists');
        return [];
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }

  void searchBySkill(String skill) async {
    List<Map<String, dynamic>> filteredData = await searchArtists(skill);
    // Dispose the video when navigating to another page
    _controller.pause();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Search Result')),
          body: Center(child: Text('Results for $skill')),
        ),
      ),
    ).then((value) {
      // Reinitialize the video when returning to this page
      _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> skills = [
      'Classical Musician',
      'DJ',
      'Dhol Artist',
      'Ghazal',
      'Magician',
      'Band',
      'Chef'
    ];

    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Video background
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size?.width ?? 0,
                height: _controller.value.size?.height ?? 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust overlay opacity
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15 * fem),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transparent AppBar-like widget
                    Center(
                      child: Text(
                        'Search',
                        style: TextStyle(
                          fontFamily: 'Be Vietnam Pro',
                          fontSize: 21 * ffem,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20 * fem),
                    // Search bar
                    Container(
                      height: 60*fem,
                      child: TextFormField(
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF292938).withOpacity(0.75), // Transparent background
                          hintText: 'Musician/ Band/ Dhol Artist....',
                          hintStyle: TextStyle(color: Color(0xFF9E9EB8)),
                          prefixIcon: Icon(Icons.search, color: Color(0xFF9E9EB8)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16 * fem),
                            borderSide: BorderSide(
                              color: _isSearchBarSelected
                                  ? Color(0xffe5195e)
                                  : Color(0xFFA63B5E),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16 * fem),
                            borderSide: BorderSide(color: Color(0xFF9E9EB8)),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        onFieldSubmitted: (value) async {
                          List<Map<String, dynamic>> filteredData =
                          await searchArtists(value);
                          // Dispose the video when navigating to another page
                          _controller.pause();
                          // Navigate to your search results screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchedArtist(filteredArtistData: filteredData)),
                          ).then((value) {
                            // Reinitialize the video when returning to this page
                            _controller.play();
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20 * fem),
                    // Skill buttons
                    Wrap(
                      spacing: 12 * fem,
                      runSpacing: 12 * fem,
                      children: skills.map((skill) {
                        return GestureDetector(
                          onTap: () {
                            searchBySkill(skill);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16 * fem, vertical: 8 * fem),
                            decoration: BoxDecoration(
                              color: Color(0xFF292938).withOpacity(0.75), // Transparent background
                              borderRadius: BorderRadius.circular(10 * fem),
                            ),
                            child: Text(
                              skill,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5 * ffem / fem,
                                color: Color(0xFF9E9EB8),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20 * fem),
                    // Nearby and Top Rated options
                    Container(
                      child: Text('Most Popular',style: TextStyle(
                        color: Color(0xFF9E9EB8),
                        fontSize: 18*fem,
                        fontStyle: FontStyle.italic,
                      ),),
                    ),

                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        print('Nearby text tapped');
                      },
                      child: Text(
                        'Singers for Mehandi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        print('Nearby text tapped');
                      },
                      child: Text(
                        'Bands for wedding',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    GestureDetector(
                      onTap: () {
                        print('Poojan Special');
                      },
                      child: Text(
                        'Poojan Special',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    GestureDetector(
                      onTap: () {
                        print('Ghazal Singers');
                      },
                      child: Text(
                        'Ghazal Artist',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    GestureDetector(
                      onTap: () {
                        print('Ghazal Singers');
                      },
                      child: Text(
                        'DJ for House Party',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    GestureDetector(
                      onTap: () {
                        print('Ghazal Singers');
                      },
                      child: Text(
                        'Stand-Up Artist',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    GestureDetector(
                      onTap: () {
                        print('Gazal Singers');
                      },
                      child: Text(
                        'Chef for House Party',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    GestureDetector(
                      onTap: () {
                        print('Gazal Singers');
                      },
                      child: Text(
                        'Sketch Artist',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    GestureDetector(
                      onTap: () {
                        print('Gazal Singers');
                      },
                      child: Text(
                        'Choreographers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    GestureDetector(
                      onTap: () {
                        print('Ghazal Singers');
                      },
                      child: Text(
                        'Magician for birthdays',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    GestureDetector(
                      onTap: () {
                        print('Gazal Singers');
                      },
                      child: Text(
                        'Singers for Corporate Events',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}