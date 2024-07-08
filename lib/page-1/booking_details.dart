import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: Color(0xFF121217),
        title: Text(
          'Event Details',
          style: GoogleFonts.epilogue(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            height: 1.3,
            color: Color(0xFFFFFFFF),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Text(
              'DJ set at a private party',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                height: 1.3,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Sat, Dec 23, 2023',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 16),
            _buildInfoSection(
              title: 'Location',
              info: 'The Hollywood Roosevelt',
            ),
            _buildInfoSection(
              title: 'Audience Size',
              info: '500 people',
            ),
            _buildInfoSection(
              title: 'Type',
              info: 'Party',
            ),
            _buildInfoSection(
              title: 'Offer Amount',
              info: '\$50,000',
            ),
            SizedBox(height: 20),
            Text(
              'Description',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                height: 1.3,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We\'re hosting a private party for our employees. We\'d love to have you DJ the event.',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Special Requests',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                height: 1.3,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We\'d love to hear your new music!',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required String info}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 13.5),
      color: Color(0xFF121217),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.5,
              color: Color(0xFFFFFFFF),
            ),
          ),
          SizedBox(height: 4),
          Text(
            info,
            style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF9494C7),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EventDetails(),
  ));
}
