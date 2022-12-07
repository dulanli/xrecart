import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertPositiveUsers extends StatelessWidget {
  const AlertPositiveUsers({
    Key? key, 
    required this.text,
  }) : super(key: key);

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
            height: 205,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  const SizedBox(height: 0),
                  Text(
                    text,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.grey[700],             
                        fontSize: 17.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: () {
                      //Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/home');
                    },
                    child: const Text(
                      'OK', 
                      style: 
                        TextStyle(
                          color: Colors.white
                        ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Positioned(
            top: -60,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 55,
              child: Icon(Icons.coronavirus, color: Colors.white, size: 55),
            )
          ),
        ],
      )
    );
  }
}