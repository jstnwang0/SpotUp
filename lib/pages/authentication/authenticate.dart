import 'package:flutter/material.dart';
import 'package:spot_up/pages/authentication/custom_register.dart';
import 'package:spot_up/pages/authentication/login.dart';
import 'package:spot_up/pages/authentication/register.dart';

class Authenticate extends StatefulWidget {
  final Function signIn;
  final Function signUp;

  Authenticate({this.signIn, this.signUp});
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Login(toggleView: toggleView, signIn: widget.signIn);
    } else {
      return Register(toggleView: toggleView, signUp: widget.signUp);
    }
  }
}
