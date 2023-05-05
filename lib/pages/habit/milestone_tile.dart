 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/db_helper.dart';
import '../../models/habit.dart';
import '../../models/milestones.dart';
import '../../services.dart/habit_provider.dart';
 //import 'package:flutter_overlays_app/constants/constants.dart';

class MilestoneOverlay extends StatefulWidget{
  const MilestoneOverlay({Key? key}) : super (key: key);
  @override
  _MilestoneOverlayState createState() => _MilestoneOverlayState();
}

class _MilestoneOverlayState extends State<MilestoneOverlay> with
  TickerProviderStateMixin {
    //focus node object to detect gained or loss textField
    final FocusNode _focusNode = FocusNode();
    OverlayEntry? _overlayEntry;
    GlobalKey globalKey = GlobalKey();
    final LayerLink _layerLink = LayerLink();


    int _totalMilestones = 0;

    var db = new DatabaseHelper();

    @override
    String getHabitName(){
      builder:(BuildContext context){
        HabitProvider habitProvider = Provider.of<HabitProvider>(context);
        Habit? currentHabit = habitProvider.currentHabit;
        String habitName = currentHabit?.habitName ?? "";
        return habitName;
      };
        return "";
    }

    @override
    void initState() {
      super.initState();
      OverlayState? overlayState = Overlay.of(context);
      WidgetsBinding.instance!.addPostFrameCallback((_){
        globalKey;
      }); //end widgetsBinding

      _focusNode.addListener((){
        if (_focusNode.hasFocus){
          _overlayEntry = _createOverlay();
          overlayState!.insert(_overlayEntry!);
        }
        else{
          _overlayEntry!.remove();
        }
      }); //end focusNodeListener
    }//end initState()

    OverlayEntry _createOverlay() {
      RenderBox renderBox = context.findRenderObject() as RenderBox;//defaults to empty string
      var size = renderBox.size;
      Milestones milestone = Milestones(getHabitName(), 0, 0, 0, 0);

      return OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 100.0),
            child: Material(
              elevation: 5.0,
              child: Column(
                children: [
                  TextField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsetsDirectional.only(bottom: 50),
                  labelText: 'How many milestones would you like? 0-5',
                ),
                textAlignVertical: TextAlignVertical.top,
                maxLines: 1,
                onChanged: (value){
                  setState(() {
                    _totalMilestones = value as int;
                  });
                },//on chaged end
              ),

              Align(alignment: Alignment.bottomCenter,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                          const MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 255, 174, 60)),
                          minimumSize:
                            MaterialStateProperty.all(Size(100,30))),
                      onPressed: () {

                          var db = DatabaseHelper();

                          if (milestone.total != _totalMilestones){
                              milestone.total = _totalMilestones;
                          }

                          db.updateMilestone(milestone);
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),), //onPressed & textButton
                    ),
                ]
              ),

//textfield end

              // child: Column(
              //   children: const [
              //     ListTile(
              //       title: Text('1'),
              //       onTap: () => (

              //       ),
              //     ),
              //     ListTile(
              //       title: Text('2'),
              //     ),
              //     ListTile(
              //       title: Text('3'),
              //     ),
              //     ListTile(
              //       title: Text('4'),
              //     ),
              //     ListTile(
              //       title: Text('5'),
              //     ),
              //     ],//children
              //   ),
              ),
            ), //child:compositedtransformfolloer
          ) //Positioned end
        );//end return OverlayEntry
    }//end _createOverlay()
  @override
  Widget build(BuildContext context){


    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        focusNode: _focusNode,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          labelText: 'Total Milestones',
          ),
        // onSaved: (value){
        //   setState(() {
        //     milestone.total = _totalMilestones;
        //  }); //setState
        //},
    ),); //
  }
  }




































// import 'package:habit_tracker/database/db_helper.dart';
// import 'package:habit_tracker/models/habit.dart';
// import 'package:provider/provider.dart';
// import '../../models/milestones.dart';
// import '../../models/user.dart';
// import '../../services.dart/habit_provider.dart';
// import '../../services.dart/user_provider.dart';

// class MilestoneTile extends StatefulWidget {
//   final Milestones milestone;
//   const MilestoneTile({Key? key, required this.milestone}) : super(key: key);

//   @override
//   State<MilestoneTile> createState() => _MilestoneTileState();
// }

