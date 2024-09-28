import 'package:flutter/material.dart';
import 'artist_showcase.dart';

class SearchedArtist extends StatelessWidget {
  final List<Map<String, dynamic>> filteredArtistData;

  SearchedArtist({required this.filteredArtistData});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor: Color(0xFFF7F6F4),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),

          child: Center(
            child: Text(
              'Artists',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w400,

              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFFFEFEFE),
        leading: IconButton(color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(

        child: filteredArtistData.isNotEmpty
            ? Container(
          width: double.infinity,

          child: ListView.builder(
            itemCount: filteredArtistData.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  final artist = filteredArtistData[index];
                  final isTeam = artist['isTeam'];
                  print('is team is $isTeam');
                  // Navigate to the artist detail page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ArtistProfile(
                            artist_id: filteredArtistData[index]['id'].toString(),
                            isteam :isTeam
                          ),
                    ),
                  );
                },
                child: Theme(
                  data: Theme.of(context).copyWith(cardColor: Colors.white),
                  child: Card(
                    color: Colors.white, // or Colors.white,
                    margin: EdgeInsets.fromLTRB(27 * fem,20 * fem,27 * fem,20 * fem

                    ),
                    elevation: 22,
                    shadowColor: Color(0xFFE9E8E6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12 * fem),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 310.66 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(14 * fem),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(14 * fem),
                              topRight: Radius.circular(14 * fem),
                            ),
// <<<<<<< HEAD
                            child: (filteredArtistData[index]['profile_photo'] != null &&
                                filteredArtistData[index]['profile_photo'].isNotEmpty)
                                ? Image.network(
                              filteredArtistData[index]['profile_photo'],
// =======
//                             child: Image.network(
//                               filteredArtistData[index]['profile_photo'] ?? '',
// >>>>>>> 7843d0fd9f9f56e19be3ee78285dd0192d2cb138
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 50 * fem,
                                  ),
                                );
                              },
                            )
                                : Center(
                              child: Icon(
                                Icons.person, // Placeholder icon when photo is null
                                color: Colors.grey,
                                size: 50 * fem,
                              ),
                            ),
                          ),
                        ),

                        Padding(

                          padding: EdgeInsets.fromLTRB(16 * fem, 25 * fem, 16 * fem, 25 * fem),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
// <<<<<<< HEAD
                                  Text(
                                    filteredArtistData[index]['name'] ?? filteredArtistData[index]['team_name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 22 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.25 * ffem / fem,
                                      letterSpacing: 0.703 * fem,
                                      color: Colors.black,
                                    ),

                                  ),
                                  SizedBox(height: 8 * fem),
                                  Row(
                                    children: [
                                      Text(
                                        'Skill: ${filteredArtistData[index]['skills']}',
                                        style: TextStyle(
                                          fontSize: 17 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5 * ffem / fem,
                                          color: Color(0xFF8E8EAA),
                                        ),
                                      ),
                                      SizedBox(width: 50 * fem),
                                      Text(
                                        'Rating: ${filteredArtistData[index]['rating']}/5',
                                        style: TextStyle(
                                          fontSize: 17 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5 * ffem / fem,
                                          color: Color(0xFF8E8EAA),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

        )
            : Center(
          child: Text(
            "No artists found in your area. We’re working hard to bring them to you soon!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20 * ffem,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

