import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/home.dart';

class PermissionHandler extends StatefulWidget {
  const PermissionHandler({ Key? key }) : super(key: key);

  @override
  _PermissionHandlerState createState() => _PermissionHandlerState();
}

class _PermissionHandlerState extends State<PermissionHandler> {

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<Widget> permissionCheck() async {
    signInAnon();
    var permissionStatus = await Permission.location.status;

    if (!permissionStatus.isGranted){
      await Permission.location.request();
    }

    permissionStatus = await Permission.location.status;
    if(permissionStatus.isGranted){
      return const Home();
    }

    else {
      return AlertDialog(
        title: const Text('Permission Required'),  // To display the title it is optional
        content: const Text('Cannot proceed without precise location permission'),   // Message which will be pop up on the screen
        // Action widget which will provide the user to acknowledge the choice
        actions: [
          TextButton(           // FlatButton widget is used to make a text to work like a button
            child: const Text('Open App Settings'),
            onPressed: () => [
              Geolocator.openLocationSettings(), 
              Navigator.pushNamed(context, '/'),
            ],  
            // function used to perform after pressing the button
          ),
        ],
      );    
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          // Checking if future is resolved or not
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error    
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occured',
                  style: const TextStyle(
                    fontSize: 18,
                    ),
                ),
              );               
            } else {  // if the data is found
              return snapshot.data as Widget;
            }
          }
          // Displaying LoadingSpinner to indicate waiting state
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        // Future that needs to be resolved
        // inorder to display something on the Canvas
        future: 
          permissionCheck(),
      )
    ); 
  }

  void signInAnon() async {
    User? user = (await auth.signInAnonymously()).user;
    final uid = user?.uid;
    print("my uid is $uid");
  }

}

