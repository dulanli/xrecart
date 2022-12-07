import 'package:flutter/material.dart';
import '../services/covid_service.dart';
import '../models/global_summary.dart';
import '../components/global_loading.dart';
import '../components/global_statistics.dart';

CovidService covidService = CovidService();

class Global extends StatefulWidget {
  const Global({Key? key}) : super(key: key);

  @override
  State<Global> createState() => _GlobalState();
}

class _GlobalState extends State<Global> {

  Future<GlobalSummaryModel>? summary;

  @override 
  void initState() {
    summary = covidService.getGlobalSummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Global Covid-19 Virus Cases",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    summary = covidService.getGlobalSummary();
                  });
                },
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ),

        FutureBuilder(
          future: summary,
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return const Center(
                child: Text("Error"),
              );
            }
              switch(snapshot.connectionState){
                case ConnectionState.waiting: 
                  return const GlobalLoading();
                default:  
                  return !snapshot.hasData
                  ? const Center (child: Text("Empty"),)
                  : GlobalStatistics(summary: snapshot.data as dynamic);
              }
          },
        ),
      ]
    );
  }
}