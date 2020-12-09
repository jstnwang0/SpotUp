import 'dart:async';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final Function closePanel;
  final Function openPanel;

  const Search(this.closePanel, this.openPanel);

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  final List<Post> categories = [
    Post('Picture', 'Picture', null),
    Post('Scenic', 'Scenic', null),
    Post('Eating', 'Eating', null),
    Post('Study', 'Study', null),
    Post('Restrooms', 'Restrooms', null),
    Post('Secluded Areas', 'Secluded_Areas', null),
    Post('Sports', 'Sports', null),
    Post('Workout', 'Workout', null),
  ];

  final List<Post> subcategories = [
    Post('Run Loops', 'Workout', 'Run_Loops'),
    Post('Tennis', 'Sports', 'Tennis'),
    Post('Football', 'Sports', 'Football'),
    Post('Basketball', 'Sports', 'Basketball'),
    Post('Soccer', 'Sports', 'Soccer'),
    Post('Track', 'Sports', 'Track'),
    Post('Spikeball', 'Sports', 'Spikeball'),
    Post('Weed', 'Secluded_Areas', 'Weed'),
    Post('Drinking', 'Secluded_Areas', 'Drinking'),
  ];

  final List<Post> spots = [Post('Memorial Glade', 'Sports', 'Spikeball')];

  List<Post> _defaultList = new List();
  List<Post> _fulllist = new List();
  bool isLoaded = false;

  @override
  void initState() {
    _fulllist = categories + subcategories;
    _fulllist.sort((a, b) => a.category.compareTo(b.category));
    spots.sort((a, b) => a.title.compareTo(b.title));
    _fulllist += spots;

    _defaultList = categories + subcategories;
    _defaultList.sort((a, b) => a.category.compareTo(b.category));

    setState(() {
      isLoaded = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget onItemFound(Post post, int index) {
      Color color =
          post.isCategory() ? Colors.lightBlue : post.isSubcategory() ? Colors.yellow : Colors.red;
      color = color.withOpacity(1);
      return Container(
        height: 100,
        width: 100,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: color),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          title: Center(
              child: Text(
            post.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
            ),
          )),
          onTap: () {
            if (post.isSpot()) {
              widget.openPanel();
            } else {
              _searchBarController.injectSearch(
                  'is:' + post.title.toLowerCase().replaceAll(new RegExp(' '), '_'), _searchPosts);
            }
          },
        ),
      );
    }

    StaggeredTile tileBuilder(Post post) {
      if (post.isCategory()) {
        return new StaggeredTile.extent(3, 80);
      } else {
        return new StaggeredTile.extent(1, 80);
      }
    }

    return new SearchBar<Post>(
      searchBarPadding: EdgeInsets.symmetric(horizontal: 20),
      listPadding: EdgeInsets.symmetric(horizontal: 10),
      searchBarStyle: SearchBarStyle(
        backgroundColor: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.0),
        padding: EdgeInsets.all(6.0),
      ),
      icon: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Icon(Icons.search, color: Colors.white.withOpacity(0.25)),
      ),
      indexedScaledTileBuilder: (int index) => ScaledTile.count(3, 1),
      hintText: 'Search any category or spot',
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.25),
        fontFamily: 'Manrope',
        fontWeight: FontWeight.bold,
      ),
      onSearch: _searchPosts,
      minimumChars: 1,
      searchBarController: _searchBarController,
      cancellationWidget: Text("Cancel"),
      onCancelled: () {},
      crossAxisCount: 3,
      onItemFound: onItemFound,
      suggestions: _defaultList,
      tileBuilder: tileBuilder,
    );
  }

  Future<List<Post>> _searchPosts(String text) async {
    List<Post> searched = []..addAll(_fulllist);
    List<String> textWords = text.split(' ');
    List<String> tags = [];
    List<String> searchWords = [];

    for (int i = 0; i < textWords.length; i++) {
      if (textWords[i].toLowerCase().contains('is:')) {
        tags.add(textWords[i].substring(3));
      } else {
        searchWords.add(textWords[i]);
      }
    }

    for (int i = 0; i < searched.length; i++) {
      Post post = searched[i];

      bool hasTag = tags.isEmpty ? true : false;

      for (String tag in tags) {
        if ((((post.category != null) ? post.category.toLowerCase() == tag : false) ||
                ((post.subcategory != null) ? post.subcategory.toLowerCase() == tag : false)) &&
            post.title.replaceAll(new RegExp(' '), '_').toLowerCase() != tag) {
          hasTag = true;
          break;
        }
      }

      bool hasWord = searchWords.isEmpty ? true : false;
      if (hasTag) {
        for (String word in searchWords) {
          if (post.title.toLowerCase().contains(word.toLowerCase())) {
            hasWord = true;
            break;
          }
        }
        if (!hasWord) {
          searched.removeAt(i);
          i--;
        }
      } else {
        searched.removeAt(i);
        i--;
      }
    }

    return searched;
  }
}

class Post {
  final String title;
  final String category;
  final String subcategory;

  Post(this.title, this.category, this.subcategory);

  bool isCategory() {
    return title.replaceAll(new RegExp(' '), '_') == category;
  }

  bool isSubcategory() {
    return title.replaceAll(new RegExp(' '), '_') == subcategory;
  }

  bool isSpot() {
    return title.replaceAll(new RegExp(' '), '_') != subcategory &&
        title.replaceAll(new RegExp(' '), '_') != category;
  }
}
