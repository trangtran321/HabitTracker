import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/login_presenter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {//implements LoginPageContract {

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // BuildContext _ctx;
  // bool _isLoading;
  // final formKey = new GlobalKey<FormState>();
  // final scaffoldKey = new GlobalKey<ScaffoldState>();

  // final _username, _password;
  // LoginPagePresenter _presenter;

  // _LoginPageState(){
  //   _presenter = new LoginPagePresenter(this);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[200],
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Cultivate',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sign in',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              // creates the text box for entering a username
              controller: userNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              //creates the text box for entering a password
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              //forgot password button
            },
            child: const Text(
              'Forgot Password',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              //creates a login button
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                print(userNameController.text);
                print(passwordController.text);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Does Not Have Account?',
              ),
              TextButton(
                //creates a sign up button
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                onPressed: () {
                  //signup screen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
