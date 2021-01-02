import 'dart:async';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:spot_up/services/spot_database.dart';
import 'package:spot_up/models/post.dart';
import 'package:spot_up/constants/constants.dart';

class Search extends StatefulWidget {
  final Function closeInfoPanel;
  final Function openInfoPanel;
  final Function setMarkers;
  final Function clearMarkers;
  final Function onSearchTap;

  const Search(
      {this.closeInfoPanel,
      this.openInfoPanel,
      this.setMarkers,
      this.clearMarkers,
      this.onSearchTap});

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  final SearchBarController<Post> _searchBarController = SearchBarController();

  List<Post> spots = SpotDatabase().getActiveSpots();

  List<Post> _defaultList = new List();
  List<Post> _fulllist = new List();
  bool isLoaded = false;

  @override
  void initState() {
    _fulllist = categories + subcategories;
    _fulllist.sort((a, b) => a.category[0].compareTo(b.category[0]));
    spots.sort((a, b) => a.title.compareTo(b.title));
    _fulllist += spots;

    _defaultList = categories + subcategories;
    _defaultList.sort((a, b) => a.category[0].compareTo(b.category[0]));

    setState(() {
      isLoaded = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget onItemFound(Post post, int index) {
      Color color = post.isCategory()
          ? Colors.lightBlue
          : post.isSubcategory
              ? Colors.yellow
              : Colors.red;
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
              widget.openInfoPanel();
            } else {
              _searchBarController.injectSearch(
                  'is:' + (post.isSubcategory ? post.subcategory[0] : post.category[0]),
                  _searchPosts);
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
        debounceDuration: Duration(milliseconds: 100),
        minimumChars: 1,
        searchBarController: _searchBarController,
        cancellationWidget: Text("Cancel"),
        onCancelled: () {
          widget.clearMarkers();
        },
        crossAxisCount: 3,
        onItemFound: onItemFound,
        suggestions: _defaultList,
        tileBuilder: tileBuilder,
        onTap: widget.onSearchTap);
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

      bool hasTag = true;

      for (String tag in tags) {
        if (!((post.category.contains(tag) || post.subcategory.contains(tag)) &&
            post.title.replaceAll(new RegExp(' '), '_').toLowerCase() != tag)) {
          hasTag = false;
          break;
        }
      }

      bool hasWord = searchWords.isEmpty ? true : false;
      if (hasTag && !hasWord) {
        for (String word in searchWords) {
          if (post.title.toLowerCase().contains(word.toLowerCase())) {
            hasWord = true;
            break;
          }
        }
      }
      if (!(hasTag && hasWord)) {
        searched.removeAt(i);
        i--;
      }
    }

    widget.setMarkers(searched);
    return searched;
  }
}
