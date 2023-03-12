import 'package:flutter/material.dart';
import 'package:test1/services.dart/lists.dart';
import 'package:test1/services.dart/chartsBuilder.dart';

class HabitsPage extends StatelessWidget {
  final habitsList = Habit.habitList();

  HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text(
          'Progress',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 25,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const Text(
                        'Habit Streaks: \n',
                        style: TextStyle(fontSize: 32, color: Colors.black),
                      ),
                      for (Habit habit in habitsList)
                        Text(
                          '${habit.habitText}: ${habit.habitCount}\n',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.black),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
