class User{
  String userName = '';
  String passWord = '';
 // String full_name;
 // Habit[] habits;
 // Awards[] awards;
  int id = 0;


  User(this.userName, this.passWord);

  User.map(dynamic obj){
    this.userName = obj['username'];
    this.passWord = obj['password'];
    this.id = obj['iD'];
  }

  String get username => userName;
  String get password => passWord;
  int get iD => id;
  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map["username"] = userName;
    map["password"] = passWord;
    return map;
  }

}
