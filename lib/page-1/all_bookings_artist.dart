import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_details.dart';

class AllBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: Color(0xFF121217),
        title: Text(
          'Requests',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children:[
          _buildRequestCard(
            'AI Debate: The AGI debate',
            'Sat, Dec 23, 2:00 PM',
            context,
          ),
          _buildRequestCard(
            'Introduction to Business Data Analytics',
            'Mon, Dec 26, 5:00 PM',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(String title, String dateTime, BuildContext context) {
    return GestureDetector(
      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetails()));
        // Navigate to the request details page when the card is tapped
      },
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.only(bottom: 16),
            color: Color(0xFF292938),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: Colors.black54,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 30, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    dateTime,
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF9494C7),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Handle reject action here
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Color(0xFF121217),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 9.5),
                          ),
                          child: Text(
                            'Reject',
                            style: GoogleFonts.epilogue(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Handle accept action here
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:Color(0xFF340539),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 9.5),
                          ),
                          child: Text(
                            'Accept',
                            style: GoogleFonts.epilogue(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 18,
            right: 8,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AllBookings(),
  ));
}
