import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/page-1/OTP.dart';

class GalileoDesign extends StatefulWidget {
  @override
  _GalileoDesignState createState() => _GalileoDesignState();
}

class _GalileoDesignState extends State<GalileoDesign> {
  bool isChecked = false;
  TextEditingController _controller = TextEditingController(text: '+91 ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121217),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 82,
              padding: EdgeInsets.fromLTRB(26, 28, 16, 20),
            ),
            Container(
              color: Color(0xFF121217),
              height: 35,
              margin: EdgeInsets.fromLTRB(0, 15, 0, 15.5),
              child: Text(
                'Enter your mobile number',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  height: 1.3,
                  letterSpacing: -0.3,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18.7, 0, 18.7, 24),
              child: Text(
                "We'll send you a code to verify your number.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 24),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF292938)),
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFF292938),
              ),
              padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Mobile number',
                  hintStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF637587),
                  ),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  if (!value.startsWith('+91 ')) {
                    _controller.text = '+91 ';
                    _controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: _controller.text.length));
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                    activeColor: Color(0xFF2B8AE8),
                    checkColor: Colors.white,
                  ),
                  Expanded(
                    child: Text(
                      'You agree to our privacy policy and terms and conditions',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 10, 15.8, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isChecked ? Color(0xFF2B8AE8) : Color(0xFF637587),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: isChecked
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GalileoDesign2(),
                          ),
                        );
                      }
                          : null,
                      child: Text(
                        'Send OTP',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.5,
                          letterSpacing: 0.2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 390,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: GalileoDesign()));
}