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
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  //sets initial states for fields in the HabitTile
  final _habitTitleController = TextEditingController();
  final _habitDescriptionController = TextEditingController();
  final  FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  GlobalKey globalKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();

  bool _isDone = false;
  String _testHabit = '';
  String _habitDescription = '';
  int _totalMilestones = 0;
  int _currentIndex = 0;

  var db = new DatabaseHelper();

  @override
  void initState() {
    super.initState();
    OverlayState? overlayState = Overlay.of(context);
    WidgetsBinding.instance!.addPostFrameCallback((_){
      globalKey;
    });

    _focusNode.addListener((){
      if(_focusNode.hasFocus){
        _overlayEntry = _showOverlay();
        overlayState!.insert(_overlayEntry!);
      }
      else{
        _overlayEntry!.remove();
      }
    });
  } //end initState()

  OverlayEntry _showOverlay(){
    RenderBox renderBox = context.findRenderObject as RenderBox;
    var size = renderBox.size;

    UserProvider userProvider = Provider.of<UserProvider>(context);
    User? currentUser = userProvider.currentUser;
    int currentUserID = currentUser?.id ?? 0;

    Milestones milestone = Milestones(widget.habit.habitName, 0);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        height: size.aspectRatio,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 50.0),
          child: IndexedStack(
            alignment: Alignment.center,
            index: _currentIndex,
            children: [
              Positioned.fill(
                child: Container(
                  padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          ),)//textButton & align end
                    ],)),),
              Positioned(
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 150,
                      color: Colors.amber[250],
                      child: const Text(
                        'Select How Many Milestones You Would Like',
                        style: TextStyle(color: Color.fromARGB(29, 44, 43, 43)),),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            //if user selects '0', take it back to habitTile edit screen
                            setState((){
                              _currentIndex = 0;
                            });
                          },
                          child: const Text(
                            '0',
                            style: TextStyle(color: Color.fromARGB(29, 44, 43, 43), fontSize: 15),
                          ),
                          ),
                      ],)],
              ),), //Start making containers for milestones here
              //total milestones will have one text box & 5 boxes that, when clicked link to
              //separate stack pages
            ],), //indexed stack children
          ),
        )
    );
    //create indexed stack
    //index 0 = habit tile
        //you can change habit name
        //change description
        //button to take you to index 1
    //index 1 = milestone total
        //buttons to take you to 2-6 or back to 0
    //index 2 = ms1
    //index 3 = ms2
    //index 4 = ms3
    //index 5 = ms4
    //index 6 = ms5
    //buttons:
        //milestone total --> 1
        //no milestones --> 0
        //1 milestone --> 2
        //2 milestones -->3
        //3 milestones --> 4
        //4 milestones -->5
        //5 milestones --> 6
        //submit (on both habit tile & each index 2-5) --> navigator.pop
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

