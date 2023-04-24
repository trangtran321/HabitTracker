import 'dart:io';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/milestones.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  //checks if you have created the database or not, if not, it will initialize
  //a new database
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  //creates database
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    print("db_location: " + path);
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //creates database with a User table
  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE User(
          id INTEGER PRIMARY KEY,
          username TEXT NOT NULL UNIQUE,
          password TEXT)
        ''');

    await db.execute('''CREATE TABLE Habit(
          id INTEGER PRIMARY KEY,
          habitName TEXT,
          doneToday INTEGER,
          completed INTEGER,
          streakCount INTEGER,
          userId INTEGER,
          FOREIGN KEY(userId) REFERENCES User(id))
        ''');

    await db.execute('''CREATE TABLE Milestone(
          id INTEGER PRIMARY KEY,
          total INTEGER,
          ms1 INTEGER,
          ms2 INTEGER,
          ms3 INTEGER,
          ms4 INTEGER,
          ms5 INTEGER,
          habitName TEXT,
          FOREIGN KEY(habitName) REFERENCES Habit(habitName))
        ''');

    print("User Table is created");
  }

  //joining User and Habit table via the userID
  //This will link the habits created in the app to the currently logged in User
  Future<List<Map<String, dynamic>>> performQueryJoin() async {
    Database? dbClient = await db;
    return await dbClient.rawQuery('''
        SELECT  User.id, Habit.userId, Habit.id, Habit.habitName
        FROM    Habit
        JOIN    User ON Habit.userId = User.id
        ''');
  }

  //insertion of User into database
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    if (await userExists(user)) {
      print('Username Already Exists!');
      //Navigator.of(context).pushNamed("/register");
      print(-1);
      return -1;
    } else {
      var dbClient = await db;
      int res = await dbClient.insert("User", user.toMap());
      print("ADDED TO DB");
      print(res);
      return res;
    }
  }

  //deletion from database
  Future<int> deleteUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;

    List<Map<String, dynamic>> res =
        await dbClient.query("User", where: '"id" = ?', whereArgs: [id]);
    for (var row in res) {
      //print(row['id']);
      return Future<User>.value(User.map(row));
    }
    throw 'Something went wrong in getUser() in db_helper.';
  }

  Future<int> getUserId(String username) async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(
      "User",
      columns: ["id"],
      where: '"username" = ?',
      whereArgs: [username],
    );
    return res[0]['id'];
  }

  Future<User> checkUser(User user) async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query("User",
        where: '"username" = ? and "password"=?',
        whereArgs: [user.username, user.password]);
    print(res);
    for (var row in res) {
      return Future<User>.value(User.map(row));
    }
    return Future<User>.error("Unable to find User");
  }

  Future<List<User>> getAllUser() async {
    var dbClient = await db;
    List<User> users = [];
    List<Map<String, dynamic>> res = await dbClient.query("User");
    for (var row in res) {
      users.add(User.map(row));
    }
    return Future<List<User>>.value(users);
  }

  Future<int> deleteSingleUser(int id) async {
    var dbClient = await db;
    Future<int> res =
        dbClient.delete("User", where: '"id" = ?', whereArgs: [id]);
    return res;
  }

  Future<bool> userExists(User user) async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient
        .query("User", where: '"username" = ?', whereArgs: [user.username]);
    return res.isNotEmpty;
  }

//----------------Habit Table Functions-------------------//

    //insertion of Habit to User database
  Future<int> saveHabit(Habit habit) async {
    var dbClient = await db;
    int res = await dbClient.insert("Habit", habit.toMap());
    return res;
  }

  Future<Habit> checkHabit(Habit habit) async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient
        .query("Habit", where: '"habit" = ?', whereArgs: [habit.habitName]);
    print(res);
    for (var row in res) {
      return Future<Habit>.value(Habit.map(row));
    }
    return Future<Habit>.error("Unable to find Habit");
  }

  Future<int> updateHabit(Habit habit) async {
    var dbClient = await db;
    int res = await dbClient.update(
      "habit",
      habit.toMap(),
      where: '"id" = ?',
      whereArgs: [habit.id],
    );
    return res;
  }

  Future<int> deleteHabit(int id) async {
    var dbClient = await db;
    int res = await dbClient.delete(
      "Habit",
      where: '"id" = ?',
      whereArgs: [id],
    );
    return res;
  }

  Future<Habit> getHabit(Future<int> id) async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(
      "Habit",
      where: '"id" = ?',
      whereArgs: [id],
    );
    for (var row in res) {
      return Future<Habit>.value(Habit.map(row));
    }
    throw 'Something went wrong in getHabit() in db_helper.';
  }

  Future<List<Habit>> getAllHabitsForUser(int userId) async {
    var dbClient = await db;
    List<Habit> habits = [];
    List<Map<String, dynamic>> res = await dbClient.query(
      "Habit",
      where: '"userId" = ?',
      whereArgs: [userId],
    );
    for (var row in res) {
      habits.add(Habit.map(row));
    }
    return Future<List<Habit>>.value(habits);
  }

  Future<List<Habit>> getAllHabits() async {
    var dbClient = await db;
    List<Habit> habits = [];
    List<Map<String, dynamic>> res = await dbClient.query("Habit");
    for (var row in res) {
      habits.add(Habit.map(row));
    }
    return Future<List<Habit>>.value(habits);
  }


//-------------Milestone Table Functions-----------------//


  //insertion of milestones into db
  Future<int> saveMilestone(Milestones milestone) async {
    var dbClient = await db;
    int res = await dbClient.insert("Milestone", milestone.toMap());
    return res;
  }

  //update milestones
  Future<int> updateMilestone(Milestones milestone) async {
    var dbClient = await db;
    int res = await dbClient.update(
      "Milestone",
      milestone.toMap(),
      where: '"id" = ?',
      whereArgs: [milestone.id],
    );
    return res;
  }

  //see if milestones exist already
    Future<bool> milestoneExists(Milestones milestone) async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient
        .query("Milestone", where: '"habitName" = ?', whereArgs: [milestone.habitName]);
    return res.isNotEmpty;
  }

}


