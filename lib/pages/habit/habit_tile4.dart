import 'package:flutter/material.dart';
 import 'package:habit_tracker/database/db_helper.dart';
 import 'package:habit_tracker/models/habit.dart';
 import 'package:habit_tracker/models/milestones.dart';
 import 'package:provider/provider.dart';
 import '../../models/user.dart';
 import '../../services.dart/user_provider.dart';
 import 'milestone_tile.dart';

class HabitTile extends StatefulWidget {
  final Habit habit;
  const HabitTile({Key? key, required this.habit}) : super(key: key);
  @override
  State<HabitTile> createState() => _HabitTileState();}

class _HabitTileState extends State<HabitTile> {
  //sets initial states for fields in the HabitTile
  final _habitTitleController = TextEditingController();
  final _habitDescriptionController = TextEditingController();
  final  FocusNode _focusNode = FocusNode();
  GlobalKey globalKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();

  var db = DatabaseHelper();

  bool _isDone = false;
  String _testHabit = '';
  String _habitDescription = '';
  int _totalMilestones = 0;
  int _currentIndex = 0;

  Widget build(BuildContext context){
    return
      IndexedStack(
      alignment: Alignment.center,
      index: _currentIndex,
      children:<Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 100,
            margin: const EdgeInsets.only(
            top: 8,
            bottom: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 35),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35)),
              tileColor: Colors.amber[300],
              title: Text(
                widget.habit.habitName),
              subtitle: const Text('Tap to Edit'),
              onTap: () => {
                setState((){
                  _currentIndex = 1;
                })
              },
              trailing: Checkbox(
                value: _isDone,
                onChanged: (value){
                  setState((){
                    _isDone = value!;
                    if (_isDone == true){
                      widget.habit.streakCount++;
                      db.updateHabit(widget.habit);
                    }
                    if (_isDone == false){
                      widget.habit.streakCount--;
                      db.updateHabit(widget.habit);
                    }
                  });
                },//end onChanged in Checkbox
              ),//end Checkbox for streaks
            ),//end ListTile - the tile that appears on homePage
          ),//end container that holds listTile
        ),//end padding
        Positioned.fill(
                child: Container(
                  padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(

                    mainAxisSize: MainAxisSize.min,
                    children: [ //Listview builder change 
                      TextField(
                        onChanged: (value){
                          setState((){
                            _testHabit = value;
                          });
                        },
                        controller: _habitTitleController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Habit',
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                          right: 20,),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[250],
                            minimumSize: const Size(20, 20),
                            elevation: 10,
                          ),
                          child: Text(
                            'Edit Milestones',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                            ),),
                          onPressed: (){
                            setState((){
                              _currentIndex = 1;
                            });
                            //go to index1
                          },)
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                  Color.fromARGB(255, 201, 124, 0)),
                              minimumSize:
                                  MaterialStateProperty.all(Size(100, 30))), //button style
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
                          ),),
                      ],)),
        ),//Positioned
      ] //indexedList children

    );
  }

}//end habitTileState

