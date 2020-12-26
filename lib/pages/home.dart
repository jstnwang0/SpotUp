import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spot_up/constants/constants.dart';
import 'package:spot_up/models/user.dart';
import 'package:spot_up/widgets/mapbox.dart';
import 'package:spot_up/widgets/search.dart';
import 'package:spot_up/models/post.dart';
import 'side_nav.dart';
import '../main.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  final Function signOut;
  final LocalUser user;

  HomePage({this.signOut, this.user});
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final bool openWithKeyboard = false;
  final PanelController _infoPanelController = PanelController();
  final PanelController _searchPanelController = PanelController();
  List<Post> markers = [];
  double panelPosition = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: SideNav(signOut: widget.signOut, user: widget.user),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SlidingUpPanel(
            panel: Column(
              children: [
                buildDragIcon(),
                Expanded(
                    child: Search(
                  closeInfoPanel: closeInfoPanel,
                  openInfoPanel: openInfoPanel,
                  setMarkers: setMarkers,
                  clearMarkers: clearMarkers,
                  onSearchTap: openSearchPanel,
                )),
              ],
            ),
            controller: _searchPanelController,
            body: Map(markers),
            color: Colors.grey[850].withOpacity(0.925),
            minHeight: 95,
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
            onPanelSlide: (double position) {
              if (position < panelPosition) {
                FocusManager.instance.primaryFocus.unfocus();
              }
              panelPosition = position;
            },
          ),
          SlidingUpPanel(
              panel: Column(
                children: [
                  buildDragIcon(),
                ],
              ),
              controller: _infoPanelController,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
              color: Colors.grey[900],
              minHeight: 0,
              maxHeight: 350,
              defaultPanelState: PanelState.CLOSED)
        ],
      ),
    );
  }

  Future<void> closeInfoPanel() {
    return _infoPanelController.close();
  }

  Future<void> openInfoPanel() {
    return _infoPanelController.open();
  }

  void openSearchPanel() {
    if (_searchPanelController.isPanelClosed) {
      _searchPanelController.open();
    }
  }

  void closeSearchPanel() {
    _searchPanelController.close();
  }

  void setMarkers(List<Post> spots) {
    spots = spots.where((spot) => spot.isSpot()).toList();
    setState(() {
      markers = spots;
    });
  }

  void clearMarkers() async {
    setState(() {
      markers = [];
    });
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
