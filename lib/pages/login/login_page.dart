// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/pages/login/login_presenter.dart';
import 'package:habit_tracker/pages/registration/registration_page.dart';
import 'package:provider/provider.dart';
import '../../services.dart/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract {
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
                style: const TextStyle(color: Colors.white54),
                obscureText: true,
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
                onPressed: () {
                  _submit();
                },
                child: const Text(
                  'Login',
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: const Text('Don\'t have an account? Register here.'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onLoginError(String error) {
    //TODO implement onLoginError
    //_showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
    //need an if statement to check if user exists, if not show this message:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid email or password. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  } //end onLoginError

  @override
  void onLoginSuccess(User user) async {
    // TODO implement onLoginSuccess
    //_showSnackBar(user.toString());
    setState(() {
      _isLoading = false;
      Provider.of<UserProvider>(_ctx, listen: false).setCurrentUser(user);
    });
    //Navigator.of(context).pushNamed("/home");
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  } //end onLoginSuccess

  AppBar _buildHeader() {
    return AppBar(
      backgroundColor: Colors.grey[900],
      centerTitle: true,
      title: const Text(
        'Login Page',
        style: TextStyle(
          color: Colors.amber,
          fontSize: 25,
        ),
      ),
    );
  }
}
