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
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Registration Page',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 25,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
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
}

  // @override
  // Widget build(BuildContext context) {
  //   _ctx = context;
  //   var registerBtn = new CupertinoButton(
  //       child: new Text("Register"),
  //       onPressed: _submit,
  //       color: Color.fromRGBO(0, 122, 253, 1));
  //   var loginBtn = new CupertinoButton(
  //       child: new Text("Login"),
  //       onPressed: () {
  //         Navigator.of(context).pushNamed("/login");
  //       });
  //   // ignore: unnecessary_new
  //   var loginForm = new Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: <Widget>[
  //       new Text(
  //         "Kindly provide your username and password this data can be used later to log in.",
  //         textScaleFactor: 1,
  //       ),
  //       // ignore: unnecessary_new
  //       new Form(
  //         key: formKey,
  //         // ignore: unnecessary_new
  //         child: new Column(
  //           children: <Widget>[
  //             // ignore: unnecessary_new
  //             new Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               // ignore: unnecessary_new
  //               child: new TextFormField(
  //                 onSaved: (val) => _username = val!,
  //                 decoration: new InputDecoration(labelText: "Any Username"),
  //               ),
  //             ),
  //             new Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: new TextFormField(
  //                 onSaved: (val) => _password = val!,
  //                 decoration: new InputDecoration(labelText: "Any Password"),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //       registerBtn,
  //       loginBtn,
  //     ],
  //   );

  //   return new Scaffold(
  //     appBar: new AppBar(
  //       title: new Text("Register Page"),
  //     ),
  //     key: scaffoldKey,
  //     body: new Container(
  //       child: new Center(
  //         child: loginForm,
  //       ),
  //     ),
  //   );
  // }

//   @override
//   void onRegisterError(String error) {
//     // TODO: implement onRegisterError
//     // _showSnackBar(error);
//     setState(() {
//       _isLoading = false;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('An error occurred. Please try again later.'),
//             backgroundColor: Colors.red,
//     ),);
//   }

//   @override
//   void onRegisterSuccess(User user) async {
//     // TODO: implement onLoginSuccess
//     // _showSnackBar(user.toString());
//     setState(() {
//       _isLoading = false;
//     });
//     var db = new DatabaseHelper();
//     await db.saveUser(user);
//     Navigator.of(context).pushNamed("/login");
//   }
// }
