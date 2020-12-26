import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spot_up/main.dart';

import 'package:spot_up/constants/constants.dart';
import 'package:spot_up/models/user.dart';
import 'package:spot_up/pages/home.dart';
import 'package:spot_up/services/auth.dart';
import 'package:spot_up/services/user_database.dart';

class CustomRegister extends StatefulWidget {
  final Function login;

  CustomRegister(this.login);

  @override
  _CustomRegisterState createState() => _CustomRegisterState();
}

class _CustomRegisterState extends State<CustomRegister> {
  final _formKey = GlobalKey<FormState>();

  String error = '';
  bool loading = false;
  LocalUser user;

  String username = '';

  @override
  Widget build(BuildContext context) {
    UserDatabase userDatabase =
        UserDatabase(uid: AuthService().user == null ? null : AuthService().user.uid);
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
                decoration: textInputDecoration.copyWith(hintText: 'Username'),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Enter a username';
                  } else if (val.length < 4) {
                    return 'Enter a username with 4+ characters';
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  username = val;
                },
              ),
              SizedBox(height: 20.0),
              loading
                  ? Loading()
                  : RaisedButton(
                      color: Colors.deepPurple,
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          if (await userDatabase.usernameExists(username)) {
                            setState(() {
                              loading = false;
                              error = 'Username is taken';
                            });
                          } else {
                            await userDatabase.createCustomUser(username: username);
                            await widget.login();
                          }
                        }
                      },
                    ),
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
