import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Covid19Info extends StatefulWidget {
  const Covid19Info({Key? key}) : super(key: key);

  @override
  State<Covid19Info> createState() => _Covid19InfoState();
}

class _Covid19InfoState extends State<Covid19Info> {

  @override
  Widget build(BuildContext context) {

    final CollectionReference _products = 
        FirebaseFirestore.instance.collection('Covid19Guidance');

    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF166DE0),
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(right: 0.0, left: 25.0),
          child: Text(
            "COVID-19 INFORMATION",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _products.snapshots(), 
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
                      title: Text(documentSnapshot['title']),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => [
                        launchUrlString(documentSnapshot['link'])
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

}

