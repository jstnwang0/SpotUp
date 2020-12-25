import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

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

  Post(
      {this.title,
      this.category,
      this.subcategory = const [],
      this.id,
      this.active = true,
      this.latitude,
      this.longitude});

  bool isCategory() {
    return category.contains(title.replaceAll(new RegExp(' '), '_').toLowerCase());
  }

  bool isSubcategory() {
    return subcategory.contains(title.replaceAll(new RegExp(' '), '_').toLowerCase());
  }

  bool isSpot() {
    return !isCategory() && !isSubcategory();
  }
}
