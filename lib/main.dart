import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/services.dart/notificationService.dart';
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
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelDescription: 'Notification channel for basic tests',
        channelGroupKey: 'high_importance_channel',
        channelKey: 'high_importance_channel',
        channelName: 'Basic notifications',
        defaultColor: const Color.fromARGB(248, 248, 180, 86),
        ledColor: const Color.fromARGB(31, 248, 161, 48),
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        onlyAlertOnce: true,
        playSound: true,
        criticalAlerts: false,
      ),

      NotificationChannel(
        channelGroupKey: 'reminders',
        channelKey: 'scheduled_notification',
        channelName: 'Scheduled Notification',
        channelDescription:
            'Notification channel that triggers notification based on predefined time.',
        defaultColor: const Color.fromARGB(255, 255, 152, 92),
        ledColor: Colors.black87,
      ), // NotificationChannel scheduled notification
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'high_importance_channel_group',
        channelGroupName: 'Group 1',
      ),
      NotificationChannelGroup(
        channelGroupKey: 'reminders',
        channelGroupName: 'Group 2',
      ),
    ],
    debug: true,
  ); //awesomeNotifications() end
}

final routes = {
  '/home': (BuildContext context) => NavigationScreen(currentIndex: 0),
  '/register': (BuildContext context) => const RegisterPage(),
  '/login': (BuildContext context) => const LoginPage(),
};

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationService.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationService.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MainApp.navigatorKey,
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
  const ProgressPage(),
  const ChartBuilder(),
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
