import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:latlong/latlong.dart';

part 'post.g.dart';

@HiveType(typeId: 0)
class Post {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final List<String> category;

  @HiveField(2)
  final List<String> subcategory;

  @HiveField(3)
  final bool active;

  @HiveField(4)
  final String id;

  @HiveField(5)
  final double latitude;

  @HiveField(6)
  final double longitude;

  final bool isSubcategory;

  Post(
      {this.title,
      this.category,
      this.subcategory = const [],
      this.id,
      this.active = true,
      this.latitude,
      this.longitude,
      this.isSubcategory = false});

  bool isCategory() {
    return category.contains(title.replaceAll(new RegExp(' '), '_').toLowerCase());
  }

  bool isSpot() {
    return !isCategory() && !isSubcategory;
  }

  LatLng getLatLng() {
    return LatLng(latitude, longitude);
  }
}
