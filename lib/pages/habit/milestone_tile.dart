import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:provider/provider.dart';
import '../../models/progress.dart';
import '../../models/user.dart';
import '../../services.dart/habit_provider.dart';
import '../../services.dart/user_provider.dart';

class MilestoneTile extends StatefulWidget {
  final Progress milestone;
  const MilestoneTile({Key? key, required this.milestone}) : super(key: key);

  @override
  State<MilestoneTile> createState() => _MilestoneTileState();
}

class _MilestoneTileState extends State<MilestoneTile> {
//////////////////////////////////////////////////////////////
///This is a test to see if milestones should be its own popup button
  int _totalMilestones = 0;


  void _getTotalMilestones(){
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context){
        //gets user info
        HabitProvider habitProvider = Provider.of<HabitProvider>(context);
        Habit? currentHabit = habitProvider.currentHabit;
        int currentHabitId = currentHabit?.id ?? 0;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
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
                onChanged: (newValue){
                  setState(() {
                    _totalMilestones = newValue ?? 0;
                  });
                },
                items: <int> [0, 1, 2, 3, 4, 5]
                  .map<DropdownMenuItem<int>>((int value){
                    return DropdownMenuItem(
                      key: UniqueKey(),
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                onTap: () {
                  var db = DatabaseHelper();

                  if (widget.milestone.totalMilestones !=
                  FocusScope.of(context).unfocus();
                },
                ),
            ),
          ],)
      )
    );
    });
  }// _editMilestones()

  void _individualMilestoneEdit(){
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context){
        //gets user info
        HabitProvider habitProvider = Provider.of<HabitProvider>(context);
        Habit? currentHabit = habitProvider.currentHabit;
        int currentHabitId = currentHabit?.id ?? 0;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("What is the length of time that will determine the completion of this milestone? \n"
                        "Example: 3 days, 2 weeks, & 6 months or 0 days, 0 weeks, & 6 months"),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 25, 0),
              child: DropdownButton<int>(
                key: UniqueKey(),
                value: _totalMilestones,
                  //onTap() try to make it so once it is tapped, the focus goes
                  //back to the parent?
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (newValue){
                  setState(() {
                    _totalMilestones = newValue ?? 0;
                  });
                },
                items: <int> [1, 2, 3, 4, 5]
                  .map<DropdownMenuItem<int>>((int value){
                    return DropdownMenuItem(
                      key: UniqueKey(),
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
            ),
          ],)
      )
    );
    });
  }// _editMilestones()
}//end class _MilestoneTile
