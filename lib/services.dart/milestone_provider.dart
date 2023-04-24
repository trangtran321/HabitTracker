import 'package:flutter/foundation.dart';
import 'package:habit_tracker/models/milestones.dart';

class MilestoneProvider with ChangeNotifier{
   //Store current user data
  Milestones? _currentMilestone;

  //Getter for current user
  Milestones? get currentMilestone => _currentMilestone;

  //Function to set current user data and notify listeners
  void setCurrentMilestone(Milestones milestone){
    _currentMilestone = milestone;
    notifyListeners();
  }
}
