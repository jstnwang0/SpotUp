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

  Post(this.title, this.category, this.subcategory, [this.id, this.active = true]);

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
