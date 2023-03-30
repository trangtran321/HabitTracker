
import 'package:habit_tracker/database/rest_data.dart';
import 'package:habit_tracker/models/user.dart';

abstract class RegisterPageContract {
  void onRegisterSuccess(User user);
  void onRegisterError(String error);
}

class RegisterPagePresenter {
  RegisterPageContract _view;
  RestData api = new RestData();
  RegisterPagePresenter(this._view);

  doRegister(String username, String password) {
    api
        .login(username, password)
        .then((user) => _view.onRegisterSuccess(user))
        .catchError((onError) {
          //print("Trying to Catch"+onError.toString());
          return _view.onRegisterError(onError.toString());
    });
  }
}
