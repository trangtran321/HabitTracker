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
    return SingleChildScrollView(child:IndexedStack(
      alignment: Alignment.center,
      index: _currentIndex,
      children:<Widget>[
        Container( //index 0
            height: 150,
            margin: const EdgeInsets.only(
              top: 8,
              bottom: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35)),
              tileColor: Colors.grey[850],
              title: Row(
                children: [
                  Padding(padding: const EdgeInsets.all(8.0),
                    child: Text(
                    //allows the text being input by the user to be saved and used
                    widget.habit.habitName,
                    style: const TextStyle(color: Colors.white54, fontSize: 18),
                    ),
                  ),
            //    Padding(
            //      padding: const EdgeInsets.fromLTRB(15, 15, 8, 15),
            //      child: Center(
            //        child: Image.asset(
            //          streakImage,
            //          height: 50,
            //        ),
            //       ),
            //    ),
                  Text(
                    widget.habit.streakCount.toString(),
                    style: const TextStyle(color: Colors.amberAccent, fontSize: 18),
                  ),
                ],
              ),
              subtitle: const Text(
                'Tap to Edit',
                style: TextStyle(color: Colors.white30)),
              onTap: () => {
                setState((){
                  _currentIndex = 1;
                })
              },
              trailing: Checkbox(
                fillColor: const MaterialStatePropertyAll<Color>(Colors.amberAccent),
                value: _isDone,
                checkColor: Colors.black,
                onChanged: (value){
                  setState((){
                    _isDone = value!;
                    if (_isDone == true){
                      widget.habit.doneToday = 1;
                      widget.habit.streakCount++;
                      db.updateHabit(widget.habit);
                    }
                    if (_isDone == false){
                      widget.habit.doneToday = 1;
                      widget.habit.streakCount--;
                      db.updateHabit(widget.habit);
                    }
                  });
                },//end onChanged in Checkbox
              ),//end Checkbox for streaks
            ),//end ListTile - the tile that appears on homePage
          ),//end container that holds listTile
        Container( //index 1: edit habit name & milestones
          padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
          width: 420,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [BoxShadow(
              color: Color(0xFF000000),
              offset: Offset.zero,
              blurRadius: 0.0,
              spreadRadius: 0.0),],
            color: Colors.grey[800]
            ),
          alignment: Alignment.center,
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
                    style: const TextStyle(color: Colors.white54),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      labelText: 'Enter Habit',
                      labelStyle: TextStyle(color: Colors.white54)
                    ),
                )),
                Expanded( child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 255, 174, 60)),
                              minimumSize:
                                MaterialStateProperty.all(const Size(100, 30))), //button style
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
                              //on submission, this takes you back to original habit tile - not overlay
                              _currentIndex = 0;

                              Milestones milestone = Milestones(widget.habit.habitName, _totalMilestones, ms1, ms2, ms3);
                              updateMilestone(milestone);
                              FocusScope.of(context).unfocus();
                            },
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                ),),),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 255, 174, 60)),
                        minimumSize: MaterialStateProperty.all(
                          const Size(100, 30)),
                        ),
                      child: const Text(
                        'Edit Milestones',
                        style: TextStyle(
                          color: Color.fromARGB(255,0, 0, 0),
                      ),),
                      onPressed: (){
                        setState(() {
                          _currentIndex = 2;});//go to index2
                      },)
                  ),),
                ////Deletes a habit from the list and database
                  Expanded(
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
                  ),],),),
              ],)),
        Center(  //this is container to edit milestone totals. Index = 2
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 400,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [BoxShadow(
                color: Color(0xFF000000),
                offset: Offset.zero,
                blurRadius: 0.0,
                spreadRadius: 0.0),],
              color: Colors.grey[800]
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                        'Choose how many milestones you would like',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white54,
                ),),),),
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
                          fontSize: 15,)),
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
                          fontSize: 15,)),
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
                          fontSize: 15,)),
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
                          fontSize: 15,)),
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
            width: 400,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [BoxShadow(
                color: Color(0xFF000000),
                offset: Offset.zero,
                blurRadius: 0.0,
                spreadRadius: 0.0),],
              color: Colors.grey[800]
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                  "How many consecutive days of completion would represent an accomplishment to you?",
                  style: TextStyle(color: Colors.white54)),),
                Expanded(child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
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
                    contentPadding: EdgeInsets.all(8.0),
                    labelText: 'Enter Days',
                    labelStyle: TextStyle(color: Colors.white54),
                  ),
                  ),),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Align(
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
                          color: Color.fromARGB(255, 0, 0, 0),
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
                  )),),
        ]),)), //end of index3 - 1 milestone edit
      Center(//index 4 - 2 milestones
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 400,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [BoxShadow(
                color: Color(0xFF000000),
                offset: Offset.zero,
                blurRadius: 0.0,
                spreadRadius: 0.0),],
              color: Colors.grey[800]
              ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                  "How many consecutive days of completion would represent a milestone to you? Each milestone can be represented by different lengths of time. It's up to you!",
                  style: TextStyle(color: Colors.white54)),),
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
                    contentPadding: EdgeInsets.all(8.0),
                    labelText: 'Enter Days for First Milestone',
                    labelStyle: TextStyle(color: Colors.white54)
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
                    contentPadding: EdgeInsets.all(8.0),
                    labelText: 'Enter Days for Second Milestone',
                    labelStyle: TextStyle(color: Colors.white54)
                  ),
                  ),),
                  Expanded(child:Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                          const MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 255, 174, 60)),
                        minimumSize:
                          MaterialStateProperty.all(const Size(100, 30))),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color:Color.fromARGB(255, 0, 0, 0),
                          fontSize: 15,)),
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
            width: 400,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [BoxShadow(
                color: Color(0xFF000000),
                offset: Offset.zero,
                blurRadius: 0.0,
                spreadRadius: 0.0),],
              color: Colors.grey[800]
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Text(
                  "How many consecutive days of completion would represent a milestone to you? Each milestone can be represented by different lengths of time. It's up to you!",
                  style: TextStyle(color: Colors.white30),
                  ),),
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
                    contentPadding: EdgeInsets.all(8.0),
                    labelText: 'Enter Days for First Milestone',
                    labelStyle: TextStyle(color: Colors.white30),
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
                    contentPadding: EdgeInsets.all(8.0),
                    labelText: 'Enter Days for Second Milestone',
                    labelStyle: TextStyle(color: Colors.white30)
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
                    contentPadding: EdgeInsets.all(8.0),
                    labelText: 'Enter Days for Third Milestone',
                    labelStyle: TextStyle(color: Colors.white30)
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
                          color:  Colors.white30,
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
    ),);
  }

}//end habitTileState

