import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spot_up/main.dart';

import 'package:spot_up/constants/constants.dart';
import 'package:spot_up/models/user.dart';
import 'package:spot_up/pages/home.dart';
import 'package:spot_up/services/auth.dart';
import 'package:spot_up/services/user_database.dart';

class CustomRegister extends StatefulWidget {
  final Function updateUser;

  CustomRegister(this.updateUser);

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
      appBar: AppBar(
        title: Text(
          MyApp.title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: MyApp.brandcolor,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Username'),
                validator: (val) => val.isEmpty ? 'Enter a username' : null,
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
                          await userDatabase.createCustomUser(username: username);
                          widget.updateUser(await (userDatabase.getCustomUser()));
                          setState(() {
                            loading = false;
                          });
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
