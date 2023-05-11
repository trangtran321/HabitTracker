import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/services.dart/user_provider.dart';

import '../../models/milestones.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  var db = DatabaseHelper();

  List<Habit> _habits = [];

  late int currentUserId = 0;

  @override
  void initState() {
    super.initState();
    _loadHabits(currentUserId);
  }

  void _loadHabits(int currentUserId) async {
    List<Habit> habits = await db.getAllHabitsForUser(currentUserId);
    setState(() {
      _habits = habits;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User? currentUser = userProvider.currentUser;
    int currentUserId =
        currentUser?.id ?? 0; //defaults to zero, if user is not logged in
    _loadHabits(currentUserId);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: _buildHeader(),
      body: _habits.isNotEmpty
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1),
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                final awards = _getAwardsforHabit(habit);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      habit.habitName,
                      style: const TextStyle(color: Colors.amber, fontSize: 18),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 1.75,
                        shrinkWrap: true,
                        children: awards,
                      ),
                    ),
                  ],
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Milestones milestone = Milestones("", 0,0,0,0);
  bool _ms1Done = false;
  bool _ms2Done = false;

  void _getMilestone (Habit habit) async{
    Milestones currentMilestone = await db.getMilestone(habit.habitName);
    setState((){
      milestone = currentMilestone;
    });
  }

  List<Widget> _getAwardsforHabit (Habit habit){
    final awards = <Widget>[];

    _getMilestone(habit) ;

    if (habit.streakCount >= milestone.ms1 && habit.streakCount > 0 && !_ms1Done) {
      awards.add(Image.asset(
        'images/shield.png',
        height: 10,
      ));
      _ms1Done = true;
    }
    else if (habit.streakCount >= milestone.ms2 && !_ms2Done && habit.streakCount > 0){
      awards.add(Image.asset(
        'images/gem.png',
        height: 10,
      ));
      _ms2Done = true;
    }
    else if (habit.streakCount >= milestone.ms3 && habit.streakCount > 0){
      awards.add(Image.asset(
        "images/crown.png",
        height: 10,
      ));
    }
    return awards;
  }

  AppBar _buildHeader() {ß
    return AppBar(
      backgroundColor: Colors.grey[900],
      centerTitle: true,
      title: const Text(
        'Progress',
        style: TextStyle(
          color: Colors.amber,
          fontSize: 25,
        ),
      ),
    );
  }
}
