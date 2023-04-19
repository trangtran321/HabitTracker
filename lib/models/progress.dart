class Progress {
  String _habitName = "";
  int _id = 0;
  int _totalMilestones = 0;
  int _ms1 = 0;
  int _ms2 = 0;
  int _ms3 = 0;
  int _ms4 = 0;
  int _ms5 = 0;

  //Initializer for the habit that maps to the milestones
  //each potential milestone's day-timeline is defaulted to 0 until user chooses
  //otherwise
  Progress(this._habitName, this._totalMilestones,
      {int id = 0,
      int ms1 = 0,
      int ms2 = 0,
      int ms3 = 0,
      int ms4 = 0,
      int ms5 = 0})
      : _id = id,
        _ms1 = ms1,
        _ms2 = ms2,
        _ms3 = ms3,
        _ms4 = ms4,
        _ms5 = ms5;

  Progress.map(dynamic obj) {
    _habitName = obj['habitName'];
    _id = obj['id'];
    _totalMilestones = obj['totalMilestones'];
    _ms1 = obj['ms1'];
    _ms2 = obj['ms2'];
    _ms3 = obj['ms3'];
    _ms4 = obj['ms4'];
    _ms5 = obj['ms5'];
  }

  String get habitName => _habitName;
  int get id => _id;
  int get totalMilestones => _totalMilestones;
  int get ms1 => _ms1;
  int get ms2 => _ms2;
  int get ms3 => _ms3;
  int get ms4 => _ms4;
  int get ms5 => _ms5;

  set totalMilestones(int totalMS) {
    totalMilestones = totalMS;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["habitName"] = _habitName;
    map["totalMilestones"] = _totalMilestones;
    map["ms1"] = _ms1;
    map["ms2"] = _ms2;
    map["ms3"] = _ms3;
    map["ms4"] = _ms4;
    map["ms5"] = _ms5;
    return map;
  }
}
