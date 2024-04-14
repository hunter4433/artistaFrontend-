import 'package:flutter/material.dart';
import 'searched_artist.dart'; // Import your Searched_artist screen
import 'package:geolocator/geolocator.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // Dummy artist data for testing. Replace it with actual data from your backend.
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
    // Dummy data for testing. Replace it with actual data from your backend.
    final List<String> skills = ['Classical Piano', 'Pop', 'Hip-hop', 'R&B', 'Stand-Up', 'Guitarist', 'Chef'];

    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    // Function to filter artistData based on search criteria
    List<Map<String, dynamic>> filterArtistData(String searchTerm) {
      // Filter the artist data based on the search term
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

    // Function to perform search when a skill container is clicked
    void searchBySkill(String skill) {
      // Perform search action based on the clicked skill text
      // You can implement your search logic here
      List<Map<String, dynamic>> filteredData = filterArtistData(skill);

      // Navigate to SearchedArtist screen with filtered results
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchedArtist(filteredArtistData: filteredData)),
      );
    }

    return Scaffold(
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
            color: Color(0xff1e0a11),
          ),
        ),
        backgroundColor: Color(0xffffffff),
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
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30 * fem),
                    borderSide: BorderSide(color: _isSearchBarSelected ? Color(0xffe5195e) :  Color(0xFFA63B5E),), // Change border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30 * fem),
                    borderSide: BorderSide(color: Color(0xffe5195e)), // Change focused border color
                  ),
                ),
                onFieldSubmitted: (value) {
                  // Filter artist data based on the search term
                  List<Map<String, dynamic>> filteredData = filterArtistData(value);

                  // Navigate to SearchedArtist screen with filtered results
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
                children: skills
                    .map(
                      (skill) => GestureDetector(
                    onTap: () {
                      // Perform search action based on the clicked skill text
                      searchBySkill(skill);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16 * fem, vertical: 8 * fem),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f0f2),
                        borderRadius: BorderRadius.circular(20 * fem),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.5 * ffem / fem,
                          color: Color(0xff1e0a11),
                        ),
                      ),
                    ),
                  ),
                )
                    .toList(),
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
                      // Perform action when first clickable text is tapped
                      print('Nearby text tapped');
                      // You can implement your search logic here
                    },
                    child: Text(
                      'Nearby', // First clickable text
                      style: TextStyle(
                        color: Colors.black, // Change text color
                        fontSize: 18 * ffem, // Change font size
                      ),
                    ),
                  ),
                  SizedBox(height: 8 * fem), // Add spacing between clickable texts
                  GestureDetector(
                    onTap: () {
                      // Perform action when second clickable text is tapped
                      print('Top Rated text tapped');
                      // You can implement your search logic here
                    },
                    child: Text(
                      'Top Rated', // Second clickable text
                      style: TextStyle(
                        color: Colors.black, // Change text color
                        fontSize: 18 * ffem, // Change font size
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Add your other content here
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
