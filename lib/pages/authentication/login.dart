import 'package:flutter/material.dart';
import 'package:spot_up/main.dart';
import 'package:spot_up/models/user.dart';
import 'package:spot_up/services/auth.dart';
import 'package:spot_up/constants/constants.dart';
import 'package:spot_up/services/user_database.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  final Function signIn;

  Login({this.toggleView, this.signIn});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              loading
                  ? Loading()
                  : RaisedButton(
                      color: Colors.deepPurple,
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                          if (result is String) {
                            //Error occured
                            setState(() {
                              loading = false;
                              error = result;
                            });
                          } else {
                            await widget.signIn();
                          }
                        }
                      },
                    ),
              RaisedButton(
                color: Colors.deepPurple,
                child: Text(
                  'Sign In With Google',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  dynamic result = await _auth.signInWithGoogle();

                  if (result is String) {
                    //Error occured
                    setState(() {
                      loading = false;
                      error = result;
                    });
                  } else {
                    await widget.signIn();
                  }
                },
              ),
              RaisedButton(
                  color: Colors.deepPurple,
                  child: Text(
                    'No account? Sign up!',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    widget.toggleView();
                  }),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
