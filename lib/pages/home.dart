import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spot_up/constants/constants.dart';
import 'package:spot_up/models/user.dart';
import 'package:spot_up/pages/spot_form.dart';
import 'package:spot_up/services/spot_database.dart';
import 'package:spot_up/widgets/mapbox.dart';
import 'package:spot_up/widgets/search.dart';
import 'package:spot_up/models/post.dart';
import 'package:geodesy/geodesy.dart';
import 'side_nav.dart';
import '../main.dart';
import 'dart:ui';

final key = new GlobalKey<MapboxState>();

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
  final PanelController _formPanelController = PanelController();
  final PanelController _searchPanelController = PanelController();

  double searchPanelPosition = 1;
  double formPanelPosition = 1;
  double infoPanelPosition = 1;

  Widget formPanelBody;

  Widget dragMarkerController;
  Widget dragMarker;
  LatLng dragLocation;

  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: SideNav(signOut: widget.signOut, user: widget.user),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          //Map
          Mapbox(
              key: key,
              markers: markers +
                  [
                    Marker(
                        anchorPos: AnchorPos.align(AnchorAlign.top),
                        width: 20,
                        point: dragLocation,
                        builder: (ctx) => Image(image: AssetImage('assets/new_location_pin.png')))
                  ],
              openSpotForm: _formPanelController.open),
          //Search bar panel
          SlidingUpPanel(
            panel: Column(
              children: [
                buildDragIcon(),
                //Search bar inside of panel
                Expanded(
                    child: Search(
                  closeInfoPanel: _infoPanelController.close,
                  openInfoPanel: _infoPanelController.open,
                  setMarkers: setMarkers,
                  clearMarkers: clearMarkers,
                  onSearchTap: _searchPanelController.open,
                )),
              ],
            ),
            controller: _searchPanelController,
            color: Colors.grey[850].withOpacity(0.925),
            minHeight: 95,
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
            onPanelSlide: (double position) {
              if (position < searchPanelPosition) {
                FocusManager.instance.primaryFocus.unfocus();
              }
              searchPanelPosition = position;
            },
          ),
          //New spot form panel
          SlidingUpPanel(
            panel: Column(
              children: [
                buildDragIcon(),
                SpotForm(
                  dragLocation: dragLocation,
                  clearDragLocation: clearDragLocation,
                  closePanel: _formPanelController.close,
                  setLocation: setLocation,
                ),
              ].where(notNull).toList(),
            ),
            controller: _formPanelController,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
            color: Colors.grey[900].withOpacity(0.975),
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            defaultPanelState: PanelState.CLOSED,
            onPanelSlide: (double position) {
              if (position < formPanelPosition) {
                FocusManager.instance.primaryFocus.unfocus();
              }
              formPanelPosition = position;
            },
          ),
          //Info panel for spots
          SlidingUpPanel(
            panel: Column(
              children: [
                buildDragIcon(),
              ],
            ),
            controller: _infoPanelController,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
            color: Colors.grey[900].withOpacity(0.975),
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            defaultPanelState: PanelState.CLOSED,
            onPanelSlide: (double position) {
              if (position < infoPanelPosition) {
                FocusManager.instance.primaryFocus.unfocus();
              }
              infoPanelPosition = position;
            },
          ),
          //Controller for drag marker
          dragMarkerController,
          dragMarker,
        ].where(notNull).toList(),
      ),
    );
  }

  bool notNull(Object o) => o != null;

  void setMarkers(List<Post> spots) {
    spots = spots.where((spot) => spot.isSpot()).toList();
    setState(() {
      markers = spots
          .map((spot) => Marker(
              anchorPos: AnchorPos.align(AnchorAlign.top),
              width: 20,
              point: spot.getLatLng(),
              builder: (ctx) => Image(image: AssetImage('assets/location_pin.png'))))
          .toList();
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

  void clearDragLocation() {
    setState(() {
      dragLocation = null;
    });
  }

  String checkSpotDistance(LatLng newSpotLocation) {
    List allSpots = SpotDatabase().getActiveSpots();
    Geodesy geodesy = Geodesy();
    print(newSpotLocation);
    allSpots = allSpots
        .map((spot) =>
            [spot.title, geodesy.distanceBetweenTwoGeoPoints(spot.getLatLng(), newSpotLocation)])
        .toList();
    print('here');
    allSpots.sort((a, b) => a[1].compareTo(b[1]));

    if (allSpots.first[1] < 30) {
      return 'This spot is only ${allSpots.first[1].round()} meters from ${allSpots.first[0]}. Make sure this is not a duplicate.';
    }
    return null;
  }

  void setLocation() {
    List<Marker> tempMarkers = List.from(markers);
    setMarkers(SpotDatabase().getActiveSpots());

    setState(() {
      dragMarker = Center(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Image(
          image: AssetImage('assets/location_pin.png'),
          height: 30,
        ),
      ));

      dragMarkerController = Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonTheme(
              minWidth: 0,
              child: RaisedButton(
                color: Colors.deepPurple,
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    dragMarker = null;
                    dragMarkerController = null;
                    markers = tempMarkers;
                    _formPanelController.open();
                  });
                },
              ),
            ),
            ButtonTheme(
              minWidth: 0,
              child: RaisedButton(
                color: Colors.deepPurple,
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                onPressed: () async {
                  String closestSpotMessage = checkSpotDistance(key.currentState.center);
                  bool duplicate = false;
                  if (closestSpotMessage != null) {
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Possible Duplicate'),
                          backgroundColor: Colors.deepPurple,
                          titleTextStyle: textStyle.copyWith(fontSize: 20),
                          contentTextStyle: textStyle.copyWith(fontWeight: FontWeight.normal),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(closestSpotMessage),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.white, backgroundColor: Colors.deepPurple),
                              child: Text('Yes it is'),
                              onPressed: () {
                                duplicate = true;
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.white, backgroundColor: Colors.deepPurple),
                              child: Text('No it\'s not'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }

                  if (!duplicate) {
                    setState(() {
                      dragLocation = key.currentState.center;
                      dragMarker = null;
                      dragMarkerController = null;
                      markers = tempMarkers;
                      _formPanelController.open();
                    });
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
