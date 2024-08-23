import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:test1/page-1/page_0.3_artist_home.dart';
import '../config.dart';
import 'searched_artist.dart'; // Import your Searched_artist screen
import 'package:geolocator/geolocator.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // final List<Map<String, dynamic>> artistData = [
  //   {'name': 'Sophia', 'skill': 'Classical Piano', 'rating': 4.5, 'image': 'assets/page-1/images/depth-3-frame-0-4tP.png'},
  //   {'name': 'John', 'skill': 'Pop Singer', 'rating': 4.2, 'image': 'assets/page-1/images/depth-3-frame-0-4tP.png'},
  //   {'name': 'Emily', 'skill': 'Pop Singer', 'rating': 4.7, 'image': 'assets/page-1/images/depth-3-frame-0-4tP.png'},
  // ];

  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchBarSelected = false;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    setState(() {
      _isSearchBarSelected = _searchFocusNode.hasFocus;
    });
  }
  Future<String?> _getLatitude() async {
    return await storage.read(key: 'latitude'); // Assuming you stored the token with key 'token'
  }

  Future<String?> _getLongitude() async {
    return await storage.read(key: 'longitude'); // Assuming you stored the token with key 'token'
  }

  @override
  Widget build(BuildContext context) {
    final List<String> skills = ['Classical Piano', 'Pop', 'Hip-hop', 'R&B', 'Stand-Up', 'Guitarist', 'Chef'];

    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    // List<Map<String, dynamic>> filterArtistData(String searchTerm) {
    //   List<Map<String, dynamic>> filteredData = [];
    //   for (var artist in artistData) {
    //     bool nameContainsTerm = artist['name'].toLowerCase().contains(searchTerm.toLowerCase());
    //     bool skillContainsTerm = artist['skill'].toLowerCase().contains(searchTerm.toLowerCase());
    //     if (nameContainsTerm || skillContainsTerm) {
    //       filteredData.add(artist);
    //     }
    //   }
    //   return filteredData;
    // }



    Future<List<Map<String, dynamic>>> searchArtists(String searchTerm) async {
      print(searchTerm);
      String? latitude = await _getLatitude();
      String? longitude = await _getLongitude();
      final String apiUrl = '${Config().apiDomain}/artist/search'; // Replace with your actual API endpoint
      final String baseUrl = '${Config().baseDomain}/storage/';
      final Uri uri = Uri.parse(apiUrl).replace(queryParameters: {
        'skill': searchTerm,
        'lat': latitude,
        'lng': longitude
        ,
      });
      try {
        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',// Add authorization header if needed
          },
        );

        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          print(data);
          List<Map<String, dynamic>> artistData = List<Map<String, dynamic>>.from(data.map((artist) {
            artist['profile_photo'] = baseUrl + artist['profile_photo'];
            return artist;
          }));

          return artistData;
        } else {
          // Handle error

          print('Failed to load artists');
          return [];
        }
      } catch (e) {
        print('Error occurred: $e');
        // print(response.body);
        return [];
      }
    }

    void searchBySkill(String skill) async {
      List<Map<String, dynamic>> filteredData = await searchArtists(skill);
      print(filteredData);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchedArtist(filteredArtistData: filteredData)),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        title: Text(
          'Search',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Be Vietnam Pro',
            fontSize: 19 * ffem,
            fontWeight: FontWeight.w700,
            height: 1.25 * ffem / fem,
            letterSpacing: -0.8000000119 * fem,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF121217),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10 * fem),
              child: TextFormField(
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF292938),
                  hintText: ' Press enter for search',
                  hintStyle: TextStyle(color: Color(0xFF9E9EB8)), // Change hint text color
                  prefixIcon: Icon(Icons.search, color: Color(0xFF9E9EB8)), // Change icon color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16 * fem),
                    borderSide: BorderSide(
                      color: _isSearchBarSelected ? Color(0xffe5195e) : Color(0xFFA63B5E),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16 * fem),
                    borderSide: BorderSide(color: Color(0xFF9E9EB8)),
                  ),
                ),
                style: TextStyle(color: Colors.white), // Change search text color
                onFieldSubmitted: (value) async {
                  // searchArtists(value);
                  List<Map<String, dynamic>> filteredData = await searchArtists(value);
                  print(filteredData);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchedArtist(filteredArtistData: filteredData)),
                  );
                },
              ),
            ),
            SizedBox(height: 7 * fem),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * fem),
              child: Wrap(
                spacing: 12 * fem,
                runSpacing: 12 * fem,
                children: skills.map((skill) {
                  return GestureDetector(
                    onTap: () {
                      searchBySkill(skill);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16 * fem, vertical: 8 * fem),
                      decoration: BoxDecoration(
                        color: Color(0xFF292938),
                        borderRadius: BorderRadius.circular(12 * fem),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.5 * ffem / fem,
                          color: Color(0xFF9E9EB8),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20 * fem),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * fem),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      print('Nearby text tapped');
                    },
                    child: Text(
                      'Nearby',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18 * ffem,
                      ),
                    ),
                  ),
                  SizedBox(height: 8 * fem),
                  GestureDetector(
                    onTap: () {
                      print('Top Rated text tapped');
                    },
                    child: Text(
                      'Top Rated',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18 * ffem,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

