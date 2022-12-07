import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {

  @override
  Widget build(BuildContext context) {

    final CollectionReference db = 
        FirebaseFirestore.instance.collection('AboutApp');

    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF166DE0),
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(right: 0.0, left: 50.0),
          child: Text(
            "ABOUT THIS APP",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
      body: Center(
        child: StreamBuilder(
          stream: db.snapshots(), 
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card( 
                    margin: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0, top: 10.0),
                    child: ListTile( 
                      title: 
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child:
                              Text(documentSnapshot['title'], 
                                style: 
                                  GoogleFonts.roboto(
                                    fontSize: 18,
                                  ),
                              ),
                        ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                      subtitle: Text(documentSnapshot['description'], 
                        style: 
                          GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            }
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),   
    ); 
  }
}

