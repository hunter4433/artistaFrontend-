import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test1/page-1/page_0.3_artist_home.dart';
import 'package:test1/page-1/searched_artist.dart';
import 'package:video_player/video_player.dart';

import '../config.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchBarSelected = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/page-1/images/search.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setVolume(0);
    _controller.setLooping(true);

    _searchFocusNode.addListener(_onSearchFocusChange);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChange);
    _searchFocusNode.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      playVideo();
    } else if (state == AppLifecycleState.paused) {
      pauseVideo();
    }
  }

  void _onSearchFocusChange() {
    setState(() {
      _isSearchBarSelected = _searchFocusNode.hasFocus;
    });
  }

  // Public methods to control video playback
  void playVideo() {
    if (_controller.value.isInitialized) {
      _controller.play();
    }
  }

  void pauseVideo() {
    if (_controller.value.isInitialized) {
      _controller.pause();
    }
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

    final String apiUrl1 = '${Config().apiDomain}/artist/search';
    final String apiUrl2 = '${Config().apiDomain}/team/search'; // Second API endpoint

    final Uri uri1 = Uri.parse(apiUrl1).replace(queryParameters: {
      'skill': searchTerm,
      'lat': latitude,
      'lng': longitude,
    });

    final Uri uri2 = Uri.parse(apiUrl2).replace(queryParameters: {
      'skill': searchTerm, // Modify query parameters as needed for the second endpoint
      'lat': latitude,
      'lng': longitude,
    });

    try {
      // Call both API endpoints simultaneously
      final responses = await Future.wait([
        http.get(uri1, headers: {
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        }),
        http.get(uri2, headers: {
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        })
      ]);

      final response1 = responses[0];
      final response2 = responses[1];

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        // Parse both responses
        List<dynamic> data1 = jsonDecode(response1.body);
        List<dynamic> data2 = jsonDecode(response2.body);

        // Merge the data
        List<Map<String, dynamic>> mergedData = [
          ...List<Map<String, dynamic>>.from(data1.map((artist) {
            artist['profile_photo'] = artist['profile_photo'];
            artist['isTeam'] = 'false';
            return artist;
          })),
          ...List<Map<String, dynamic>>.from(data2.map((artist) {
            artist['profile_photo'] = artist['profile_photo'];
            artist['isTeam'] = 'true';
            return artist;
          })),
        ];
       print(mergedData);
        return mergedData;
      } else {
        print('Failed to load artists');
        print(response1.body);
        print(response2.body);
        return [];
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }


  void searchBySkill(String skill) async {
    List<Map<String, dynamic>> filteredData = await searchArtists(skill);

    // Pause the video when navigating to another page
    _controller.pause();

    final returnedValue = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchedArtist(filteredArtistData: filteredData),
      ),
    );

    // Optionally, you can handle the returned value here
    if (returnedValue != null) {
      // Do something with the returned value if necessary
      print('Returned value: $returnedValue');
    }

    // Reinitialize the video when returning to this page
    _controller.play();
  }


  @override
  Widget build(BuildContext context) {
    final List<String> skills = [
      'Comedian',
      'Chef',
      'Classical Musician',
      // 'DJ',
      'Dhol Artist',
      'Ghazal',
      'Ghazal',
      'Magician',
      'Band',


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
// <<<<<<< HEAD
//                       style: TextStyle(color: Colors.white),
//                       onFieldSubmitted: (value) async {
//                         List<Map<String, dynamic>> filteredData =
//                         await searchArtists(value);
//                         // Dispose the video when navigating to another page
//                         _controller.pause();
//                         // Navigate to your search results screen
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   SearchedArtist(filteredArtistData: filteredData, )),
//                         ).then((value) {
//                           // Reinitialize the video when returning to this page
//                           _controller.play();
//                         });
//                       },
// =======
// >>>>>>> 9e3f3a1ad3317a5838219c59acad554d7748e289
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
                      onTap: () async {
                        List<Map<String, dynamic>> filteredData =
                            await searchArtists('Comedian');

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
                      onTap: ()  async {
                        List<Map<String, dynamic>> filteredData =
                            await searchArtists('Comedian');

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
                      onTap: () async {
                        List<Map<String, dynamic>> filteredData =
                            await searchArtists('Comedian');

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
                      child: Text(
                        'Poojan Special',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    // GestureDetector(
                    //   onTap: () {
                    //     print('Ghazal Singers');
                    //   },
                    //   child: Text(
                    //     'Ghazal Artist',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18 * ffem,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 8 * fem),
                    // GestureDetector(
                    //   onTap: () {
                    //     print('Ghazal Singers');
                    //   },
                    //   child: Text(
                    //     'DJ for House Party',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18 * ffem,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 8 * fem),
                    // GestureDetector(
                    //   onTap: () {
                    //     print('Ghazal Singers');
                    //   },
                    //   child: Text(
                    //     'Stand-Up Artist',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18 * ffem,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 8 * fem),
                    // GestureDetector(
                    //   onTap: () {
                    //     print('Gazal Singers');
                    //   },
                    //   child: Text(
                    //     'Chef for House Party',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18 * ffem,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 8 * fem),
                    GestureDetector(
                      onTap: () async {
                        List<Map<String, dynamic>> filteredData =
                            await searchArtists('Comedian');

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
                      onTap: () async {
                        List<Map<String, dynamic>> filteredData =
                            await searchArtists('Comedian');

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
                      child: Text(
                        'Choreographers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * ffem,
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * fem),
                    // GestureDetector(
                    //   onTap: () {
                    //     print('Ghazal Singers');
                    //   },
                    //   child: Text(
                    //     'Magician for birthdays',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18 * ffem,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 8 * fem),
                    // GestureDetector(
                    //   onTap: () {
                    //     print('Gazal Singers');
                    //   },
                    //   child: Text(
                    //     'Singers for Corporate Events',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18 * ffem,
                    //     ),
                    //   ),
                    // ),
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