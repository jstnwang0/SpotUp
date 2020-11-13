import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spot_up/widgets/gmap.dart';
import 'side_nav.dart';
import '../main.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double tabBarHeight = 40;
  final brandcolor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: brandcolor,
        ),
        //this is the left sidesliding panel
        drawer: SideNav(),
        body: SlidingUpPanel(
          panel: Column(
            children: [
              buildDragIcon(),
              //This is where I start editting the search bar
              AppBar(
                title: Text("Search"),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: DataSearch(),
                        );
                      })
                ],
              ),
            ],
          ),
          body: MapSample(),
          borderRadius: BorderRadius.circular(30),
        ),
      );

  Widget buildDragIcon() => Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      width: 50,
      height: 8,
      margin: EdgeInsets.symmetric(vertical: 6.0));

  Widget buildScrollingMenu() => Container(
        margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        height: 40.0,
        child: ListView(
          children: <Widget>[
            Container(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    'Secluded Areas',
                    'study spots',
                    'fitness',
                    'swimming idfk',
                  ]
                      .map((e) => Container(
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              e,
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            color: Colors.deepPurple,
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 6.0)))
                      .toList(),
                ))
          ],
        ),
      );
}

class DataSearch extends SearchDelegate<String> {
  final categories = [
    "Fitness",
    "Secluded Areas",
    "Smoke Spots",
    "Instagram",
    "Study Spots",
    "Eating Spots",
    "Restrooms",
  ];

  final recentCategories = [
    "Secluded Areas",
    "Smoke Spots",
    "Instagram",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar'
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some results based on the selection
    return Card(
        color: Colors.deepPurple,
        shape: StadiumBorder(),
        child: Center(
          child: Text(query),
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for for something
    final suggestionList = query.isEmpty
        ? recentCategories
        : categories.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
