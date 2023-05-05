import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:habit_tracker/services.dart/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:habit_tracker/models/habit.dart';
import '../models/user.dart';

class ChartBuilder extends StatefulWidget {
  const ChartBuilder({Key? key}) : super(key: key);
  @override
  State<ChartBuilder> createState() => _ChartBuilderState();
}

class _ChartBuilderState extends State<ChartBuilder> {
  var db = DatabaseHelper();
  List<Habit> _habitList = [];
  late int currUserId = 0;

  @override
  void initState() {
    super.initState();
    _loadHabitList(currUserId);
  }

  void _loadHabitList(int currUserId) async {
    List<Habit> habitList = await db.getAllHabitsForUser(currUserId);
    setState(() {
      _habitList = habitList;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User? currUser = userProvider.currentUser;
    int currUserId = currUser?.id ?? 0;
    _loadHabitList(currUserId);

    final List<ChartData> chartData = [
      for (Habit habit in _habitList)
        ChartData(habit.habitName, habit.streakCount),
    ];
    return Scaffold(
      appBar: _buildHeader(),
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          child: SfCircularChart(
            series: <CircularSeries>[
              RadialBarSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  dataLabelMapper: (ChartData data, _) => data.y.toString(),
                  dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(color: Colors.black)),
                  trackColor: Colors.amber,
                  radius: '100%')
            ],
            legend: Legend(
                isVisible: true,
                textStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                width: '150%'),
          ),
        ),
      ),
    );
  }

  AppBar _buildHeader() {
    return AppBar(
      backgroundColor: Colors.grey[900],
      centerTitle: true,
      title: const Text(
        'Progress Chart',
        style: TextStyle(
          color: Colors.amber,
          fontSize: 25,
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y,
  );
  final String x;
  final int y;
}
