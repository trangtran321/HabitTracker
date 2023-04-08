// import 'package:flutter/material.dart';
// import 'package:habit_tracker/pages/profile_page.dart';
// import 'calendar/calendar_page.dart';
// import 'habit/habits_page.dart';
// import 'home_page.dart';
// import 'login/login_page.dart';


// //Navigation bar that appears at bottom of each page
// //Must be included in each page created for UI
// //Each page must have a unique index
// class AppNavigationBar extends StatefulWidget {
//   int currentIndex;
//   AppNavigationBar({required this.currentIndex});
//   State<AppNavigationBar> createState() => _AppNavigationBarState();
// }
// import '../services.dart/chartsBuilder.dart';
// import 'calendar/calendar_page.dart';
// import 'habit/progress_page.dart';
// import 'habit/habits_page.dart';
// import 'home_page.dart';
// import 'login/login_page.dart';

// List<Widget> screens = [
//   const HomePage(),
//   const CalendarPage(),
//   HabitsPage(),
//   //chartBuilder(),
//   const ProfilePage(),
//   const LoginPage(),
// ];

// List<Widget> screens = [
//   const HomePage(),
//   const CalendarPage(),
//   ProgressPage(),
//   //chartBuilder(),
//   const ProfilePage(),
//   const LoginPage(),
// ];

// //   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: widget.currentIndex,
//         children: screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.grey,
//         unselectedItemColor: Colors.black,
//         selectedItemColor: Colors.amber,
//         currentIndex: widget.currentIndex,
//         onTap: (index) {
//           setState(() {
//             widget.currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_today),
//               label: "Calendar"),
//           BottomNavigationBarItem(icon: Icon(
//             Icons.timeline),
//             label: "Streaks"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.pie_chart),
//               label: "Progress"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Profile"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.login),
//             label: "Login"),
//         ],
//       ),
//     );
//   }
// }
