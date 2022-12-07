import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import '../components/bottom_navigation.dart';
import '../models/tracing_switch.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  
  Timer? timer;
  double currentLong = 0.0;
  double currentLat = 0.0;
  List<Position> locations = <Position>[];
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String switchText = "ON";
  IconData switchIcon = EvaIcons.checkmark;
  int switchColor = 0x00a2cf6e;

  @override
  void initState() {      // check if it runs in background
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {     // check after each 15 minutes (15secs for testing purposes)
      if (TracingSwitch.tracing == true) {
        _getCurrentLocation();  
      }
      else if (TracingSwitch.tracing == false){
        print("Tracing is Off");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: CustomBottomNavigationBar(
        iconList: const [
          Icons.home,
          Icons.map,
          Icons.settings,
        ],
        onChange: (val) {
          setState(() {});
        },
        defaultSelectedIndex: 0,
      ),

      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .18,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topRight,
                  image: AssetImage('assets/images/header.png')
                )
            ),
          ),
          const SizedBox(
            height: 90, 
            //width: 500, 
          ),
          RippleAnimation(
            repeat: true,
            color: Color(switchColor),
            minRadius: 150,
            ripplesCount: 4,
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 4000),
            child: Icon(
              switchIcon,
              size: 35,
            ),
          ),
          const SizedBox(
            height: 80, 
          ),
          buildHeader(
            child: buildSwitch(),
          ),
          Text(
            "Tracing is $switchText",
            style: 
              GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton.icon(
            label: const Text('Positive'),
            icon: const Icon(
              Icons.sick, 
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(right: 120.0, left: 100.0, bottom: 17.0, top: 17.0),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              primary: Colors.lightBlue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // <-- Radius
              ),   
              elevation: 10,  
            ),  
            onPressed: () {
              Navigator.pushNamed(context, '/positive');
            },
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton.icon(
            label: const Text('Statistics'),
            icon: const Icon(
              Icons.insert_chart, 
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(right: 108.0, left: 97.0, bottom: 17.0, top: 17.0),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              primary: Colors.lightBlue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // <-- Radius
              ),
              elevation: 10, 
            ),
            onPressed: (){
              Navigator.pushNamed(context, '/statistics');
            },
          ),
        ],
      )
    );
  }

  Widget buildHeader({
    required Widget child,
  }) =>
      Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          child,
          const SizedBox(height: 1),
        ],
      );

  Widget buildSwitch() => Transform.scale(
    scale: 1.3,
    child: Switch.adaptive(
    activeColor: Colors.blueAccent,
    activeTrackColor: Colors.blueAccent.withOpacity(0.4),
    inactiveThumbColor: Colors.white,
    inactiveTrackColor: Colors.black.withOpacity(0.4),
    value: TracingSwitch.tracing,
    onChanged: (value) => setState(() => [
        TracingSwitch.tracing = value,
        if (value == true){
          setState(() {
            switchText = "ON";
            switchColor = 0x00a2cf6e;
            switchIcon =  EvaIcons.checkmark;
          })
        },
        if (value == false){
          setState(() {
            switchText = "OFF";
            switchColor = 0xFFEB3F3F;
            switchIcon =  EvaIcons.alertTriangleOutline;
          })
        }
      ]
    ),

    )
  );

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    Position _currentPosition;
    Position _previousPosition;

    if (!mounted) return;

    setState((){
      _currentPosition = position;
      currentLat = position.latitude;
      currentLong = position.longitude;
      locations.add(_currentPosition);

      if (locations.length > 1) {
        _previousPosition = locations.elementAt(locations.length - 2);
        print('===================');
        print('CURRENT = $_currentPosition');
        print('PREVIOUS = $_previousPosition');
        print('===================');

        addToDatabase(currentLat, currentLong);
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission? permission;

    permission = await Geolocator.checkPermission();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  Future<void> addToDatabase (lat, long) async {
    User? user = (await auth.signInAnonymously()).user;
    final authUID = user?.uid;
    checkInContact(lat, long); 

    db.collection("PotentialExposure")
    .where("Id", isEqualTo: authUID)
    .get().then((event) {
      if (event.docs.isEmpty) {
        db.collection('PotentialExposure')
        .add({
          "Timestamp": Timestamp.now(),
          'Id': authUID,
          'Latitude': lat,
          'Longitude': long,
        });
      }
      else {
        for (var doc in event.docs) {
          final updatePotentialExposure = db.collection("PotentialExposure").doc(doc.id);
          updatePotentialExposure.update({
            "Timestamp": Timestamp.now(),
            "Latitude": lat,
            "Longitude": long,
          }).then(
            (value) => print("Potential Exposure Data successfully updated!"),
            onError: (e) => print("Error updating document $e"));
        }
      }
    });
  }

  checkInContact (lat, long) async {
    User? user = (await auth.signInAnonymously()).user;
    final authUID = user?.uid;

    double _onePositionlatitude = lat;
    double _onePositionlongitude = long;
    double _userPositionlatitude = 0.0;
    double _userPositionlongitude = 0.0;
    String _userId = "";

    DateTime _datetimeUser;
    DateTime _datetimeOne = DateTime.now();
    int differenceInSecs;

    db.collection("PotentialExposure")
    .get().then((event) {
      for (var doc in event.docs) {
        _userPositionlatitude = doc.get("Latitude");
        _userPositionlongitude = doc.get("Longitude");
        _userId = doc.get("Id");
        _datetimeUser = doc.get("Timestamp").toDate();
        
        var _distanceBetweenOneAndUser = Geolocator.distanceBetween(
          _onePositionlatitude,
          _onePositionlongitude,
          _userPositionlatitude,
          _userPositionlongitude,       
        );
        differenceInSecs = _datetimeOne.difference(_datetimeUser).inSeconds;

        if (_distanceBetweenOneAndUser < 2 && differenceInSecs <= 1555  && _userId != authUID) {     // testing - should be 15mins          
          db.collection('InContact')      
          .add({
            'Timestamp': Timestamp.now(),
            'OneId': authUID,
            'UserId': _userId,
            'Latitude': lat,
            'Longitude': long,
            'CovidStatus': 'Negative',
          });
        }
        else {
          print("No in-contact users found!");
        }
                  
      }
  });
  }

}

