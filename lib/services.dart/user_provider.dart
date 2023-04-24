import 'package:flutter/foundation.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier{
   //Store current user data
  User? _currentUser;

  //Getter for current user
  User? get currentUser => _currentUser;

  //Function to set current user data and notify listeners
  void setCurrentUser(User user){
    _currentUser = user;
    notifyListeners();
  }
}
