import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../components/bottom_navigation.dart';

class GMap extends StatefulWidget {
  const GMap({Key? key}) : super(key: key);

  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final Set<Circle> _circles = HashSet<Circle>();
  List<LatLng> points = <LatLng>[];
  int _circleIdCounter = 1;
  LatLng? currentLatLng;
  String? _datetimeText;

  @override
  void initState() { 
    _getCurrentLocation();
    _addLatLngToList(); 
    super.initState();
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
        defaultSelectedIndex: 1,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF166DE0),
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(110, 0, 0, 0),
          child: Text(
            "IN CONTACT MAP",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
      body: currentLatLng == null ? const Center(child:CircularProgressIndicator()) : 
        Stack(
          children: [
            GoogleMap(
              onMapCreated: _setMapStyle, 
              initialCameraPosition: CameraPosition(
                  target: currentLatLng as LatLng,
                  zoom: 12,
                ),
                circles: _circles,
                myLocationEnabled: true,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
              child: 
              _datetimeText == null ? const Text('') :  Text(
                "You have been in contact with a positive user at around $_datetimeText",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  void _setMapStyle(GoogleMapController controller) async {
    String style = await DefaultAssetBundle.of(context).loadString('assets/map/map_style.json');
    controller.setMapStyle(style);
  }

  void _setCircles(LatLng point, String datetime) async{
    String circleIdVal = 'circle_id_$_circleIdCounter';
      _circleIdCounter++;

    _circles.add(
      Circle(
        circleId: CircleId(circleIdVal),
        center: point,
        radius: 50,
        strokeWidth: 0,
        fillColor: const Color(0x79FF0000),
        consumeTapEvents: true,
        onTap: (() {
          setState((){
            _datetimeText = datetime;
          });
        })
      )
    );
  }

  Future<void> _addLatLngToList() async {
    User? user = (await auth.signInAnonymously()).user;
    final authUID = user?.uid;
    double _latitude; 
    double _longitude; 
    String _oneId; 
    String _userId; 
    DateTime _datetimeDB;
    DateTime _datetimeNow = DateTime.now();
    int differenceInDays;
    String formattedDate;

    db.collection("InContact")      // places where there have been most people interactions
    .where("CovidStatus", isEqualTo: "Positive")
    .get().then((event) {
      if (event.docs.isEmpty) {
        print("No at-risk place found!");
      }
      else {
        for (var doc in event.docs) {
          _latitude = doc.get("Latitude");
          _longitude = doc.get("Longitude");
          _oneId = doc.get("OneId");
          _userId = doc.get("UserId");
          _datetimeDB = doc.get("Timestamp").toDate();
          differenceInDays = _datetimeNow.difference(_datetimeDB).inDays;
          LatLng newPoint = LatLng(_latitude, _longitude);
          
          formattedDate = DateFormat('kk:mm a - dd.MM.yyyy').format(_datetimeDB);

          if (differenceInDays <= 14 && (_oneId == authUID || _userId == authUID)){               
            setState(() {
              points.add(newPoint);
            });
            for (var i = 0; i < points.length; i++){
              _setCircles(points[i], formattedDate);
            }  
          }
        }
      }
    });    
  }

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition().then((currentLocation){
      setState((){
        currentLatLng = LatLng(currentLocation.latitude, currentLocation.longitude);
      });
    });
  }
  
}