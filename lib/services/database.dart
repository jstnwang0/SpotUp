import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post.dart';

class DatabaseService {
  Future<void> updateData() async {
    var box = Hive.box('box');
    Query query = FirebaseFirestore.instance.collection('spots');
    List spotsList = [];

    if (box.get('spotsList') == null) {
      box.put('spotsList', List<Post>());
    }

    if (box.get('lastUpdate') != null) {
      query = query.where('modified', isGreaterThan: box.get('lastUpdate'));
    }

    await query.get().then((QuerySnapshot querySnapshot) {
      box.put('lastUpdate', DateTime.now());
      querySnapshot.docs.forEach((doc) {
        spotsList.add(doc);
      });

      spotsList = spotsList.map((spot) => _postFromFirebaseDoc(spot)).toList();

      List<Post> localSpotsList = box.get('spotsList').cast<Post>();
      for (Post spot in spotsList) {
        bool missing = true;
        for (int i = 0; i < localSpotsList.length; i++) {
          if (spot.id == localSpotsList[i].id) {
            localSpotsList[i] = spot;
            missing = false;
            break;
          }
        }
        if (missing) {
          localSpotsList.add(spot);
        }
      }

      box.put('spotsList', localSpotsList);
    });
  }

  Post _postFromFirebaseDoc(DocumentSnapshot spot) {
    return Post(spot.get('title'), spot.get('category').cast<String>(),
        spot.get('subcategory').cast<String>(), spot.id, spot.get('active'));
  }

  List<Post> getSpots() {
    var box = Hive.box('box');
    return box.get('spotsList').cast<Post>();
  }
}
