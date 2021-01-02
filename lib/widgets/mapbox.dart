import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:spot_up/constants/constants.dart';
import 'package:spot_up/models/post.dart';
import 'package:user_location/user_location.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class Mapbox extends StatefulWidget {
  List<Marker> markers = [];
  Function openSpotForm;

  Marker testMarker;

  Mapbox({this.markers, this.openSpotForm, this.testMarker, Key key}) : super(key: key);

  @override
  State<Mapbox> createState() => MapboxState();
}

class MapboxState extends State<Mapbox> {
  MapController mapController = MapController();
  List<Marker> locationMarker = [];
  static final LatLng _ucb = LatLng(37.871900, -122.258540);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.add_location_rounded),
          onPressed: () {
            widget.openSpotForm();
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: new FlutterMap(
          options: new MapOptions(
            center: _ucb,
            zoom: 13.0,
            maxZoom: 18.49999,
            minZoom: 5,
            plugins: [
              UserLocationPlugin(),
              MarkerClusterPlugin(),
            ],
          ),
          layers: [
            //Tile Layer
            TileLayerOptions(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/protolate/ckiptnx6210r517qioccfmjjt/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJvdG9sYXRlIiwiYSI6ImNraW94NGFsMjA1bGgycmxrMjVhZGF1dnUifQ.XS5vhJrBFOd5sEg9bn3Y-Q',
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoicHJvdG9sYXRlIiwiYSI6ImNraW94NGFsMjA1bGgycmxrMjVhZGF1dnUifQ.XS5vhJrBFOd5sEg9bn3Y-Q',
                  'id': 'mapbox.mapbox-streets-v8'
                }),
            //Clustered Marker Layer
            MarkerClusterLayerOptions(
              maxClusterRadius: 75,
              anchor: AnchorPos.align(AnchorAlign.top),
              size: Size(40, 40),
              fitBoundsOptions: FitBoundsOptions(
                padding: EdgeInsets.all(50),
              ),
              markers: widget.markers,
              builder: (context, markers) {
                return Stack(alignment: Alignment.center, children: <Widget>[
                  Image(image: AssetImage('assets/location_pin.png')),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 17.5),
                    child: Text(markers.length.toString(), style: textStyle.copyWith(fontSize: 12)),
                  ),
                ]);
              },
            ),
            //Current location marker
            MarkerLayerOptions(markers: locationMarker),
            //Options for current location
            UserLocationOptions(
              context: context,
              mapController: mapController,
              markers: locationMarker,
              updateMapLocationOnPositionChange: false,
              zoomToCurrentLocationOnLoad: true,
              showMoveToCurrentLocationFloatingActionButton: true,
              showHeading: true,
              fabBottom: MediaQuery.of(context).size.height - 175,
              moveToCurrentLocationFloatingActionButton: Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10.0)]),
                child: Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          mapController: mapController),
    );
  }

  LatLng get center {
    return mapController.center;
  }

  bool notNull(Object o) => o != null;
}
