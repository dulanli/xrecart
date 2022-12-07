import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text( 
        "Have you recently been tested positive to Covid-19?",
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            color: Colors.grey[800],             
            fontSize: 23,
            ),
        ),
          textAlign: TextAlign.center,
      ),
    );
  }
}