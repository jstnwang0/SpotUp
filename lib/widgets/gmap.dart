import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  static final CameraPosition _ucb = CameraPosition(
    target: LatLng(37.871900, -122.258540),
    zoom: 15,
  );

  GoogleMapController _mapController;

  void _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _mapController.setMapStyle(style);
  }

  void _currentLocation() async {
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 15.0,
      ),
    ));
  }

  void _onMapCreated(GoogleMapController _controller) {
    _mapController = _controller;
    setState(() {});
    _setMapStyle();
    // _location.onLocationChanged.listen((l) {
    //   _mapController.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
    //     ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: _ucb,
        onMapCreated: _onMapCreated,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        padding: EdgeInsets.only(bottom: 175, top: 0, right: 0, left: 0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _currentLocation,
        child: Icon(Icons.near_me),
        mini: true,
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
