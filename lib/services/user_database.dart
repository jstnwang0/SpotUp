import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spot_up/models/user.dart';
import 'package:spot_up/pages/home.dart';

class UserDatabase {
  final String uid;
  final String photoURL;
  UserDatabase({this.uid, this.photoURL});

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
    return await users
        .doc(uid)
        .set({'username': username, 'username_insensitive': username.toLowerCase()});
  }

  Future<bool> usernameExists(String username) async {
    QuerySnapshot results =
        await users.where('username_insensitive', isEqualTo: username.toLowerCase()).get();
    List<DocumentSnapshot> usernames = results.docs;

    if (usernames.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  LocalUser _userFromFirebaseDoc(DocumentSnapshot user) {
    return user != null
        ? LocalUser(
            uid: user.id,
            username: user.get('username'),
            photoURL: photoURL,
          )
        : null;
  }
}
