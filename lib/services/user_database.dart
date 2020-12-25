import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spot_up/models/user.dart';
import 'package:spot_up/pages/home.dart';

class UserDatabase {
  final String uid;
  UserDatabase({this.uid});

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<LocalUser> getCustomUser() async {
    try {
      return await users.doc(uid).get().then((doc) async {
        if (doc.exists) {
          return _userFromFirebaseDoc(doc);
        } else {
          return null;
        }
      });
    } catch (error) {
      print("Error:" + error.toString());
    }
    return null;
  }

  Future<void> createCustomUser({String username}) async {
    return await users.doc(uid).set({'username': username});
  }

  LocalUser _userFromFirebaseDoc(DocumentSnapshot user) {
    return user != null
        ? LocalUser(
            uid: user.id,
            username: user.get('username'),
          )
        : null;
  }
}
