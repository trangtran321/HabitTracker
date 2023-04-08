class Habit {
  String _habit = "";
  int _doneToday = 0;
  int _completed = 0;
  int _streakCount = 0;
  int _milestones = 0;
  int _id = 0;

  Habit(this._habit, this._doneToday);

  Habit.map(dynamic obj) {
    this._habit = obj['habit'];
    this._doneToday = obj['doneToday'];
    this._streakCount = obj['streakCount'];
    this._completed = obj['completed'];
    this._milestones = obj['milestones'];
    this._id = obj['id'];
  }

  String get habit => _habit;
  int get doneToday => _doneToday;
  int get streakCount => _streakCount;
  int get completed => _completed;
  int get milestones => _milestones;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["habit"] = _habit;
    map["doneToday"] = _doneToday;
    map["streakCount"] = _streakCount;
    map["completed"] = _completed;
    map["milestones"] = _milestones;
    return map;
  }
}
