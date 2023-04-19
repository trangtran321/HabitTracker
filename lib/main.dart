import 'package:flutter/material.dart';
import 'package:habit_tracker/services.dart/user_provider.dart';
import 'pages/home_page.dart';
import 'pages/calendar/calendar_page.dart';
import 'pages/habit/progress_page.dart';
import 'pages/profile_page.dart';
import 'pages/registration/registration_page.dart';
import 'services.dart/chartsBuilder.dart';
import 'pages/login/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MainApp(),
    ),
  );
}

final routes = {
  '/home': (BuildContext context) => NavigationScreen(currentIndex: 0),
  '/register': (BuildContext context) => RegisterPage(),
  '/login': (BuildContext context) => const LoginPage(),
};

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isLoggedIn = false;
  int currentIndex = 0;

  void login() {
    setState(() {
      isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HABIT TRACKER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: isLoggedIn
          ? NavigationScreen(currentIndex: currentIndex)
          : const LoginPage(),
      routes: routes,
    );
  }
}

class NavigationScreen extends StatefulWidget {
  NavigationScreen({Key? key, required this.currentIndex}) : super(key: key);
  int currentIndex;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

List<Widget> screens = [
  const HomePage(),
  const CalendarPage(),
  ProgressPage(),
  ChartBuilder(),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.timeline), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: "Charts"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
