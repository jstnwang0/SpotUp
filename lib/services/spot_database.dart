import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spot_up/constants/constants.dart';
import '../models/post.dart';

class SpotDatabase {
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
    List<String> subcategories = spot.get('subcategory').cast<String>();
    List<String> categories = [];

    for (String subcategory in subcategories) {
      String category = subCategoriesMap[subcategory].category[0];
      if (!categories.contains(category)) {
        categories.add(category);
      }
    }

    return Post(
        title: spot.get('title'),
        category: categories,
        subcategory: subcategories,
        id: spot.id,
        active: spot.get('active'),
        latitude: spot.get('location').latitude,
        longitude: spot.get('location').longitude);
  }

  List<Post> getActiveSpots() {
    var box = Hive.box('box');
    List<Post> spots = box.get('spotsList').cast<Post>();
    spots = spots.where((spot) => spot.active).toList();
    return spots;
  }

  List<Post> getInactiveSpots() {
    var box = Hive.box('box');
    List<Post> spots = box.get('spotsList').cast<Post>();
    spots = spots.where((spot) => !spot.active).toList();
    return spots;
  }
}
