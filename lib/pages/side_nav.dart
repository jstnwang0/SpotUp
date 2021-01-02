import 'package:flutter/material.dart';
import 'package:spot_up/models/user.dart';
import 'package:spot_up/services/auth.dart';

class SideNav extends StatefulWidget {
  final Function signOut;
  final LocalUser user;

  SideNav({this.signOut, this.user});
  @override
  _SideNavState createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.deepPurple,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(top: 30, bottom: 10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.photoURL),
                      radius: 50,
                    ),
                  ),
                  Text(
                    widget.user.username,
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Log Out'),
            onTap: () async {
              await AuthService().signOut();
              widget.signOut();
            },
          ),
        ],
      ),
    );
  }
}
