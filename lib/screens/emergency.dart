import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Emergency extends StatefulWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  final CollectionReference db = 
        FirebaseFirestore.instance.collection('Emergency');
        
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF166DE0),
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(right: 0.0, left: 45.0),
          child: Text(
            "HOTLINE NUMBERS",
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
                    margin: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 0.0, top: 20.0),
                    child: ListTile( 
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF0586F0),
                        child: Text(documentSnapshot['start_letter']),
                        maxRadius: 30,
                      ),
                      
                      title: 
                        Padding(
                            padding: const EdgeInsets.only(right: 0.0, left: 0.0, bottom: 0.0, top: 7.0),
                            child:
                              Text(documentSnapshot['service'], 
                                style: 
                                  GoogleFonts.roboto(
                                    fontSize: 18,
                                  ),
                              ),
                        ),
                      contentPadding: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 10.0, top: 10.0),
                      subtitle: Text(documentSnapshot['number'], 
                        style: 
                          GoogleFonts.poppins(
                            fontSize: 18,
                          ),
                      ),
                      isThreeLine: true,
                      onTap: () => [
                        _makingPhoneCall(documentSnapshot['number']),
                      ]
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

  _makingPhoneCall(number) async {
  var url = Uri.parse("tel:$number");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

}