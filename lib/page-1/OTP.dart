import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GalileoDesign2 extends StatelessWidget {
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
              decoration: BoxDecoration(
                color: Color(0xFF121217)
                ,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF121217),
                          ),
                          child: Container(
                            height: 72,
                            padding: EdgeInsets.fromLTRB(16, 28, 16, 20),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 15, 16, 24),
                        child: Center(
                          child: Text(
                            'Enter the code we just texted you',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 22,
                              height: 1.3,
                              letterSpacing: -0.3,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF292938)
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xFF292938)
                                  ,
                                ),
                                child: AspectRatio(
                                  aspectRatio: 0.9,
                                  child: TextField(

                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counterText: '',
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 21.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 21.5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF388FE5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  // Handle button press
                                },
                                child: Text(
                                  'Next',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Send Code Again',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: GalileoDesign2()));
}
