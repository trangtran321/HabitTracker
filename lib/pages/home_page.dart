import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services.dart/notificationService.dart';
import '../services.dart/user_provider.dart';
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
    //get this.currentUser ID number to input into newly created habit
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User? currentUser = userProvider.currentUser;
    int currentUserId =
        currentUser?.id ?? 0; //defaults to zero, if user is not logged in
    _loadHabits(
        currentUserId); //once logged in, this will load the list of habits specific to the current user logged in

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: _buildHeader(),
      floatingActionButton: FloatingActionButton(
          //creates the button to add a habittile to the list and database
          backgroundColor: Colors.amber,
          child: const Text(
            '+',
            style: TextStyle(fontSize: 32),
          ),
          onPressed: () async {
            Habit habit = Habit(_habitController.text, 0, currentUserId);
            await db.saveHabit(habit);
            setState(() {
              _habits.add(habit);
            });
          }),
      body: ListView.builder(
          //creates a list of HabitTiles for each habit in the Habit table
          padding: const EdgeInsets.all(16),
          itemCount: _habits.length,
          itemBuilder: (context, index) {
            return HabitTile(habit: _habits[index]);
          }),
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
