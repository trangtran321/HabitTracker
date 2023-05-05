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
  State<HabitTile> createState() => _HabitTileState();}

class _HabitTileState extends State<HabitTile> {
  //sets initial states for fields in the HabitTile
  final _habitTitleController = TextEditingController();
  final _ms1Edit = TextEditingController();
  final _ms2Edit = TextEditingController();
  final _ms3Edit = TextEditingController();
  GlobalKey globalKey = GlobalKey();

  var db = DatabaseHelper();

  bool _isDone = false;
  String _testHabit = '';
  int _totalMilestones = 0;
  int _currentIndex = 0;
  int ms1 = 0;
  int ms2 = 0;
  int ms3 = 0;
  late Milestones milestone;

  void updateMilestone (Milestones milestone) async {
    if (milestone.total != _totalMilestones){
      milestone.total = _totalMilestones;
    }
    if (milestone.ms1 != ms1){
      milestone.ms1 = ms1;
    }
    if (milestone.ms2 != ms2){
      milestone.ms2 = ms2;
    }
    if (milestone.ms3 != ms3){
      milestone.ms3 = ms3;
    }
    await db.updateMilestone(milestone);
  }

  @override
  Widget build(BuildContext context){
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
          width: 400,
          height: 200,
          alignment: Alignment.center,
          color: Colors.grey[800],
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
                    maxLength: 20,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Enter Habit',
                      labelStyle: TextStyle(color: Colors.white54)
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
                        setState(() {
                          _currentIndex = 2;});//go to index2
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
                            MaterialStateProperty.all(const Size(100, 30))), //button style
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

                            Milestones milestone = Milestones(widget.habit.habitName, _totalMilestones, ms1, ms2, ms3);
                            updateMilestone(milestone);
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
                Expanded(child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 201, 124, 9)),
                        minimumSize: MaterialStateProperty.all(const Size(50, 30))
                        ),
                      child: const Text(
                        "0",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,)),
                      onPressed: () {
                        setState(() {
                          _totalMilestones = 0;
                          _currentIndex = 1;});
                      }),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 201, 124, 9)),
                        minimumSize: MaterialStateProperty.all(const Size(50, 30))
                        ),
                      child: const Text(
                        "1",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,)),
                      onPressed: () {
                        setState(() {
                          _totalMilestones = 1;
                          _currentIndex = 3;
                         });
                      }),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 201, 124, 9)),
                        minimumSize: MaterialStateProperty.all(const Size(50, 30))
                        ),
                      child: const Text(
                        "2",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,)),
                      onPressed: () {
                        setState(() {
                          _totalMilestones = 2;
                          _currentIndex = 4;});
                      }),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 201, 124, 9)),
                        minimumSize: MaterialStateProperty.all(const Size(50, 30))
                        ),
                      child: const Text(
                        "3",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,)),
                      onPressed: () {
                        setState(() {
                          _totalMilestones = 3;
                          _currentIndex = 5;});
                      }),
                  ],
                )),
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
                const Text("How many consecutive days of completion would represent \n an accomplishment to you?"),
                Expanded(child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value){
                    setState((){
                      ms1 = int.parse(value);});
                  },
                  controller: _ms1Edit,
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
                      onPressed: () async{
                        //return to main habit tile edit
                        setState((){
                          try{
                          ms1 = int.parse(_ms1Edit.text);
                          print("-----------------\n MS1: " + ms1.toString() + "\n----------------");
                          print("totalMilestones: " + _totalMilestones.toString() + "\n----------------------");
                          _currentIndex = 1;}
                          catch(e){
                            _currentIndex = 1;
                            ms1 = 0;
                            throw new FormatException("Invalid number");
                          }});

                        milestone = Milestones(widget.habit.habitName, _totalMilestones, ms1, ms2, ms3);
                        await db.saveMilestone(milestone);
                        print("\n\nMilestone Name: " + milestone.habitName + "\n");
                        },),
                  )),
        ]),)), //end of index3 - 1 milestone edit
      Center(//index 4 - 2 milestones
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 200,
            height: 200,
            color: Colors.amber[200],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("How many consecutive days of completion would represent \n a milestone to you?"),
                const Text("Each milestone can be represented by different lengths of time. It's up to you!"),
                Expanded(child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value){
                    setState((){
                      ms1 = int.parse(value);});
                  },
                  controller: _ms1Edit,
                  decoration: const InputDecoration(
                    labelText: 'Enter Days for First Milestone',
                  ),
                  ),),
                  Expanded(child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value){
                    setState((){
                      ms2 = int.parse(value);});
                  },
                  controller: _ms2Edit,
                  decoration: const InputDecoration(
                    labelText: 'Enter Days for Second Milestone',
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
                      onPressed: () async{
                        //return to main habit tile edit
                        setState((){
                          try{
                          ms1 = int.parse(_ms1Edit.text);
                          ms2 = int.parse(_ms2Edit.text);
                          print("-----------------\n MS1: " + ms1.toString() + "\n----------------");
                          print("totalMilestones: " + _totalMilestones.toString() + "\n----------------------");
                          _currentIndex = 1;}
                          catch(e){
                            _currentIndex = 1;
                            ms1 = 0;
                            ms2 = 0;
                            throw new FormatException("Invalid number");
                          }});

                        milestone = Milestones(widget.habit.habitName, _totalMilestones, ms1, ms2, ms3);
                        await db.saveMilestone(milestone);
                        print("\n\nMilestone Name: " + milestone.habitName + "\n");
                        },),
                  )),
        ]),)), //end of index4 -- 2 milestones
      Center(//index 4 - 2 milestones
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 200,
            height: 200,
            color: Colors.amber[200],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("How many consecutive days of completion would represent \n a milestone to you?"),
                const Text("Each milestone can be represented by different lengths of time. It's up to you!"),
                Expanded(child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value){
                    setState((){
                      ms1 = int.parse(value);});
                  },
                  controller: _ms1Edit,
                  decoration: const InputDecoration(
                    labelText: 'Enter Days for First Milestone',
                  ),
                  ),),
                  Expanded(child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value){
                    setState((){
                      ms2 = int.parse(value);});
                  },
                  controller: _ms2Edit,
                  decoration: const InputDecoration(
                    labelText: 'Enter Days for Second Milestone',
                  ),
                  ),),
                   Expanded(child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value){
                    setState((){
                      ms3 = int.parse(value);});
                  },
                  controller: _ms3Edit,
                  decoration: const InputDecoration(
                    labelText: 'Enter Days for Third Milestone',
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
                      onPressed: () async{
                        //return to main habit tile edit
                        setState((){
                          try{
                          ms1 = int.parse(_ms1Edit.text);
                          ms2 = int.parse(_ms2Edit.text);
                          ms3 = int.parse(_ms3Edit.text);
                          print("-----------------\n MS1: " + ms1.toString() + "\n----------------");
                          print("totalMilestones: " + _totalMilestones.toString() + "\n----------------------");
                          _currentIndex = 1;}
                          catch(e){
                            _currentIndex = 1;
                            ms1 = 0;
                            ms2 = 0;
                            ms3 = 0;
                            throw new FormatException("Invalid number");
                          }});

                        milestone = Milestones(widget.habit.habitName, _totalMilestones, ms1, ms2, ms3);
                        await db.saveMilestone(milestone);
                        print("\n\nMilestone Name: " + milestone.habitName + "\n");
                        },),
                  )),
        ]),)), //end of index5 -- 3 milestones
      ] //indexedList children
    );
  }

}//end habitTileState

