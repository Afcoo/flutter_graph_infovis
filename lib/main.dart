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
  late List<List<dynamic>> data;

  @override
  void initState() {
    super.initState();

    debugPrint("Start Data Loading...");
    loadData();
  }

  void loadData() async {
    String csvText;
    if (kIsWeb) {
      final response = await http.get(Uri.parse("assets/assets/data.csv"));
      csvText = utf8.decode(response.bodyBytes);
    } else {
      csvText = await File('assets/data.csv').readAsString();
    }

    data = const CsvToListConverter().convert(csvText);
    debugPrint("Data Load Done");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 800,
            height: 600,
            child: BarChart(
              BarChartData(
                  barGroups: [1, 2, 3, 4]
                      .map((e) => BarChartGroupData(
                            x: e,
                            barRods: [BarChartRodData(toY: e.toDouble())],
                          ))
                      .toList()),
              swapAnimationDuration: const Duration(microseconds: 150),
              swapAnimationCurve: Curves.linear,
            ),
          ),
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
