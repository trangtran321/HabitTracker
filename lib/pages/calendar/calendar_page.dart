import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '/services.dart/notificationService.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int selectedHour = 0;
  int selectedMin = 0;
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
          // pulls up a date picking widget
          DatePicker.showDateTimePicker(context, showTitleActions: true,
              onConfirm: (date) {
            selectedHour = date.hour;
            selectedMin = date.minute;
            //sets notifcation alert based on time chosen in the datetime picker
            NotificationService.dailyNotification(
                title: "CULTIVATE",
                body: "Remember to login and check your habits!",
                Hour: selectedHour,
                Minute: selectedMin);
          });
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
