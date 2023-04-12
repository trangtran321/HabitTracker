import 'package:flutter/foundation.dart';

import '../models/habit.dart';

class HabitProvider with ChangeNotifier{
   //Store current user data
  Habit? _currentHabit;

  //Getter for current user
  Habit? get currentHabit => _currentHabit;

  //Function to set current user data and notify listeners
  void setCurrentUser(Habit habit){
    _currentHabit = habit;
    notifyListeners();
  }
}
