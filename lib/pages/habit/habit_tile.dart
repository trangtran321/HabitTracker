import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/models/milestones.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
<<<<<<< Updated upstream
import '../../user_provider.dart';
=======
import '../../services.dart/habit_provider.dart';
import '../../services.dart/user_provider.dart';
import 'milestone_tile.dart';
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
  int _dropDownValue1 = 3;
  int _dropDownValue2 = 2;
  int _dropDownValue3 = 2;
=======
  String streakImage = 'images/fire.png';
>>>>>>> Stashed changes

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
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      right: 20,),
                    child: ElevatedButton(
                      onPressed:(){
                        Milestones milestone = Milestones(widget.habit.habitName, 0);
                        db.saveMilestone(milestone);
                        //MilestoneTile(milestone: milestone);
                       _getTotalMilestones(milestone, context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[300],
                        minimumSize: const Size(20, 20),
                        elevation: 10,
                      ),
                      child: const Text(
                        'Milestones',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // const Text("How Often Do You Want A Milestone?"),
                  // const SizedBox(height: 32),
                  // Row(
                  //   ///Creates a row of text boxes with padding
                  //   children: const [
                  //     Padding(
                  //       padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  //       child: Text("Milestone 1: Days"),
                  //     ),
                  //     Padding(
                  //       padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  //       child: Text("Milestone 2: Weeks"),
                  //     ),
                  //     Padding(
                  //       padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  //       child: Text("Milestone 3: Months"),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   //Creates a row of dropdown boxes to choose milestone times
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.fromLTRB(50, 0, 25, 0),
                  //       child: DropdownButton<int>(
                  //         key: UniqueKey(),
                  //         value: _dropDownValue1,
                  //         onChanged: (newValue) {
                  //           setState(() {
                  //             _dropDownValue1 = newValue ?? 3;
                  //           });
                  //         },
                  //         items: <int>[3, 5]
                  //             .map<DropdownMenuItem<int>>((int value) {
                  //           return DropdownMenuItem<int>(
                  //             key: UniqueKey(),
                  //             value: value,
                  //             child: Text(value.toString()),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.fromLTRB(75, 8, 25, 0),
                  //       child: DropdownButton<int>(
                  //         key: UniqueKey(),
                  //         value: _dropDownValue2,
                  //         onChanged: (newValue) {
                  //           setState(() {
                  //             _dropDownValue2 = newValue ?? 2;
                  //           });
                  //         },
                  //         items: <int>[2, 3]
                  //             .map<DropdownMenuItem<int>>((int value) {
                  //           return DropdownMenuItem<int>(
                  //             value: value,
                  //             child: Text(value.toString()),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.fromLTRB(75, 8, 25, 0),
                  //       child: DropdownButton<int>(
                  //         key: UniqueKey(),
                  //         value: _dropDownValue3,
                  //         onChanged: (newValue) {
                  //           setState(() {
                  //             _dropDownValue3 = newValue ?? 2;
                  //           });
                  //         },
                  //         items: <int>[2, 3, 6]
                  //             .map<DropdownMenuItem<int>>((int value) {
                  //           return DropdownMenuItem<int>(
                  //             value: value,
                  //             child: Text(value.toString()),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
<<<<<<< Updated upstream

                        ///changes the name/title of the habit
                        widget.habit.habitName = _habitTitleController.text;
=======
                        ///changes the name/title of the habit only if User has updated value
                        if (widget.habit.habitName !=
                            _habitTitleController.text) {
                          widget.habit.habitName = _habitTitleController.text;
                        }
>>>>>>> Stashed changes
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
  int _totalMilestones = 0;
  List<String> inputData = [];


  void _getTotalMilestones(currentMilestone, context){

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context){
    return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("How many milestones would you like to set?"),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 25, 0),
              child: DropdownButton<int>(
                key: UniqueKey(),
                value: _totalMilestones,
                  //onTap() try to make it so once it is tapped, the focus goes
                  //back to the parent?
                items: <int> [0, 1, 2, 3, 4, 5]
                  .map<DropdownMenuItem<int>>((int value){
                    return DropdownMenuItem(
                      //key: UniqueKey(),
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                onChanged: (value) =>
                  setState(() {
                    _totalMilestones = value ?? 0;
                  },), //setState end
                ),
            ),
            ElevatedButton(
              onPressed: () {
                var db = DatabaseHelper();
                  //if the total milestones inputed does not match what is in db,
                  //change db totalmilestones
                  if (currentMilestone.total != _totalMilestones){
                    currentMilestone.total = _totalMilestones;
                  }
                  db.updateMilestone(currentMilestone);
                  //updates each milestone for # of days p/ milestone
                  //_individualMilestoneEdit(context, currentMilestone);
                  //FocusScope.of(context).unfocus();
                },
                child: Text('Next'),
            ),
          ],)
    );
    });
  }// _editMilestones()

  void _individualMilestoneEdit(BuildContext context, Milestones currentMilestone){
  showDialog(
    context: context,
    builder: (BuildContext context){
      //Milestones currentMilestone = Milestones(widget.habit.habitName, 0);
    return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("What is the length of time that will determine the completion of this milestone? \n"
                        "Example: 3 days, 2 weeks, & 6 months or 0 days, 0 weeks, & 6 months"),
            const SizedBox(height: 50),
            ConstrainedBox(
              constraints:const BoxConstraints( maxHeight: 50, maxWidth: 20),
              child:
              ListView.builder(
                itemCount: _totalMilestones,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value){
                        inputData[index] = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'consecutive days of completion',
                      ),
                    ),
                    );
                }, //itemBuilder
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
                  Navigator.of(context).pop();
                  var db = DatabaseHelper();
                  //if the total milestones inputed does not match what is in db,
                  //change db totalmilestones
                  if (currentMilestone.ms1 != int.parse(inputData[0])){
                    currentMilestone.ms1 = int.parse(inputData[0]);
                  }
                  if (currentMilestone.ms2 != int.parse(inputData[1])){
                    currentMilestone.ms2 = int.parse(inputData[1]);
                  }
                  if (currentMilestone.ms3 != int.parse(inputData[2])){
                    currentMilestone.ms3 = int.parse(inputData[2]);
                  }
                  if (currentMilestone.ms4 != int.parse(inputData[3])){
                    currentMilestone.ms4 = int.parse(inputData[3]);
                  }
                  if (currentMilestone.ms5 != int.parse(inputData[4])){
                    currentMilestone.ms5 = int.parse(inputData[4]);
                  }
                  db.updateMilestone(currentMilestone);
                  FocusScope.of(context).unfocus();
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      );
    });
  }// _editMilestones()


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
