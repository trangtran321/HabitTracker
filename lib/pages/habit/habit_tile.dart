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
  int _dropDownValue1 = 3;
  int _dropDownValue2 = 2;
  int _dropDownValue3 = 2;

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
                    controller:
                        _habitTitleController, //allows use of user text input
                    decoration: const InputDecoration(
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
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsetsDirectional.only(bottom: 100),
                      labelText: 'Describe Your Habit',
                    ),
                  ),
                  const Text("How Often Do You Want A Milestone?"),
                  const SizedBox(height: 32),
                  Row(
                    ///Creates a row of text boxes with padding
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text("Milestone 1: Days"),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text("Milestone 2: Weeks"),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text("Milestone 3: Months"),
                      ),
                    ],
                  ),
                  Row(
                    //Creates a row of dropdown boxes to choose milestone times
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 25, 0),
                        child: DropdownButton<int>(
                          key: UniqueKey(),
                          value: _dropDownValue1,
                          onChanged: (newValue) {
                            setState(() {
                              _dropDownValue1 = newValue ?? 3;
                            });
                          },
                          items: <int>[3, 5]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              key: UniqueKey(),
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(75, 8, 25, 0),
                        child: DropdownButton<int>(
                          key: UniqueKey(),
                          value: _dropDownValue2,
                          onChanged: (newValue) {
                            setState(() {
                              _dropDownValue2 = newValue ?? 2;
                            });
                          },
                          items: <int>[2, 3]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(75, 8, 25, 0),
                        child: DropdownButton<int>(
                          key: UniqueKey(),
                          value: _dropDownValue3,
                          onChanged: (newValue) {
                            setState(() {
                              _dropDownValue3 = newValue ?? 2;
                            });
                          },
                          items: <int>[2, 3, 6]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  Colors.blueAccent),
                          minimumSize:
                              MaterialStateProperty.all(Size(100, 30))),
                      onPressed: () {
                        //insertion to database here!!
                        var db = DatabaseHelper();

                        ///changes the name/title of the habit
                        widget.habit.habitName = _habitTitleController.text;
                        //resets streak to 0 since you are changing the habit
                        widget.habit.streakCount = 0;
                        //updates habit in the habit table with the new name and resets the streakCount
                        db.updateHabit(widget.habit);
                        // clears the text field for entering a habit name
                        _habitTitleController.clear();
                      },
                      child: const Text(
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
        contentPadding: const EdgeInsets.symmetric(
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
        subtitle: const Text('Tap to Edit'),
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
