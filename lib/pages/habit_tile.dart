import 'package:flutter/material.dart';
import 'package:test1/services.dart/lists.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final onHabitChanged;
  final onDeleteHabit;

  const HabitTile(
      {Key? key, required this.habit, this.onHabitChanged, this.onDeleteHabit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //Creates the box for the habit
      height: 60,
      margin: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      child: ListTile(
        onTap: () {
          //  changes the value of isDone from false to true or vice versa
          onHabitChanged(habit);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.amber[300],
        leading: Icon(
          habit.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.grey[700],
        ),
        title: Text(
          //prints the habit text to the box followed by its streak
          '${habit.habitText!}: ${habit.habitCount}',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            decoration: habit.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              color: Colors.red[400], borderRadius: BorderRadius.circular(5)),
          child: IconButton(
            color: Colors.white,
            iconSize: 15,
            icon: const Icon(Icons.delete),
            onPressed: () {
              //print('Clicked on Delete item');
              onDeleteHabit(habit.id);
            },
          ),
        ),
      ),
    );
  }
}
