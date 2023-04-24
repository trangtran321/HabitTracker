import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/models/milestones.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services.dart/habit_provider.dart';
import '../../services.dart/user_provider.dart';
import 'milestone_tile.dart';

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

  var db = new DatabaseHelper();

  void _showOverlay() {
      ChangeNotifierProvider(
        create: (context) => HabitProvider());
      Milestones milestone = Milestones(widget.habit.habitName, 0);
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
                mainAxisSize: MainAxisSize.max,
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
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      right: 20,),
                    child: ElevatedButton(
                      onPressed:(){
                        db.saveMilestone(milestone);
                        //MilestoneTile(milestone: milestone);
                       //_getTotalMilestones(milestone, context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[300],
                        minimumSize: const Size(20, 20),
                        elevation: 10,
                      ),
                      child: const MilestoneOverlay(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  Color.fromARGB(255, 255, 174, 60)),
                          minimumSize:
                              MaterialStateProperty.all(Size(100, 30))),
                      onPressed: () {
                        //insertion to database here!!
                        var db = DatabaseHelper();
                        ///changes the name/title of the habit only if User has updated value
                        if (widget.habit.habitName != _habitTitleController.text){
                          widget.habit.habitName = _habitTitleController.text;
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
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
      height: 100,
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
