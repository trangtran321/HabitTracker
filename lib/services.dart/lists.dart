class Habit {
  String? id;
  String? habitText;
  bool isDone;
  double habitCount = 0;

  Habit({
    required this.id, // indexing for the list of habits using milliseconds
    this.habitText, // the habit text
    this.isDone = false, // keeps track of whether its been checked off or not
    this.habitCount =
        0, //  keeps track of how many times the habit has been checked off
  });

  static List<Habit> habitList() {
    return [
      ///Test list of habits
      ///
      Habit(id: '01', habitText: 'Exercise', habitCount: 5),
      Habit(id: '02', habitText: 'Code', habitCount: 10),
      Habit(id: '03', habitText: 'Buy Groceries', habitCount: 0),
      Habit(id: '04', habitText: 'Meditate', habitCount: 20),
      Habit(id: '05', habitText: 'Read', habitCount: 8),
      Habit(id: '06', habitText: 'Laundry', habitCount: 0),
    ];
  }
}
