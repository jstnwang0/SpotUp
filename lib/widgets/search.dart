import 'dart:async';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  final List<Post> posts = [
    Post('Workout', 'TestBody'),
    Post('Sports', 'TestBody1'),
    Post('Secluded Areas', 'TestBody2'),
    Post('Picture', 'TestBody3')
  ];

  final crossAxisCount = 3;

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
      onSearch: _searchPosts,
      minimumChars: 1,
      searchBarController: _searchBarController,
      placeHolder: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: crossAxisCount,
          itemCount: posts.length,
          staggeredTileBuilder: (int index) => ScaledTile.fit(1),
          itemBuilder: (BuildContext context, int index) {
            return onItemFound(posts[index], index);
          },
        ),
      ),
      cancellationWidget: Text("Cancel"),
      onCancelled: () {
        print("Cancelled triggered");
      },
      crossAxisCount: crossAxisCount,
      onItemFound: onItemFound,
    );
  }

  Future<List<Post>> _searchPosts(String text) async {
    List<Post> searched = [];
    for (Post post in posts) {
      if (post.title.toLowerCase().contains(text.toLowerCase())) {
        searched.add(post);
      }
    }
    return searched;
  }

  Widget onItemFound(Post post, int index) {
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
  }
}

class Post {
  final String title;
  final String body;

  Post(this.title, this.body);
}
