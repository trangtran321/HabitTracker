// ignore_for_file: unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/pages/login/login_presenter.dart';
import 'package:habit_tracker/pages/registration/registration_page.dart';
import 'package:provider/provider.dart';

import '../../user_provider.dart';
import '../navigation_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract {
  //NavBarIndex is page index for navigation bar to find page
  int _navBarIndex = 1;
  //onNavTapped will navigate back to current page if tapped from another page
  void _onNavTapped(int index){
    setState((){
      _navBarIndex = index;});
  }

  late BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late String _username, _password;

  late LoginPagePresenter _presenter;

  _LoginPageState() {
    _presenter = new LoginPagePresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;
    print('inside _submit');
    if (form!.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        int userId = 0;
        _presenter.doLogin(_username, _password, userId);
      });
    }
  }

  // void _showSnackBar(String text) {
  //   scaffoldKey.currentState?.showSnackBar(SnackBar(
  //     content: Text(text),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    var loginBtn = new CupertinoButton(
        child: new Text("Login"),
        onPressed: () {
          _submit();
          print('login button pressed');
        },
        color: Color.fromRGBO(0, 122, 253, 1));
    var registerBtn = new CupertinoButton(
        child: new Text("Register"),
        onPressed: () {
          Navigator.of(context).pushNamed('/register');
        });
    var loginForm = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          "If you don't know your username and password you can always register",
          textScaleFactor: 1.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val!,
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val!,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              )
            ],
          ),
        ),
        loginBtn,
        registerBtn
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Login Page"),
      ),
      key: scaffoldKey,
      body: Container(
        child: Center(
          child: loginForm,
        ),
      ),
      // bottomNavigationBar: AppNavigationBar(
      //   currentIndex: _navBarIndex,
      // ),
    );
  }

  @override
  void onLoginError(String error) {
    // TODO: implement onLoginError
    //_showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(User user) async {
    // TODO: implement onLoginSuccess
    //_showSnackBar(user.toString());
    setState(() {
      _isLoading = false;
      Provider.of<UserProvider>(_ctx, listen:false).setCurrentUser(user);
    });
    Navigator.of(context).pushNamed("/home");
  }
}
