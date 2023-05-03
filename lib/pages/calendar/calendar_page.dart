import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '/services.dart/notificationService.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: _buildHeader(), //method for building the header for the page
      floatingActionButton: FloatingActionButton(
        child: const Text(
          '+',
          style: TextStyle(fontSize: 32),
        ),
        onPressed: () async {
          //sets hard coded notifcation alert if possible we should update so that the user can specify when they get the notifications
          await NotificationService.scheduleNotification(
              title: "CULTIVATE",
              body: "Remember to login and check your habits!",
              Day: 3,
              Month: 5,
              Year: 2023,
              Hour: 15,
              Minute: 15);
        },
      ),
      body: SfCalendar(
        view: CalendarView.month,
        backgroundColor: Colors.amber[200],
        monthViewSettings: const MonthViewSettings(showAgenda: true),
      ),
    );
  }

  AppBar _buildHeader() {
    return AppBar(
      backgroundColor: Colors.grey[900],
      centerTitle: true,
      title: const Text(
        'Calendar',
        style: TextStyle(
          color: Colors.amber,
          fontSize: 25,
        ),
      ),
    );
  }
}
