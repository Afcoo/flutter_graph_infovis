import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:io';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // data[연도][나이대][지역]
  var data = <int, Map<String, Map<String, double>>>{};
  late List<int> years;
  late List<String> ages;
  late List<String> regions;

  late Future<Map<String, Map<String, double>>>? renderData;

  @override
  void initState() {
    super.initState();

    debugPrint("Start Data Loading...");
    loadData();
  }

  Future<void> loadData() async {
    String csvText;
    if (kIsWeb) {
      final response = await http.get(Uri.parse("assets/assets/data.csv"));
      csvText = utf8.decode(response.bodyBytes);
    } else {
      csvText = await File('assets/data.csv').readAsString();
    }

    List<List<dynamic>> rawData = const CsvToListConverter(eol: '\n').convert(csvText);
    debugPrint("Raw Data Loaded!");
    debugPrint("Start Parsing...");
    debugPrint("Raw Data Loaded!");
    debugPrint("Start Parsing...");

    int nRows = rawData.length;
    int nCols = rawData[0].length;

    years = List<int>.generate(22, (index) => index + 2000);
    ages = List<String>.generate(8, (index) => parseAges(rawData[1][index + 1]));
    regions = List<String>.generate(nRows - 2, (index) => parseAges(rawData[index + 2][0]));
    regions = List<String>.generate(nRows - 2, (index) => parseAges(rawData[index + 2][0]));

    for (int year in years) {
      data[year] = <String, Map<String, double>>{};

      for (String age in ages) {
        data[year]![age] = <String, double>{};
      }
    }

    for (var i = 1; i < nCols; i++) {
      int year = rawData[0][i];
      String age = parseAges(rawData[1][i]);

      for (var j = 2; j < nRows; j++) {
        String region = rawData[j][0];

        var value = rawData[j][i];
        if (value != "-") {
          data[year]![age]![region] = value.toDouble();
        }
      }
    }

    debugPrint("Data Load Done:");
    // debugPrint(data.toString());
    setState(() {});
  }

  String parseAges(String age) => age.replaceAll("모의 연령별출산율:", "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: Future.delayed(Duration(seconds: 3)),
            builder: (context, snapshot) => Center(
              child: SizedBox(
                width: 800,
                height: 600,
                child: BarChart(
                  BarChartData(
                      barGroups: List<int>.generate(regions.length, (i) => i)
                          .map((i) => BarChartGroupData(
                                x: i + 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: data[2020]!['합계출산율']![regions[i]]!,
                                  )
                                ],
                              ))
                          .toList()),
                  swapAnimationDuration: const Duration(microseconds: 150),
                  swapAnimationCurve: Curves.linear,
                ),
              ),
            ),
          ),
          // Chart
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
