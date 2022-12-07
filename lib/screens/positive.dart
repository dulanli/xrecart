import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/alert_positive_users.dart';
import '../components/question_card.dart';

class Positive extends StatefulWidget {
  const Positive({Key? key}) : super(key: key);

  @override
  State<Positive> createState() => _PositiveState();
}

class _PositiveState extends State<Positive> {

  var _result;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
                height: MediaQuery.of(context).size.height * .18,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topRight,
                      image: AssetImage('assets/images/header.png')
                    )
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 110),
                Text(
                  '''Inform your surroundings about a possible transmission\nThis will help in the fight against Covid-19''',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: Colors.blueGrey,             
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 1.5),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10.0),
                  decoration: 
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  child: Column(
                    children: [
                      const QuestionCard(),
                      const SizedBox(height: 20),
                      RadioListTile(
                        title: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.grey[800], 
                            fontSize: 20
                          ),
                        ),
                        value: "yes",
                        groupValue: _result,
                        onChanged: (value) {
                          setState(() {
                            _result = value;
                          });
                        }
                      ),
                      RadioListTile(
                        title: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.grey[800], 
                            fontSize: 20
                          ),
                        ),
                        value: "no",
                        groupValue: _result,
                        onChanged: (value) {
                          setState(() {
                            _result = value;
                          });
                        }
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 1.5),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton.icon(
                    label: const Icon(Icons.navigate_next),
                    icon: const Text('Done'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(right: 65.0, left: 80.0, bottom: 15.0, top: 15.0),
                      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      primary: Colors.blueAccent,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // <-- Radius
                      ),   
                      elevation: 10,  
                    ),  
                    onPressed: () => [
                      if (_result == "yes"){
                        updateCovidStatus(),
                        showDialog(context: context, 
                          builder: (BuildContext context){
                            return const AlertPositiveUsers(text: '  Your surroundings have been alerted about a possible Covid-19 transmission');
                          }
                        )
                      }
                      else if (_result == "no"){
                        showDialog(context: context, 
                          builder: (BuildContext context){
                            return const AlertPositiveUsers(text: 'If you are experiencing any symptoms, please perform a Covid-19 test');
                          }
                        )
                      }
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
          ),
    );
  }

  updateCovidStatus () async {
    User? user = (await auth.signInAnonymously()).user;
    final _oneId = user?.uid;
    
    db.collection("InContact")
    .where("OneId", isEqualTo: _oneId)
    .get().then((event) {
      for (var doc in event.docs) {
        final updateCovidStatus = db.collection("InContact").doc(doc.id);
        updateCovidStatus.update({"CovidStatus": "Positive"}).then(
          (value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
      }
    });
  }
}
