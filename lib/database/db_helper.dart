import 'dart:io';
import 'package:habit_tracker/models/user.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static late Database _db;

  //checks if you have created the database or not, if not, it will initialize
  //a new database
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  //creates database
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //creates database with a User table
  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)");
    print("Table is created");
  }

  //insertion into database
  Future<int> saveUser(User user) async {
    var dbClient = await db;

    int res = await dbClient.insert("User", user.toMap());
    print(res);
    return res;
  }

  //deletion from database
  Future<int> deleteUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<User> getUser(int id) async {
   var dbClient = await db;

   List<Map<String,dynamic>> res = await dbClient.query("User",where:'"id" = ?',whereArgs: [id]);
   for(var row in res)
   {
     //print(row['id']);
     return new Future<User>.value(User.map(row));
   }
   throw 'Something went wrong in getUser() in db_helper.';
  }

  Future<User> checkUser(User user) async{
    var dbClient = await db;
    List<Map<String,dynamic>> res = await dbClient.query("User",where:'"username" = ? and "password"=?',whereArgs: [user.username,user.password]);
    print(res);
    for (var row in res)
    {

      return new Future<User>.value(User.map(row));
    }
    return new Future<User>.error("Unable to find User");
  }

  Future<List<User>> getAllUser() async {
    var dbClient = await db;
    List<User> users=[];
    List<Map<String,dynamic>> res = await dbClient.query("User");
    for(var row in res)
    {
      //print(row['id']);
      users.add(User.map(row));
    }
    return new Future<List<User>>.value(users);
  }
  Future<int> deleteSingleUser(int id) async {
    var dbClient  = await db;
    Future<int> res = dbClient.delete("User",where:'"id" = ?',whereArgs: [id]);
    return res;
  }
}
