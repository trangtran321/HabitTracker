//import 'package:habit_tracker/database/rest_data.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/database/db_helper.dart';

abstract class LoginPageContract {
  void onLoginSuccess(User user);
  void onLoginError(String error);
}

class LoginPagePresenter {
  LoginPageContract _view;
  //Not using RestData Currently - 3/27
  //RestData api = new RestData();
  LoginPagePresenter(this._view);

  doLogin(String username, String password) {
    //print("HI");
    var db = new DatabaseHelper();
    db
        .checkUser(User(username, password))
        .then((user) => _view.onLoginSuccess(user))
        .catchError((onError) {
      //print("Trying to Catch"+onError.toString());
      return _view.onLoginError(onError.toString());
    });
  }
}
