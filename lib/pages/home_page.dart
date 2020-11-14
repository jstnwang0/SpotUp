import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spot_up/widgets/gmap.dart';
import 'package:spot_up/widgets/search.dart';
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
              Expanded(child: Search()),
            ],
          ),
          body: Map(),
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0), bottom: Radius.zero),
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
}
