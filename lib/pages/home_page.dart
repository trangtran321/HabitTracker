import 'package:flutter/material.dart';
import 'package:test1/services.dart/lists.dart';
import 'habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final habitsList = Habit.habitList();
  final _habitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: _buildHeader(),
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
                      for (Habit habit in habitsList)
                        HabitTile(
                          habit: habit,
                          onHabitChanged: _handleHabitChange,
                          onDeleteHabit: _deleteHabit,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                    right: 20,
                    left: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                      controller: _habitController,
                      decoration: const InputDecoration(
                          hintText: 'Add A New Habit To Track!',
                          border: InputBorder.none)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 10,
                  right: 20,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _updateHabitList(_habitController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[300],
                    minimumSize: const Size(60, 60),
                    elevation: 10,
                  ),
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  void _handleHabitChange(Habit habit) {
    setState(() {
      habit.isDone = !habit.isDone;
      if (habit.isDone == true) {
        habit.habitCount++;
        //print('count incremented');
      } else {
        habit.habitCount--;
        //print('count decremented');
      }
    });
  }

  void _deleteHabit(String id) {
    setState(() {
      habitsList.removeWhere((habit) => habit.id == id);
    });
  }

  void _updateHabitList(String habit) {
    setState(() {
      habitsList.add(Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        habitText: habit,
      ));
    });
    _habitController.clear();
  }

  AppBar _buildHeader() {
    return AppBar(
      backgroundColor: Colors.grey[900],
      centerTitle: true,
      title: const Text(
        'Habit Tracker',
        style: TextStyle(
          color: Colors.amber,
          fontSize: 25,
        ),
      ),
    );
  }
}
