import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertFeedback extends StatelessWidget {
  const AlertFeedback({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0)
      ),
      child: Stack(
        clipBehavior: Clip.none, 
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: 175,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 65, 20, 0),
              child: Column(
                children: [
                  Text(
                    text,
                    style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.grey[700],             
                      fontSize: 20.0,
                    ),
                  ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: () {
                      Navigator.of(context).popUntil(ModalRoute.withName('/settings'));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent, 
                    ),
                    child: const Text(
                      'OK', 
                      style: 
                        TextStyle(
                          color: Colors.white
                        ),      
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: -60,
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 55,
              child: Icon(Icons.thumb_up, color: Colors.white, size: 55),
            )
          ),
        ],
      )
    );
  }



}