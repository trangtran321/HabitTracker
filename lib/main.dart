import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/calendar_page.dart';
import 'pages/habits_page.dart';
import 'pages/profile_page.dart';
import 'services.dart/chartsBuilder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HABIT TRACKER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: NavigationScreen(
        currentIndex: 0,
      ),
    );
  }
}

// ignore: must_be_immutable
class NavigationScreen extends StatefulWidget {
  NavigationScreen({super.key, required this.currentIndex});
  int currentIndex;
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

List<Widget> screens = [
  const HomePage(),
  const CalendarPage(),
  HabitsPage(),
  chartBuilder(),
  const ProfilePage(),
];

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.amber,
        currentIndex: widget.currentIndex,
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: "Streaks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
