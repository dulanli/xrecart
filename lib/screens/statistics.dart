import 'package:flutter/material.dart';
import 'global.dart';
import 'country.dart';
import '../components/navigation_option.dart';

enum NavigationStatus {
  _global,
  _country,
}

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  NavigationStatus navigationStatus = NavigationStatus._global;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF166DE0),
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(right: 0.0, left: 35.0),
          child: Text(
            "COVID-19 STATISTICS",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: Color(0xFF166DE0),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: navigationStatus == NavigationStatus._global ? const Global() : const Country(),
              ),
            ),
          ),

          SizedBox(
            height: size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NavigationOption(
                  title: "Global", 
                  selected: navigationStatus == NavigationStatus._global, 
                  onSelected: () {
                    setState(() {
                      navigationStatus = NavigationStatus._global;
                    });
                  }
                ),
                NavigationOption(
                  title: "Country", 
                  selected: navigationStatus == NavigationStatus._country, 
                  onSelected: () {
                    setState(() {
                      navigationStatus = NavigationStatus._country;
                    });
                  }
                ),
              ],
            )
          ),
        ],  
      )
    );
  }
}