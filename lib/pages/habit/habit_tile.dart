//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../user_provider.dart';

class HabitTile extends StatefulWidget {
  final Habit habit;
  const HabitTile({Key? key, required this.habit}) : super(key: key);

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  //sets initial states for fields in the HabitTile
  final _habitTitleController = TextEditingController();
  final _habitDescriptionController = TextEditingController();
  bool _isDone = false;
  String _testHabit = '';
  String _habitDescription = '';
  int _dropDownValue = 1;

  var db = new DatabaseHelper();

  void _showOverlay() {
    //creates the overlay that comes up when a habit tile is tapped
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          //get this.currentUser ID number to input into newly created habit
          UserProvider userProvider = Provider.of<UserProvider>(context);
          User? currentUser = userProvider.currentUser;
          int currentUserId =
              currentUser?.id ?? 0; //defaults to zero, if user is not logged in

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _testHabit = value;
                      });
                    },
                    controller: _habitTitleController, //saves user text input
                    decoration: InputDecoration(
                      labelText: 'Enter Habit',
                    ),
                  ),
                  TextField(
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        _habitDescription = value;
                      });
                    },
                    controller: _habitDescriptionController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsetsDirectional.only(bottom: 100),
                      labelText: 'Describe Your Habit',
                    ),
                  ),
                  Text("How Often Do You Want A Milestone?"),
                  SizedBox(height: 32),
                  DropdownButton<int>(
                    key: UniqueKey(),
                    value: _dropDownValue,
                    onChanged: (newValue) {
                      setState(() {
                        _dropDownValue = newValue ?? 1;
                      });
                    },
                    items:
                        <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.blueAccent),
                          minimumSize:
                              MaterialStateProperty.all(Size(100, 30))),
                      onPressed: () {
                        //insertion to database here!!
                        var db = new DatabaseHelper();
                        //Habit habit =
                        //Habit(_habitTitleController.text, 0, currentUserId);
                        widget.habit.habitName = _habitTitleController.text;

                        ///changes the name/title of the habit
                        widget.habit.streakCount =
                            0; //resets streak to 0 since you are changing the habit
                        db.updateHabit(widget
                            .habit); //updates habit in the habit table with the new name and resets the streakCount
                        _habitTitleController
                            .clear(); // clears the text field for entering a habit name
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //Creates the box for the individual Habit
    return Container(
      height: 150,
      margin: const EdgeInsets.only(
          top: 8, bottom: 8), //adds padding to the top and bottom
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical:
                35), //adds padding horizontally and vertically to align things inside the tile
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(35)), //rounds the border of the tile
        tileColor: Colors.amber[300],
        title: Text(
          widget.habit
              .habitName, //allows the text being input by the user to be saved and used
        ),
        subtitle: Text('Tap to Edit'),
        onTap:
            _showOverlay, //opens the overlay box to input the new habit tite, description, etc..
        trailing: Checkbox(
          /// creates the checkbox on the right side of the tile and flips whatever state it is in.
          value: _isDone,
          onChanged: (value) {
            setState(() {
              _isDone = value!;
              if (_isDone == true) {
                widget.habit.streakCount++;
                db.updateHabit(widget.habit);
              }
              if (_isDone == false) {
                widget.habit.streakCount--;
                db.updateHabit(widget.habit);
              }
              // if ((isMidnight(DateTime.now())) && (_isDone == true)) {
              //   widget.habit.streakCount++;
              //   db.updateHabit(widget.habit);
              // }
              // if (isMidnight(DateTime.now()) && (_isDone == false)) {
              //   widget.habit.streakCount = 0;
              //   db.updateHabit(widget.habit);
              // }
            });
          },
        ),
      ),
    );
  }
}

bool isMidnight(DateTime dateTime) {
  return dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0;
}
