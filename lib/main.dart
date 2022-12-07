import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/covid19_info.dart';
import 'screens/emergency.dart';
import 'screens/positive.dart';
import 'screens/onboarding.dart';
import 'screens/home.dart';
import 'screens/statistics.dart';
import 'screens/settings.dart';
import 'screens/aboutapp.dart';
import 'screens/map.dart';
import 'screens/feedback.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Onboarding(), 
        '/home':(context) => const Home(),
        '/positive':(context) => const Positive(),
        '/statistics':(context) => const Statistics(),
        '/settings':(context) => const Settings(),
        '/covid19guidance':(context) => const Covid19Info(),
        '/aboutapp':(context) => const AboutApp(),
        '/gmap':(context) => const GMap(),
        '/emergency':(context) => const Emergency(),
        '/feedback':(context) => const Feedbacks(),
      },
    );
  }
}
