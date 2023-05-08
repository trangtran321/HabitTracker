import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/user.dart';
import '../../services.dart/habit_provider.dart';
import '../../services.dart/user_provider.dart';

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
  String streakImage = 'images/fire.png';

  var db = DatabaseHelper();

  void _showOverlay() {
    ChangeNotifierProvider(create: (context) => HabitProvider());

    //creates the overlay that comes up when a habit tile is tapped
    showModalBottomSheet(
        backgroundColor: Colors.grey[800],
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
                    maxLength: 20,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        labelText: 'Enter Habit',
                        labelStyle: TextStyle(color: Colors.white54)),
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
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsetsDirectional.only(bottom: 100),
                        labelText: 'Describe Your Habit',
                        labelStyle: TextStyle(color: Colors.white54)),
                  ),
                  const Text(
                    "How Often Do You Want A Milestone?",
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    ///Creates a row of text boxes with padding
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                          "Milestone 1: Days",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                          "Milestone 2: Weeks",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                          "Milestone 3: Months",
                          style: TextStyle(color: Colors.white54),
                        ),
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
                              child: Text(
                                value.toString(),
                                style: const TextStyle(color: Colors.white54),
                              ),
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
                              child: Text(
                                value.toString(),
                                style: const TextStyle(color: Colors.white54),
                              ),
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
                              child: Text(
                                value.toString(),
                                style: const TextStyle(color: Colors.white54),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(255, 255, 174, 60)),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(100, 30))),
                            onPressed: () {
                              //insertion to database here!!
                              var db = DatabaseHelper();

                              ///changes the name/title of the habit only if User has updated value
                              if (widget.habit.habitName !=
                                  _habitTitleController.text) {
                                widget.habit.habitName =
                                    _habitTitleController.text;
                              }
                              //resets streak to 0 since you are changing the habit
                              widget.habit.streakCount = 0;
                              //updates habit in the habit table with the new name and resets the streakCount
                              db.updateHabit(widget.habit);
                              // clears the text field for entering a habit name
                              _habitTitleController.clear();
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                        ),
                      ),
                      ////Deletes a habit from the list and database
                      Padding(
                        padding: const EdgeInsets.fromLTRB(186, 15, 8, 8),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(255, 255, 174, 60)),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(100, 30))),
                            onPressed: () {
                              //insertion to database here!!
                              var db = DatabaseHelper();
                              db.deleteHabit(widget.habit.id);
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                        ),
                      ),
                    ],
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
            vertical: 35), //adds padding horizontally and vertically to align things inside the tile
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(35)), //rounds the border of the tile
        tileColor: Colors.grey[850],
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                //allows the text being input by the user to be saved and used
                widget.habit.habitName,
                style: const TextStyle(color: Colors.white54, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 8, 15),
              child: Center(
                child: Image.asset(
                  streakImage,
                  height: 50,
                ),
              ),
            ),
            Text(
              widget.habit.streakCount.toString(),
              style: const TextStyle(color: Colors.amberAccent, fontSize: 18),
            ),
          ],
        ),
        subtitle: const Text(
          'Tap to Edit',
          style: TextStyle(color: Colors.white30),
        ),
        onTap:
            _showOverlay, //opens the overlay box to input the new habit tite, description, etc..
        trailing: Checkbox(
          /// creates the checkbox on the right side of the tile and flips whatever state it is in.
          fillColor: const MaterialStatePropertyAll<Color>(Colors.amberAccent),
          value: _isDone,
          onChanged: (value) {
             setState(() {
            //   _isDone = value!;
            //   if (_isDone == true) {
            //     widget.habit.doneToday = 1;
            //     widget.habit.streakCount++;
            //     db.updateHabit(widget.habit);
            //   }
            //   if (_isDone == false) {
            //     widget.habit.doneToday = 0;
            //     widget.habit.streakCount--;
            //     db.updateHabit(widget.habit);
            //   }
              // if ((isMidnight(DateTime.now())) && (_isDone == true)) {
              //  widget.habit.doneToday = 0;
              //   widget.habit.streakCount++;
              //   db.updateHabit(widget.habit);
              // }
              // if (isMidnight(DateTime.now()) && (_isDone == false)) {
              //   widget.habit.streakCount = 0;
              //   db.updateHabit(widget.habit);
              // }
            });
          },
          checkColor: Colors.black,
        ),
      ),
    );
  }
}

bool isMidnight(DateTime dateTime) {
  return dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0;
}
