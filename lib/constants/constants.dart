import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spot_up/models/post.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
  ),
);

const textStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Manrope',
  fontWeight: FontWeight.bold,
);

AppBar appBar = AppBar(
  title: Text(
    'Spot Up',
    style: textStyle,
  ),
  centerTitle: true,
  elevation: 0,
  backgroundColor: Colors.deepPurple,
);

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.deepPurple,
          size: 25.0,
        ),
      ),
    );
  }
}

final List<Post> categories = [
  Post(title: 'Picture', category: ['picture']),
  Post(title: 'Scenic', category: ['scenic']),
  Post(title: 'Eating', category: ['eating']),
  Post(title: 'Study', category: ['study']),
  Post(title: 'Restrooms', category: ['restrooms']),
  Post(title: 'Secluded Areas', category: ['secluded_areas']),
  Post(title: 'Sports', category: ['sports']),
  Post(title: 'Workout', category: ['workout']),
];

final List<Post> subcategories = [
  Post(title: 'Tables', category: ['study'], subcategory: ['study_tables'], isSubcategory: true),
  Post(title: 'Tables', category: ['eating'], subcategory: ['eating_tables'], isSubcategory: true),
  Post(title: 'Run Loops', category: ['workout'], subcategory: ['run_loops'], isSubcategory: true),
  Post(title: 'Tennis', category: ['sports'], subcategory: ['tennis'], isSubcategory: true),
  Post(title: 'Football', category: ['sports'], subcategory: ['football'], isSubcategory: true),
  Post(title: 'Basketball', category: ['sports'], subcategory: ['basketball'], isSubcategory: true),
  Post(title: 'Soccer', category: ['sports'], subcategory: ['soccer'], isSubcategory: true),
  Post(title: 'Track', category: ['sports'], subcategory: ['track'], isSubcategory: true),
  Post(title: 'Spikeball', category: ['sports'], subcategory: ['spikeball'], isSubcategory: true),
  Post(title: 'Weed', category: ['secluded_areas'], subcategory: ['weed'], isSubcategory: true),
  Post(
      title: 'Drinking',
      category: ['secluded_areas'],
      subcategory: ['drinking'],
      isSubcategory: true),
];

Map<String, Post> categoriesMap =
    Map.fromIterable(categories, key: (item) => item.category[0], value: (item) => item);

Map<String, Post> subCategoriesMap =
    Map.fromIterable(subcategories, key: (item) => item.subcategory[0], value: (item) => item);
