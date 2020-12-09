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

  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    Future<void> closePanel() {
      return _panelController.close();
    }

    Future<void> openPanel() {
      return _panelController.open();
    }

    return Scaffold(
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
      // extendBodyBehindAppBar: true,
      drawer: SideNav(),
      body: Stack(
        children: [
          SlidingUpPanel(
              panel: Column(
                children: [
                  buildDragIcon(),
                  Expanded(child: Search(closePanel, openPanel)),
                ],
              ),
              body: Map(),
              color: Colors.grey[850].withOpacity(0.95),
              minHeight: 100,
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
              defaultPanelState: PanelState.OPEN),
          SlidingUpPanel(
              panel: Column(
                children: [
                  buildDragIcon(),
                ],
              ),
              controller: _panelController,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
              color: Colors.grey[900],
              minHeight: 0,
              maxHeight: 350,
              defaultPanelState: PanelState.CLOSED)
        ],
      ),
    );
  }

  Widget buildDragIcon() => Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      width: 50,
      height: 8,
      margin: EdgeInsets.fromLTRB(0, 8, 0, 0));
}
