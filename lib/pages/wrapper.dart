import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spot_up/constants/constants.dart';
import 'package:spot_up/models/user.dart';
import 'package:spot_up/pages/authentication/authenticate.dart';
import 'package:spot_up/pages/authentication/custom_register.dart';
import 'package:spot_up/pages/home.dart';
import 'package:spot_up/services/auth.dart';
import 'package:spot_up/services/user_database.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User user = AuthService().user;
  LocalUser localUser;
  Future<bool> initialLocalUserRefresh;
  bool skipUpdate = false;

  Future<bool> updateLocalUser() async {
    if (!skipUpdate) {
      print('Getting username');
      localUser =
          await UserDatabase(uid: AuthService().user == null ? null : AuthService().user.uid)
              .getCustomUser();
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    initialLocalUserRefresh = updateLocalUser();
  }

  Future<void> refreshBoth() async {
    skipUpdate = false;
    await updateLocalUser();
    setState(() {
      skipUpdate = true;
      user = AuthService().user;
    });
  }

  void refreshFirebaseOnly() {
    setState(() {
      user = AuthService().user;
      localUser = null;
      skipUpdate = true;
    });
  }

  void signOut() {
    setState(() {
      user = AuthService().user;
      localUser = null;
      skipUpdate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Authenticate(signIn: refreshBoth, signUp: refreshFirebaseOnly);
    } else {
      return FutureBuilder(
          future: initialLocalUserRefresh,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != true) {
              return _buildLoadingScreen();
            } else {
              if (localUser == null) {
                return CustomRegister(refreshBoth);
              } else {
                return HomePage(signOut: signOut, user: localUser);
              }
            }
          });
    }
  }
}

Widget _buildLoadingScreen() {
  return Scaffold(
    appBar: appBar,
    body: Loading(),
  );
}