// class _MilestoneTileState extends State<MilestoneTile> {
// //////////////////////////////////////////////////////////////
// ///This is a test to see if milestones should be its own popup button
//   final _milestoneTotalController = TextEditingController();
//   int _totalMilestones = 0;
//   List<int> inputData = [];

//   void _getTotalMilestones(){

//   showModalBottomSheet(

//     context: context,
//     builder: (BuildContext context){
//       HabitProvider habitProvider = Provider.of<HabitProvider>(context);
//       Habit? currentHabit = habitProvider.currentHabit;
//       int currentHabitId = currentHabit?.id ?? 0;
//     return SingleChildScrollView(
//       child: Container(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text("How many milestones would you like to set?"),
//             const SizedBox(height: 50),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(50, 0, 25, 0),
//               child: DropdownButton<int>(
//                 key: UniqueKey(),
//                 value: _totalMilestones,
//                   //onTap() try to make it so once it is tapped, the focus goes
//                   //back to the parent?
//                 onChanged: (int? value){
//                   setState(() {
//                     _totalMilestones = value!;
//                   });
//                 },
//                 items: <int> [0, 1, 2, 3, 4, 5]
//                   .map<DropdownMenuItem<int>>((int value){
//                     return DropdownMenuItem(
//                       key: UniqueKey(),
//                       value: value,
//                       child: Text(value.toString()),
//                     );
//                   }).toList(),
//                 ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 var db = DatabaseHelper();
//                   //if the total milestones inputed does not match what is in db,
//                   //change db totalmilestones
//                   if (widget.milestone.total != _totalMilestones){
//                     widget.milestone.total = _totalMilestones;
//                   }

//                   db.updateMilestone(widget.milestone);

//                   _totalMilestones = 0;

//                   //updates each milestone for # of days p/ milestone
//                   _individualMilestoneEdit(context);
//                   FocusScope.of(context).unfocus();


//                 },
//                 child: Text('Next'),
//             ),
//           ],)
//       )
//     );
//     });
//   }// _editMilestones()

//   void _individualMilestoneEdit(BuildContext context){
//   showDialog(
//     context: context,
//     builder: (BuildContext context){
//     return SingleChildScrollView(
//       child: Container(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text("What is the length of time that will determine the completion of this milestone? \n"
//                         "Example: 3 days, 2 weeks, & 6 months or 0 days, 0 weeks, & 6 months"),
//             const SizedBox(height: 50),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(50, 0, 25, 0),
//               child:
//               ListView.builder(
//                 itemCount: _totalMilestones,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: TextField(
//                       onChanged: (value){
//                         inputData[index] = value as int;
//                       },
//                       decoration: const InputDecoration(
//                         labelText: 'consecutive days of completion',
//                       ),
//                     ),
//                     );
//                 }, //itemBuilder
//               ),
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   var db = DatabaseHelper();
//                   //if the total milestones inputed does not match what is in db,
//                   //change db totalmilestones
//                   if (widget.milestone.ms1 != inputData[0]){
//                     widget.milestone.ms1 = inputData[0];
//                   }
//                   if (widget.milestone.ms2 != inputData[1]){
//                     widget.milestone.ms2 = inputData[1];
//                   }
//                   if (widget.milestone.ms3 != inputData[2]){
//                     widget.milestone.ms3 = inputData[2];
//                   }
//                   if (widget.milestone.ms4 != inputData[3]){
//                     widget.milestone.ms4 = inputData[3];
//                   }
//                   if (widget.milestone.ms5 != inputData[4]){
//                     widget.milestone.ms5 = inputData[4];
//                   }
//                   db.updateMilestone(widget.milestone);
//                   _totalMilestones = 0;
//                   FocusScope.of(context).unfocus();
//                 },
//                 child: Text('Submit'),
//               ),
//           ],
//         ),
//       ),
//     );
//     });
//   }// _editMilestones()

//   @override
//   Widget build(BuildContext context){

//     return Container(
//       height: 100,
//       margin: const EdgeInsets.only(
//         top: 8, bottom: 8),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 30),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
//         tileColor: Colors.amber[200],
//         title: const Text(
//           ('Milestones'),
//         ),
//         subtitle: const Text ('Tap to Edit'),
//         onTap: _getTotalMilestones,

//         )
//     );
//   }
// }//end class _MilestoneTile
