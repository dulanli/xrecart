import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertDeleteData extends StatelessWidget {
  const AlertDeleteData({Key? key, required this.text}) : super(key: key);

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
            height: 200,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 65, 20, 10),
              child: Column(
                children: [
                  const SizedBox(height: 0),
                  Text(
                    text,
                    style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.grey[700],             
                      fontSize: 20.0,
                    ),
                  ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const SizedBox(width: 50),
                      ElevatedButton(onPressed: () {
                          deleteData();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent, 
                        ),
                        child: const Text(
                          'Yes', 
                          style: 
                            TextStyle(
                              color: Colors.white
                            ),      
                        ),
                      ),
                      const SizedBox(width: 60),
                      ElevatedButton(onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent, 
                        ),
                        child: const Text(
                          'Cancel', 
                          style: 
                            TextStyle(
                              color: Colors.white
                            ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: -60,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 55,
              child: Icon(Icons.report_problem, color: Colors.white, size: 55),
            )
          ),
        ],
      )
    );
  }

  Future<void> deleteData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = (await auth.signInAnonymously()).user;
    final authUID = user?.uid;

    var collectionPotentialExposure = FirebaseFirestore.instance.collection('PotentialExposure');
    var snapshotPotentialExposure = await collectionPotentialExposure.where('Id', isEqualTo: authUID).get();
    for (var doc in snapshotPotentialExposure.docs) {
      await doc.reference.delete();
    }

    var collectionInContactOneId = FirebaseFirestore.instance.collection('InContact');
    var snapshotInContactOneId = await collectionInContactOneId.where('OneId', isEqualTo: authUID).get();
    for (var doc in snapshotInContactOneId.docs) {
      await doc.reference.delete();
    }

    var collectionInContactUserId = FirebaseFirestore.instance.collection('InContact');
    var snapshotInContactUserId = await collectionInContactUserId.where('UserId', isEqualTo: authUID).get();
    for (var doc in snapshotInContactUserId.docs) {
      await doc.reference.delete();
    }
  }
  
}