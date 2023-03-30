//ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/pages/registration/registration_presenter.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    implements RegisterPageContract {
  late BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  late String _username, _password;

  late RegisterPagePresenter _presenter;

  _RegisterPageState() {
    _presenter = new RegisterPagePresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form!.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _presenter.doRegister(_username, _password);
      });
    }
  }

  // void _showSnackBar(String text) {
  //   scaffoldKey.currentState.showSnackBar(new SnackBar(
  //     content: new Text(text),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var registerBtn = new CupertinoButton(
        child: new Text("Register"),
        onPressed: _submit,
        color: Color.fromRGBO(0, 122, 253, 1));
    var loginBtn = new CupertinoButton(
        child: new Text("Login"),
        onPressed: () {
          Navigator.of(context).pushNamed("/login");
        });
    // ignore: unnecessary_new
    var loginForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          "Kindly provide your username and password this data can be used later to log in.",
          textScaleFactor: 1,
        ),
        // ignore: unnecessary_new
        new Form(
          key: formKey,
          // ignore: unnecessary_new
          child: new Column(
            children: <Widget>[
              // ignore: unnecessary_new
              new Padding(
                padding: const EdgeInsets.all(10.0),
                // ignore: unnecessary_new
                child: new TextFormField(
                  onSaved: (val) => _username = val!,
                  decoration: new InputDecoration(labelText: "Any Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val!,
                  decoration: new InputDecoration(labelText: "Any Password"),
                ),
              )
            ],
          ),
        ),
        registerBtn,
        loginBtn,
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Register Page"),
      ),
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: loginForm,
        ),
      ),
    );
  }

  @override
  void onRegisterError(String error) {
    // TODO: implement onRegisterError
    // _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onRegisterSuccess(User user) async {
    // TODO: implement onLoginSuccess
    // _showSnackBar(user.toString());
    setState(() {
      _isLoading = false;
    });
    var db = new DatabaseHelper();
    await db.saveUser(user);
    Navigator.of(context).pushNamed("/login");
  }
}
