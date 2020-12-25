import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spot_up/models/user.dart';
import 'package:spot_up/pages/authentication/authenticate.dart';
import 'package:spot_up/pages/authentication/custom_register.dart';
import 'package:spot_up/pages/home.dart';
import 'package:spot_up/services/auth.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User user = AuthService().user;
  LocalUser localUser;

  void updateUser(LocalUser local) {
    setState(() {
      localUser = local;
      user = AuthService().user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Authenticate(updateUser);
    } else if (localUser == null) {
      return CustomRegister(updateUser);
    } else {
      return HomePage(updateUser: updateUser, user: localUser);
    }
  }
}
