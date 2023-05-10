//ignore_for_file: unnecessary_new

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db_helper.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/pages/registration/registration_presenter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
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
    var userId = Random().nextInt(1000);

    if (form!.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _presenter.doRegister(_username, _password, userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: _buildHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white54),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                ),
                style: const TextStyle(color: Colors.white54),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')){
                    return 'Invalid email';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white54),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white54),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: const Text('Register'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/login");
                },
                child: const Text('Already have an account? Login here.'),
              ),
            ],
          ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occurred. Please try again later.'),
        backgroundColor: Colors.red,
      ),
    );
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

  AppBar _buildHeader() {
    return AppBar(
      backgroundColor: Colors.grey[900],
      centerTitle: true,
      title: const Text(
        'Registration',
        style: TextStyle(
          color: Colors.amber,
          fontSize: 25,
        ),
      ),
    );
  }
}
