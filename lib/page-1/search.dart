import 'package:flutter/material.dart';
import 'searched_artist.dart'; // Import your Searched_artist screen
import 'package:geolocator/geolocator.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<Map<String, dynamic>> artistData = [
    {'name': 'Sophia', 'skill': 'Classical Piano', 'rating': 4.5, 'image': 'assets/page-1/images/depth-3-frame-0-4tP.png'},
    {'name': 'John', 'skill': 'Pop Singer', 'rating': 4.2, 'image': 'assets/page-1/images/depth-3-frame-0-4tP.png'},
    {'name': 'Emily', 'skill': 'Pop Singer', 'rating': 4.7, 'image': 'assets/page-1/images/depth-3-frame-0-4tP.png'},
  ];

  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchBarSelected = false;

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

  @override
  Widget build(BuildContext context) {
    final List<String> skills = ['Classical Piano', 'Pop', 'Hip-hop', 'R&B', 'Stand-Up', 'Guitarist', 'Chef'];

    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    List<Map<String, dynamic>> filterArtistData(String searchTerm) {
      List<Map<String, dynamic>> filteredData = [];
      for (var artist in artistData) {
        bool nameContainsTerm = artist['name'].toLowerCase().contains(searchTerm.toLowerCase());
        bool skillContainsTerm = artist['skill'].toLowerCase().contains(searchTerm.toLowerCase());
        if (nameContainsTerm || skillContainsTerm) {
          filteredData.add(artist);
        }
      }
      return filteredData;
    }

    void searchBySkill(String skill) {
      List<Map<String, dynamic>> filteredData = filterArtistData(skill);
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
                  hintText: 'Search',
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
                onFieldSubmitted: (value) {
                  List<Map<String, dynamic>> filteredData = filterArtistData(value);
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

void main() {
  runApp(MaterialApp(
    home: Search(),
  ));
}
