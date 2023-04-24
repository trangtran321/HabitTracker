class Habit {
  String _habitName = "";
  int _doneToday = 0;
  int _completed = 0;
  int _streakCount = 0;
  int _id = 0;
  int _userId = 0; //need to change to current userID

  Habit(this._habitName, this._doneToday, this._userId,
      {int id = 0, int streakCount = 0, int completed = 0})
      : _id = id,
        _streakCount = streakCount,
        _completed = completed;


  Habit.map(dynamic obj) {
    this._habitName = obj['habitName'];
    this._doneToday = obj['doneToday'];
    this._streakCount = obj['streakCount'];
    this._completed = obj['completed'];
<<<<<<< Updated upstream
    this._milestones = obj['milestones'];
=======
>>>>>>> Stashed changes
    this._id = obj['id'];
    this._userId = obj['userId'];
  }

  String get habitName => _habitName;
  int get doneToday => _doneToday;
  int get streakCount => _streakCount;
  int get completed => _completed;
  int get id => _id;
  int get userId => _userId;

  set habitName(String name) {
    //sets a new name for a habit
    _habitName = name;
  }

  set streakCount(int streak) {
    // allows us to increment or decrement or set a streak value
    _streakCount = streak;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["habitName"] = _habitName;
    map["doneToday"] = _doneToday;
    map["streakCount"] = _streakCount;
    map["completed"] = _completed;
    map["userId"] = _userId;
    return map;
  }
}
