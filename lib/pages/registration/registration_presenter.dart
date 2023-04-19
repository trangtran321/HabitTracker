import 'package:habit_tracker/database/rest_data.dart';
import 'package:habit_tracker/models/user.dart';

abstract class RegisterPageContract {
  void onRegisterSuccess(User user);
  void onRegisterError(String error);
}

class RegisterPagePresenter {
  final RegisterPageContract _view;
  RestData api = RestData();
  RegisterPagePresenter(this._view);

  doRegister(String username, String password, int userId) {
    api
        .login(username, password, userId)
        .then((user) => _view.onRegisterSuccess(user))
        .catchError((onError) {
      //print("Trying to Catch"+onError.toString());
      return _view.onRegisterError(onError.toString());
    });
  }
}
