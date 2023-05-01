import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _individualMilestoneEdit = TextEditingController();
  final  FocusNode _focusNode = FocusNode();
  GlobalKey globalKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();

  var db = DatabaseHelper();

  bool _isDone = false;
  String _testHabit = '';
  String _habitDescription = '';
  int _totalMilestones = 0;
  int _currentIndex = 0;
  int ms1 = 0;
  int ms2 = 0;
  int ms3 = 0;

  Widget build(BuildContext context){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    User? currentUser = userProvider.currentUser;
    int currentUserID = currentUser?.id ?? 0;

     Milestones milestone = Milestones(widget.habit.habitName, 0);

    return IndexedStack(
      alignment: Alignment.center,
      index: _currentIndex,
      children:<Widget>[
        Padding( //index 0
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
        Container(
          padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
          width: 200,
          height: 200,
          color: Colors.blueGrey,
          margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [ //Listview builder change
                Expanded(
                  child: TextField(
                    onChanged: (value){
                      setState((){ _testHabit = value;});
                    },
                    controller: _habitTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Habit',
                    ),
                )),
                Expanded(
                  child: Container(
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
                          color: Colors.grey[600],
                      ),),
                      onPressed: (){
                        setState((){ _currentIndex = 2;});//go to index2
                      },)
                  )),
                Expanded(
                    child: Align(
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
                            //on submission, this takes you back to original habit tile - not overlay
                            _currentIndex = 0;
                            FocusScope.of(context).unfocus();
                            },
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                ),)),
              ],)),
        Center(  //this is container to edit milestone totals. Index = 2
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 200,
            height: 200,
            color: Colors.amber[200],
            child: Column(
              children: [
                Expanded(child: Text(
                        'Choose how many milestones you would like',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                      ),),),
                Expanded(child: DropdownButtonFormField(
                  items: <int>[0, 1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      key: UniqueKey(),
                      value: value,
                      child: Text(value.toString()),
                    );
                    }).toList(), //end items dropdown builder
                  onChanged:(int? newValue) =>
                    setState(() {
                      _totalMilestones = newValue ?? 0;
                    },), //onChanged end
                )), //DropdownButton FormField
                Expanded(child: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    style: ButtonStyle( backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                  Color.fromARGB(255, 201, 124, 0)),
                              minimumSize:
                                  MaterialStateProperty.all(const Size(100, 30))),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20,)),
                    onPressed: () {
                      //insertion to database here
                      var db = DatabaseHelper();
                      milestone.total = _totalMilestones;
                      db.updateMilestone(milestone);

                      //if user does not want any milestones, take them back to edit habit tile
                      if (_totalMilestones == 0){
                        setState(() {  _currentIndex = 1;});
                      }

                      //if user wants one milestone, take them to edit length tile
                     else if (_totalMilestones == 1){
                        setState((){_currentIndex == 3;});
                      }

                      //if user wants two milestones, take them to edit length of each milestone
                      else if (_totalMilestones == 2){
                        setState((){_currentIndex == 4;});
                      }

                      //if user wants three milestones, take them to edit length of each milestone
                      else if (_totalMilestones == 3){
                        setState((){_currentIndex == 5;});
                      }
                    },),)),
              ],//children of Column index 2
            ),//Column
          ),//Container
        ),//Center // index 2 - how many milestones page
        Center(//index 3 - 1 milestone
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 200,
            height: 200,
            color: Colors.amber[200],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("How many consecutive days of completion would represent \n an accomplisment to you?"),
                Expanded(child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value){
                    setState((){ ms1 = value as int;});
                  },
                  controller: _individualMilestoneEdit,
                  decoration: const InputDecoration(
                    labelText: 'Enter Days',
                  ),
                  ),),
                  Expanded(child:Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                          const MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 201, 124, 0)),
                        minimumSize:
                          MaterialStateProperty.all(const Size(100, 30))),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,)),
                      onPressed: () {
                        //insertion to database here
                        var db = DatabaseHelper();
                        ms1 = _individualMilestoneEdit as int;
                        milestone.ms1 = ms1;
                        db.updateMilestone(milestone);
                        //return to main habit tile edit
                        setState((){_currentIndex = 1;});
                        },),
                  )),
        ]),)) //end of index3 - 1 milestone edit
      ] //indexedList children
    );
  }

}//end habitTileState

