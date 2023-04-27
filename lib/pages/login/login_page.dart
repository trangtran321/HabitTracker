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
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text('Login Page',
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
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
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
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
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
                child: const Text('Login'),
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
      //else show::
      // ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text(
      //             'An error occurred while logging in. Please try again later.'),
      //         backgroundColor: Colors.red,
      //       ),
      //     );
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
}

//   @override
//   Widget build(BuildContext context) {
//     _ctx = context;

//     var loginBtn = new CupertinoButton(
//         child: new Text("Login"),
//         onPressed: () {
//           _submit();
//           print('login button pressed');
//         },
//         color: Color.fromRGBO(0, 122, 253, 1));
//     var registerBtn = new CupertinoButton(
//         child: new Text("Register"),
//         onPressed: () {
//           Navigator.of(context).pushNamed('/register');
//         });
//     var loginForm = Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         new Text(
//           "If you don't know your username and password you can always register",
//           textScaleFactor: 1.0,
//         ),
//         new Form(
//           key: formKey,
//           child: new Column(
//             children: <Widget>[
//               new Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: new TextFormField(
//                   onSaved: (val) => _username = val!,
//                   decoration: new InputDecoration(labelText: "Username"),
//                 ),
//               ),
//               new Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: new TextFormField(
//                   onSaved: (val) => _password = val!,
//                   decoration: new InputDecoration(labelText: "Password"),
//                 ),
//               )
//             ],
//           ),
//         ),
//         loginBtn,
//         registerBtn
//       ],
//     );

//     return new Scaffold(
//       appBar: new AppBar(
//         title: const Text("Login Page"),
//       ),
//       key: scaffoldKey,
//       body: Container(
//         child: Center(
//           child: loginForm,
//         ),
//       ),
//     );
//   }

//   @override
//   void onLoginError(String error) {
//     // TODO: implement onLoginError
//     //_showSnackBar(error);
//     setState(() {
//       _isLoading = false;
//     });
//     //need an if statement to check if user exists, if not show this message:
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Invalid email or password. Please try again.'),
//         backgroundColor: Colors.red,
//       ),
//     //else show::
//     // ScaffoldMessenger.of(context).showSnackBar(
//     //       const SnackBar(
//     //         content: Text(
//     //             'An error occurred while logging in. Please try again later.'),
//     //         backgroundColor: Colors.red,
//     //       ),
//     //     );
//   );
//   }

//   @override
//   void onLoginSuccess(User user) async {
//     // TODO: implement onLoginSuccess
//     //_showSnackBar(user.toString());
//     setState(() {
//       _isLoading = false;
//       Provider.of<UserProvider>(_ctx, listen: false).setCurrentUser(user);
//     });
//     //Navigator.of(context).pushNamed("/home");
//     Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//   }
// }
