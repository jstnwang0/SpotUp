import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spot_up/widgets/gmap.dart';
import 'side_nav.dart';
import '../main.dart';

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
        //this is the sliding panel
        drawer: SideNav(),
        body: SlidingUpPanel(
          panel: Column(
            // Change to better wrapper
            children: [
              buildDragIcon(),
              buildScrollingMenu(),
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
