import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/database/db_helper.dart';

abstract class LoginPageContract {
  void onLoginSuccess(User user);
  void onLoginError(String error);
}

class LoginPagePresenter {
  final LoginPageContract _view;
  LoginPagePresenter(this._view);

  doLogin(String username, String password, int userId) {
    var db = DatabaseHelper();
    db
        .checkUser(User(username, password, userId))
        .then((user) => _view.onLoginSuccess(user))
        .catchError((onError) {
      return _view.onLoginError(onError.toString());
    });
  }
}
