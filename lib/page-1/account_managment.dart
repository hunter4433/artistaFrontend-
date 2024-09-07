import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/artist_info_edit.dart';
import 'package:test1/page-1/artsit_skills_edit.dart';
import 'package:test1/page-1/customer_support.dart';
import 'package:test1/page-1/delete_account.dart';
import 'package:test1/page-1/edit_user_info.dart';
import 'package:test1/page-1/worksamples_edit.dart';




class account_managment extends StatelessWidget {
  final storage = FlutterSecureStorage();

  Future<String?> _getKind() async {
    return await storage.read(key: 'selected_value');
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(backgroundColor: Color(0xFF121217)
      ,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Center(
            child: Text(
              'Account',
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
        child: FutureBuilder<String?>(
          future: _getKind(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            String? kind = snapshot.data;

            // Check the value of 'kind' and set boolean flags accordingly
            bool isHire = kind == 'hire';
            bool isSoloArtist = kind == 'solo_artist';
            bool isTeam = kind == 'team';

            return Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Edit Profile
                  if (isHire)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserInformation()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                      width: double.infinity,
                      height: 56 * fem,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 64 * fem,
                            height: 44 * fem,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Edit Artist Profile (based on conditions)
                  if (isSoloArtist || isTeam)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                        width: double.infinity,
                        height: 56 * fem,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 0.2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Edit Artist Profile',
                                  style: TextStyle(
                                    fontSize: 18 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5 * ffem / fem,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 64 * fem,
                              height: 44 * fem,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,color: Colors.white
                                ,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Edit Skills (based on conditions)
                  if (isSoloArtist || isTeam)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ArtistCredentials33()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                        width: double.infinity,
                        height: 56 * fem,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 0.2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Edit Skills',
                                  style: TextStyle(
                                    fontSize: 17 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5 * ffem / fem,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 64 * fem,
                              height: 44 * fem,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Edit Work Samples (based on conditions)
                  if (isSoloArtist || isTeam)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ArtistCredentials44()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                        width: double.infinity,
                        height: 56 * fem,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 0.2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Edit Work Samples',
                                  style: TextStyle(
                                    fontSize: 17 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5 * ffem / fem,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 64 * fem,
                              height: 44 * fem,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Report a Problem
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>SupportScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                      width: double.infinity,
                      height: 56 * fem,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                'Report a Problem',
                                style: TextStyle(
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 64 * fem,
                            height: 44 * fem,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Delete Account
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => account_delete()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 6 * fem, 10 * fem),
                      width: double.infinity,
                      height: 56 * fem,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.25,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                'Delete Account',
                                style: TextStyle(
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 64 * fem,
                            height: 44 * fem,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
