class Milestones {
  String  _habitName = "";
  int _id = 0;
  int _total = 0;
  int _ms1 = 0;
  int _ms2 = 0;
  int _ms3 = 0;

  //Initializer for the habit that maps to the milestones
  //each potential milestone's day-timeline is defaulted to 0 until user chooses
  //otherwise
  Milestones(this._habitName, this._total, this._ms1, this._ms2, this._ms3,
      {int id = 0})
      : _id = id;

  Milestones.map(dynamic obj) {
    this._habitName = obj['habitName'];
    this._id = obj['id'];
    this._total = obj['total'];
    this._ms1 = obj['ms1'];
    this._ms2 = obj['ms2'];
    this._ms3 = obj['ms3'];
  }

  String get habitName => _habitName;
  int get id => _id;
  int get total => _total;
  int get ms1 => _ms1;
  int get ms2 => _ms2;
  int get ms3 => _ms3;

  set total(int totalMS){
    total = totalMS;
  }
  set ms1(int mS1){
    ms1 = mS1;
  }
  set ms2(int mS2){
    ms2 = mS2;
  }
  set ms3(int mS3){
    ms3 = mS3;
  }
  set ms4(int mS4){
    ms4 = mS4;
  }
  set ms5(int mS5){
    ms5 = mS5;
  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["habitName"] = _habitName;
    map["total"] = _total;
    map["ms1"] = _ms1;
    map["ms2"] = _ms2;
    map["ms3"] = _ms3;
    return map;
  }
}
