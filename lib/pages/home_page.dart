import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spot_up/widgets/gmap.dart';
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
        body: SlidingUpPanel(
          panel: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              height: 5.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 160.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.blue,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.green,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.yellow,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
          body: MapSample(),
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
