import 'package:flutter/material.dart';
import '../services/covid_service.dart';
import '../models/country.dart';
import '../models/country_summary.dart';
import '../components/country_loading.dart';
import '../components/country_statistics.dart';

CovidService covidService = CovidService();

class Country extends StatefulWidget {
  const Country({Key? key}) : super(key: key);

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {

  Future<List<CountryModel>>? countryList;
  Future<List<CountrySummaryModel>>? summaryList;

  @override
  initState() {
    countryList = covidService.getCountry();
    summaryList = covidService.getCountrySummary("Mauritius");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: countryList,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Center(child: Text("Error"));
        }
        switch (snapshot.connectionState){
          case ConnectionState.waiting:
            return const CountryLoading(
              inputTextLoading: true,
            );
          default: 
            return !snapshot.hasData
            ? const Center(child: Text("Empty"))
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  child: Center(
                    child: Text(
                      "MAURITIUS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                FutureBuilder(
                  future: summaryList, 
                  builder: (context, snapshot){
                    if(snapshot.hasError){
                      return const Center(
                        child: Text("Error")
                      );
                    }
                    switch (snapshot.connectionState){
                      case ConnectionState.waiting:
                        return const CountryLoading(
                          inputTextLoading: false,
                        );
                      default: 
                        return !snapshot.hasData
                        ? const Center(child: Text("Empty"),)
                        : CountryStatistics(
                          summaryList: snapshot.data as dynamic,
                        );                       
                    }
                  },
                ),
              ],
            );
        }
      }
    );
  }
}