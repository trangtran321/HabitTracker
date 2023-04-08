import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'habit/habit_tile.dart';
import 'package:habit_tracker/models/habit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var db = DatabaseHelper();
  List<Habit> _habits = [];
  final _habitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  void _loadHabits() async {
    List<Habit> habits = await db.getAllHabits();
    setState(() {
      _habits = habits;
    });
  }

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
                  child: ListView.builder(
                      //creates a list of HabitTiles for each habit in the Habit table
                      itemCount: _habits.length,
                      itemBuilder: (context, index) {
                        return HabitTile(habit: _habits[index]);
                      }),
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
                  onPressed: () async {
                    Habit habit = Habit(_habitController.text, 0);
                    await db.saveHabit(habit);
                    setState(() {
                      _habits.add(habit);
                    });
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
