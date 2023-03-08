import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
//import 'habit_tile.dart';

class HomePage extends StatelessWidget {
  bool onchanged = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          title: const Text(
            'Habit Tracker',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 25,
            ),
          ),
        ),
        // body: ListView(
        //   children: [
        //     CheckboxListTile(
        //       value: true,
        //       onChanged: (value) => onchanged,
        //     ),
        //   ],
        // ),
        body: Container(
          child: SfCalendar(
            view: CalendarView.month,
            backgroundColor: Colors.grey[200],
          ),
        ));
  } //build
}
