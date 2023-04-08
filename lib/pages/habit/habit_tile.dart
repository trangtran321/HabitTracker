//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db_helper.dart';
//import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/services.dart/lists.dart';

class HabitTile extends StatefulWidget {
  final Habit habit;
  final onHabitChanged;
  final onDeleteHabit;

  const HabitTile(
      {Key? key, required this.habit, this.onHabitChanged, this.onDeleteHabit})
      : super(key: key);

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  final _habitTitleController = TextEditingController();
  final _habitDescriptionController = TextEditingController();
  bool _isDone = false;
  String _testHabit = '';
  String _habitDescription = '';
  int _dropDownValue = 1;

  void _showOverlay() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
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
                    controller: _habitTitleController,
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
                        //add insertion to database here!!
                        var db = new DatabaseHelper();
                        String _habit = _habitTitleController.text;
                        bool _doneToday = false;
                        //db.saveHabit(Habit(_habit, _doneToday));
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
          _habitTitleController
              .text, //allows the text being input by the user to be saved and used
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
            });
          },
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     //Creates the box for the habit
  //     height: 60,
  //     margin: const EdgeInsets.only(
  //       top: 8,
  //       bottom: 8,
  //     ),
  //     child: ListTile(
  //       onTap: () {
  //         //  changes the value of isDone from false to true or vice versa
  //         widget.onHabitChanged(widget.habit);
  //       },
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       tileColor: Colors.amber[300],
  //       leading: Icon(
  //         widget.habit.isDone ? Icons.check_box : Icons.check_box_outline_blank,
  //         color: Colors.grey[700],
  //       ),
  //       title: Text(
  //         //prints the habit text to the box followed by its streak
  //         '${widget.habit.habitText!}: ${widget.habit.habitCount}',
  //         style: TextStyle(
  //           fontSize: 18,
  //           color: Colors.black,
  //           decoration: widget.habit.isDone ? TextDecoration.lineThrough : null,
  //         ),
  //       ),
  //       trailing: Container(
  //         height: 35,
  //         width: 35,
  //         decoration: BoxDecoration(
  //             color: Colors.red[400], borderRadius: BorderRadius.circular(5)),
  //         child: IconButton(
  //           color: Colors.white,
  //           iconSize: 15,
  //           icon: const Icon(Icons.delete),
  //           onPressed: () {
  //             //print('Clicked on Delete item');
  //             widget.onDeleteHabit(widget.habit.id);
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
