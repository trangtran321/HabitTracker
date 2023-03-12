import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:test1/services.dart/lists.dart';
import 'package:test1/pages/home_page.dart';

class chartBuilder extends StatelessWidget {
  final habitsList = Habit.habitList();
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      for (Habit habit in habitsList)
        ChartData(habit.habitText, habit.habitCount)
      // ChartData('Habit 1', 5, Colors.green),
      // ChartData('Habit 2', 20, Colors.amber),
      // ChartData('Habit 3', 12, Colors.teal),
    ];
    return Scaffold(
      backgroundColor: Colors.amber[200],
      body: Center(
        child: Container(
          child: SfCircularChart(
            series: <CircularSeries>[
              PieSeries<ChartData, String>(
                dataSource: chartData,
                // pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                dataLabelMapper: (ChartData data, _) => data.x,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                explode: true,
                explodeAll: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y,
    // this.color,
  );
  final String? x;
  final double? y;
  // final Color? color;
}
