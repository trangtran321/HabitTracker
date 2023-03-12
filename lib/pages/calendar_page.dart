import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text(
          'Calendar',
          style: TextStyle(color: Colors.amber, fontSize: 25),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text(
          '+',
          style: TextStyle(fontSize: 32),
        ),
        onPressed: () {},
      ),
      body: SfCalendar(
        view: CalendarView.month,
        backgroundColor: Colors.amber[200],
        monthViewSettings: const MonthViewSettings(showAgenda: true),
      ),
    );
  }
}
