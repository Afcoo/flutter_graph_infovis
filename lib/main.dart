import 'dart:convert';
import 'dart:math' as math;

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

  var regionText = <String, String>{
    "전국": "Countrywide",
    "서울특별시": "Seoul",
    "부산광역시": "Busan",
    "대구광역시": "Daegu",
    "인천광역시": "Incheon",
    "광주광역시": "Gwangju",
    "대전광역시": "Daejeon",
    "울산광역시": "Ulsan",
    "세종특별자치시": "Sejong",
    "경기도": "Gyeonggi-do",
    "강원도": "Gangwon-do",
    "충청북도": "Chungcheongbuk-do",
    "충청남도": "Chungcheongnam-do",
    "전라북도": "Jeollabuk-do",
    "전라남도": "Jeollanam-do",
    "경상북도": "Gyeongsangbuk-do",
    "경상남도": "Gyeongsangnam-do",
    "제주특별자치도": "Jeju-do",
  };

  var availableChart = <String, int>{
    "Bar Chart": 1,
    "Line Chart": 2,
    "Pie Chart": 3,
  };

  final double chartWidth = 800;
  final double chartHeight = 600;

  @override
  void initState() {
    super.initState();

    debugPrint("Start Data Loading...");
  }

  Future<bool> loadData() async {
    if (data.isNotEmpty) return true;
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

    int nRows = rawData.length;
    int nCols = rawData[0].length;

    years = List<int>.generate(22, (index) => index + 2000);
    ages = List<String>.generate(8, (index) => parseAges(rawData[1][index + 1]));
    regions = List<String>.generate(17, (index) => rawData[index + 2][0]);

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

    clearFilter();
    // showFilterDialog();
    return true;
  }

  String parseAges(String age) => age.replaceAll("모의 연령별출산율:", "").replaceAll("세", "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: DropdownButton(
          items: availableChart.entries
              .map((e) => DropdownMenuItem(
                    value: e.value,
                    child: Text(
                      e.key,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            chartNum = value!;

            clearFilter();
          },
          value: chartNum,
        ),
      ),
      body: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) => snapshot.hasData
            //데이터 로드 완료
            ? getChart()
            // 그 외 (에러 및 로딩중)
            : const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showFilterDialog,
        tooltip: 'Set Filter',
        child: const Icon(Icons.filter_alt_outlined),
      ),
    );
  }

  void showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<Widget> filters = filterOptions
                .map(
                  (e) => Row(
                    children: [
                      Checkbox(
                        value: selectedFilter.contains(e),
                        onChanged: (value) {
                          if (value!) {
                            selectedFilter.add(e);
                          } else {
                            selectedFilter.removeWhere((element) => (element == e));
                          }
                          setState(() {});
                        },
                      ),
                      const SizedBox(width: 5),
                      Text(
                        regionText[e]!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )
                .toList();
//
            filters.insert(
              0,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        selectedFilter = List.from(regions);
                        setState(() {});
                      },
                      child: const Text("Select All")),
                  TextButton(
                      onPressed: () {
                        selectedFilter.clear();
                        setState(() {});
                      },
                      child: const Text("Deselect All")),
                ],
              ),
            );
            filters.insert(1, const Row(children: [SizedBox(height: 10)]));

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text("Set Filter", style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: filters,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Done"),
                )
              ],
            );
          },
        );
      },
    );
    setState(() {});
  }

  void clearFilter() {
    switch (chartNum) {
      case 1:
        filterOptions = List.from(regions);
        selectedFilter = List.from(regions);
        break;
      case 2:
        filterOptions = List.from(regions);
        // selectedFilter = List.from(regions);
        selectedFilter = <String>["전국"];
        break;
      case 3:
        break;
    }
    setState(() {});
  }

  int chartNum = 1;

  double _year = 2021;
  var _yearRange = const RangeValues(2000, 2021);

  bool applySort = false;
  bool sortAscending = false;

  List<String> filterOptions = List.empty();
  List<String> selectedFilter = List.empty();

  TextStyle sliderTextStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  double baseY = 1.0;
  double zoomY = 1.0;

  List<int> colorCodes = <int>[
    0xfffd7f6f,
    0xff7eb0d5,
    0xffb2e061,
    0xffbd7ebe,
    0xffffb55a,
    0xffffee65,
    0xffbeb9db,
    0xfffdcce5,
    0xff8bd3c7,
    0xffb30000,
    0xff7c1158,
    0xff4421af,
    0xff1a53ff,
    0xff0d88e6,
    0xff00b7c7,
    0xff5ad45a,
    0xff8be04e,
    0xffebdc78,
  ];

  Widget getChart() {
    switch (chartNum) {
      case 1:
        // First Bar Chart
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 200),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text("Year : ${_year.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("2000", style: sliderTextStyle),
                    SizedBox(
                      width: 600,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6,
                        ),
                        child: Slider(
                          value: _year,
                          onChanged: (value) => setState(() {
                            _year = value.roundToDouble();
                          }),
                          min: 2000,
                          max: 2021,
                          divisions: 20,
                          label: _year.toString(),
                        ),
                      ),
                    ),
                    Text("2021", style: sliderTextStyle),
                  ],
                ),

                const SizedBox(height: 30),
                // chart
                SizedBox(
                  width: chartWidth,
                  height: chartHeight,
                  child: getBarChart(
                    year: _year.toInt(),
                    xAxis: List.from(selectedFilter),
                    subXAxis: ['합계출산율'],
                    sort: applySort,
                    isAscending: sortAscending,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 50),
            SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const Text("Sorting", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: applySort,
                        onChanged: (value) {
                          applySort = value!;
                          setState(() {});
                        },
                      ),
                      const Text("Apply Sorting", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  if (applySort)
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Checkbox(
                          value: !sortAscending,
                          onChanged: (value) {
                            sortAscending = false;
                            setState(() {});
                          },
                        ),
                        const Text("Descending Order", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  if (applySort)
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Checkbox(
                          value: sortAscending,
                          onChanged: (value) {
                            sortAscending = true;
                            setState(() {});
                          },
                        ),
                        const Text("Ascending Order", style: TextStyle(fontSize: 18)),
                      ],
                    )
                ],
              ),
            ),
          ],
        );
      case 2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              child: Stack(
                children: [
                  Positioned(
                    top: 150,
                    left: -50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(zoomY.toStringAsFixed(1), style: sliderTextStyle),
                        Transform.rotate(
                          angle: -math.pi / 2,
                          origin: const Offset(70, 70),
                          child: SizedBox(
                            width: 300,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 6,
                                minThumbSeparation: 50,
                              ),
                              child: Slider(
                                value: zoomY,
                                min: 1,
                                max: 2.9,
                                onChanged: (value) => setState(() {
                                  zoomY = value;
                                }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 300),
                        Text("Zoom Y Axis", style: sliderTextStyle)
                      ],
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(baseY.toStringAsFixed(1), style: sliderTextStyle),
                        Transform.rotate(
                          angle: -math.pi / 2,
                          origin: const Offset(70, 70),
                          child: SizedBox(
                            width: 300,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 6,
                                minThumbSeparation: 50,
                              ),
                              child: Slider(
                                value: baseY,
                                min: 0,
                                max: 2,
                                onChanged: (value) => setState(() {
                                  baseY = value;
                                }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 300),
                        Text("Base Y Axis", style: sliderTextStyle)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                SizedBox(
                  width: chartWidth,
                  height: chartHeight,
                  child: getLineChart(
                    minYear: _yearRange.start.toInt(),
                    maxYear: _yearRange.end.toInt(),
                    regions: List.from(selectedFilter),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("2000", style: sliderTextStyle),
                    SizedBox(
                      width: 600,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6,
                          minThumbSeparation: 50,
                        ),
                        child: RangeSlider(
                          values: _yearRange,
                          onChanged: (values) => setState(() {
                            _yearRange = RangeValues(values.start.roundToDouble(), values.end.roundToDouble());
                          }),
                          min: 2000,
                          max: 2021,
                          divisions: 20,
                          labels: RangeLabels(
                            _yearRange.start.round().toString(),
                            _yearRange.end.round().toString(),
                          ),
                        ),
                      ),
                    ),
                    Text("2021", style: sliderTextStyle),
                  ],
                ),
                Text("Year: ${_yearRange.start} - ${_yearRange.end}", style: sliderTextStyle),
              ],
            ),
            const SizedBox(width: 50),
            SizedBox(
              width: 270,
              child: getLegend(),
            ),
          ],
        );
      case 3:
      default:
        return const SizedBox.shrink();
    }
  }

  Widget getBarChart({
    required int year,
    required List<String> xAxis,
    required List<String> subXAxis,
    bool sort = false,
    bool isAscending = false,
  }) {
    if (sort) {
      xAxis.sort((a, b) {
        double? _a = getData(year, a, subXAxis[0]);
        double? _b = getData(year, b, subXAxis[0]);

        _a ??= isAscending ? 100 : 0;
        _b ??= isAscending ? 100 : 0;

        return isAscending ? _a.compareTo(_b) : _b.compareTo(_a);
      });
    }

    return BarChart(
      BarChartData(
        maxY: 2,
        gridData: const FlGridData(
          // drawHorizontalLine: false,
          drawVerticalLine: false,
        ),
        rangeAnnotations: const RangeAnnotations(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Transform.rotate(
                angle: 1,
                origin: const Offset(-75, 125),
                child: SizedBox(
                  width: 280,
                  child: Text(
                    regionText[xAxis[value.toInt() - 1]] ?? "?",
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 32,
              interval: 0.5,
              showTitles: true,
            ),
          ),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        barGroups: xAxis
            .asMap()
            .entries
            .map(
              (x) => BarChartGroupData(
                x: x.key + 1,
                // barRods: subXAxis
                //     .map((subX) => BarChartRodData(
                //           toY: getData(year, subX, x.value) ?? 0,
                //           color: Color(colorCodes[x.key]),
                //           width: 25,
                //         ))
                //     .toList(),
                barRods: [
                  BarChartRodData(
                    toY: getData(year, subXAxis[0], x.value) ?? 0,
                    color: Color(colorCodes[x.key]),
                    width: 25,
                  )
                ],
              ),
            )
            .toList(),
        barTouchData: BarTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: BarTouchTooltipData(
            maxContentWidth: 180,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String region = xAxis[groupIndex];
              String age = subXAxis[rodIndex];

              return BarTooltipItem(
                "[${regionText[region]}]\n${rod.toY}",
                const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              );
            },
          ),
        ),
      ),
      swapAnimationDuration: const Duration(microseconds: 150),
      swapAnimationCurve: Curves.linear,
    );
  }

  Widget getLineChart({
    required int minYear,
    required int maxYear,
    List<String> regions = const <String>["전국"],
    List<String>? excludeXs,
  }) {
    var yearLength = maxYear - minYear + 1;
    var minY = baseY - (3 - zoomY);
    var maxY = baseY + (3 - zoomY);
    minY = minY < 0 ? 0 : minY;

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        minX: 0,
        maxX: yearLength.toDouble() - 1,
        gridData: const FlGridData(
          drawHorizontalLine: true,
          horizontalInterval: 0.1,
          drawVerticalLine: true,
          verticalInterval: 1,
        ),
        rangeAnnotations: const RangeAnnotations(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              getTitlesWidget: (value, meta) => Transform.rotate(
                angle: 1,
                origin: const Offset(-75, 125),
                child: SizedBox(
                  width: 280,
                  child: Text(
                    (value + minYear).toString(),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              interval: 0.5,
              showTitles: true,
            ),
          ),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        lineBarsData: regions
            .asMap()
            .entries
            .map(
              (e) => LineChartBarData(
                color: Color(colorCodes[e.key]),
                spots: List.generate(
                  yearLength,
                  (index) {
                    int year = minYear + index;
                    double value = getData(year, e.value, "합계출산율") ?? 0;

                    if (value > maxY) value = maxY;
                    if (value < minY) value = minY;

                    return FlSpot(index.toDouble(), value);
                  },
                ),
              ),
            )
            .toList(),
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
              fitInsideVertically: true,
              tooltipBgColor: Colors.black.withOpacity(0.8),
              maxContentWidth: 250,
              getTooltipItems: (touchedSpots) => touchedSpots.asMap().entries.map(
                    (e) {
                      int year = (touchedSpots[0].spotIndex + minYear);
                      String yearTooptip = "[ ${year.toString()} ]\n";

                      return LineTooltipItem(
                        "${e.key == 0 ? yearTooptip : ""}${regionText[regions[e.value.barIndex]]}: ${e.value.bar.spots[e.value.spotIndex].y}",
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ).toList()),
        ),
      ),
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  }

  Widget getLegend() {
    List<Widget> legends = selectedFilter.asMap().entries.map((e) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: ColoredBox(color: Color(colorCodes[e.key])),
          ),
          const SizedBox(width: 10),
          Text(
            regionText[e.value] ??= "",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[const SizedBox(height: 100)] + legends,
    );
  }

  double? getData(int year, String s1, String s2) {
    late String region, age;
    if (regions.contains(s1)) {
      region = s1;
      age = s2;
    } else {
      region = s2;
      age = s1;
    }
    return data[year]?[age]?[region];
  }
}
