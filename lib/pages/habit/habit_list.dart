import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:habit_tracker/models/milestones.dart';
import 'package:habit_tracker/pages/habit/habit_tile3.dart';
import 'package:provider/provider.dart';
import '../../models/habit.dart';
import '../../models/user.dart';
import '../../services.dart/user_provider.dart';


class HabitList extends StatefulWidget {
  const HabitList({super.key});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  var db = new DatabaseHelper();
  final _habitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      //get this.currentUser ID number to input into newly created habit
      UserProvider userProvider = Provider.of<UserProvider>(context);
      User? currentUser = userProvider.currentUser;
      int currentUserId = currentUser?.id ?? 0; //defaults to zero, if user is not logged in

    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: _buildHeader(),
      body: Align(
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
                Habit habit = new Habit(_habitController.text, 0, currentUserId);
                print("Current UserName::" + currentUserId.toString());
                db.saveHabit(habit);
                _habitController.clear();
                //HabitTile();
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
