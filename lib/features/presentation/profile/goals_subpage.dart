import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/profile_model.dart';

class GoalsSubPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoalsSubPageState();
}

class _GoalsSubPageState extends State<GoalsSubPage> {
  int _touchedRodBarIndex;
  int _maxStepCount = 0;
  int _dailyStepCountGoal;
  int _totalStepsInWeek;
  double _maxY;
  static const int _rodBarGrowthOnTouchValue = 300;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileModel>(builder: (context, profile, _) {
      _maxStepCount =
          profile.weeklyStepCountList.map((steps) => steps).reduce(max);
      _dailyStepCountGoal = profile.dailyStepCountGoal;
      _maxY = max(_dailyStepCountGoal * 1.5, _maxStepCount.toDouble());
      _totalStepsInWeek = profile.weeklyStepCountList
          .reduce((value, element) => value + element);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: EdgeInsets.all(6)),
          Center(
            child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    children: <TextSpan>[
                  TextSpan(text: "You walked "),
                  TextSpan(
                    text: "$_totalStepsInWeek steps",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " this week")
                ])),
          ),
          Padding(padding: EdgeInsets.all(6)),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: BarChart(BarChartData(
                    maxY: _maxY,
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Color(0xff666666),
                          getTooltipItem: (_, __, rod, ___) {
                            return BarTooltipItem(
                                ((rod.y - _rodBarGrowthOnTouchValue).toInt())
                                    .toString(),
                                TextStyle(
                                    color: Theme.of(context).primaryColor));
                          }),
                      touchCallback: (barTouchResponse) {
                        setState(() {
                          _touchedRodBarIndex = (barTouchResponse.spot != null)
                              ? barTouchResponse.spot.touchedBarGroupIndex
                              : _touchedRodBarIndex = -1;
                        });
                      },
                    ),
                    barGroups: profile.weeklyStepCountList
                        .asMap()
                        .entries
                        .map((entry) => _createStepsCountGroupData(
                            context, entry.key, entry.value, _maxStepCount))
                        .toList(),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) => const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 16,
                        getTitles: (double value) {
                          switch (value.toInt()) {
                            case 0:
                              return 'M';
                            case 1:
                              return 'T';
                            case 2:
                              return 'W';
                            case 3:
                              return 'T';
                            case 4:
                              return 'F';
                            case 5:
                              return 'S';
                            case 6:
                              return 'S';
                            default:
                              return '';
                          }
                        },
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) => const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        reservedSize: 10,
                        interval: 1000,
                        getTitles: (value) {
                          return '${value.toDouble() ~/ 1000}K';
                        },
                      ),
                    ),
                  ))))
        ],
      );
    });
  }

  BarChartGroupData _createStepsCountGroupData(
      BuildContext context, int dayOfWeek, int stepsCount, int maxStepsCount) {
    // print("Day of week $dayOfWeek");
    return BarChartGroupData(x: dayOfWeek, barRods: [
      BarChartRodData(
          y: dayOfWeek == _touchedRodBarIndex
              ? stepsCount.toDouble() + _rodBarGrowthOnTouchValue
              : stepsCount.toDouble(),
          colors: stepsCount >= _dailyStepCountGoal
              ? [Color(0xff46ADD5)]
              : [Theme.of(context).primaryColor],
          width: 22,
          backDrawRodData: BackgroundBarChartRodData(
              show: true, colors: [Color(0xFFF0F0F0)], y: _maxY))
    ]);
  }
}
