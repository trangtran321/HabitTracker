class User {
  String _userName = "";
  String _passWord = "";
  // String full_name;
  // Habit[] habits;
  // Awards[] awards;
  int _id = 0;

  User(this._userName, this._passWord, this._id);

  User.map(dynamic obj) {
    _userName = obj['username'];
    _passWord = obj['password'];
    _id = obj['id'];
  }

  String get username => _userName;
  String get password => _passWord;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["username"] = _userName;
    map["password"] = _passWord;
    map["id"] = _id;
    return map;
  }
}
