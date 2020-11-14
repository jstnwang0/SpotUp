import 'dart:async';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  final SearchBarController<Post> _searchBarController = SearchBarController();

  @override
  Widget build(BuildContext context) {
    return new SearchBar<Post>(
      searchBarPadding: EdgeInsets.symmetric(horizontal: 20),
      headerPadding: EdgeInsets.symmetric(horizontal: 10),
      listPadding: EdgeInsets.symmetric(horizontal: 10),
      searchBarStyle: SearchBarStyle(
        borderRadius: BorderRadius.circular(20.0),
        padding: EdgeInsets.all(2.0),
      ),
      icon: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Icon(Icons.search),
      ),
      hintText: 'Search any category',
      hintStyle: TextStyle(
        fontFamily: 'Manrope',
        fontWeight: FontWeight.bold,
      ),
      onSearch: _getAllPosts,
      minimumChars: 1,
      searchBarController: _searchBarController,
      placeHolder: null,
      header: null,
      cancellationWidget: Text("Cancel"),
      // indexedScaledTileBuilder: (int index) =>
      //     ScaledTile.count(1, index.isEven ? 2 : 1),
      onCancelled: () {
        print("Cancelled triggered");
      },
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      crossAxisCount: 3,
      onItemFound: (Post post, int index) {
        return Container(
          height: 100,
          width: 100,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.lightBlue,
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ListTile(
            title: Center(
                child: Text(
              post.title,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
              ),
            )),
            onTap: () {},
          ),
        );
      },
    );
  }

  Future<List<Post>> _getAllPosts(String text) async {
    List<Post> posts = [
      Post('Workout', 'TestBody'),
      Post('Sports', 'TestBody1'),
      Post('Secluded Areas', 'TestBody2'),
      Post('Picture', 'TestBody3')
    ];

    return posts;
  }
}

class Post {
  final String title;
  final String body;

  Post(this.title, this.body);
}
