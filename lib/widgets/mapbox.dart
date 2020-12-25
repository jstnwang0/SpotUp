import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:spot_up/models/post.dart';
import 'package:user_location/user_location.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  List<Post> spots = [];

  Map(this.spots);

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  List<Marker> locationMarker = [];
  List<Marker> markers = [];
  static final LatLng _ucb = LatLng(37.871900, -122.258540);

  @override
  Widget build(BuildContext context) {
    markers = widget.spots
        .map((spot) => new Marker(
            point: LatLng(spot.latitude, spot.longitude),
            builder: (ctx) => Image(image: AssetImage('assets/location_pin.png'))))
        .toList();
    userLocationOptions = UserLocationOptions(
        context: context,
        mapController: mapController,
        markers: locationMarker,
        updateMapLocationOnPositionChange: false,
        zoomToCurrentLocationOnLoad: true,
        showMoveToCurrentLocationFloatingActionButton: true,
        showHeading: true,
        fabBottom: MediaQuery.of(context).size.height - 60,
        moveToCurrentLocationFloatingActionButton: Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10.0)]),
          child: Icon(
            Icons.my_location,
            color: Colors.white,
          ),
        ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: new FlutterMap(
          options: new MapOptions(
            center: _ucb,
            zoom: 13.0,
            maxZoom: 18.49999,
            minZoom: 10,
            plugins: [
              UserLocationPlugin(),
              MarkerClusterPlugin(),
            ],
          ),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/protolate/ckiptnx6210r517qioccfmjjt/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJvdG9sYXRlIiwiYSI6ImNraW94NGFsMjA1bGgycmxrMjVhZGF1dnUifQ.XS5vhJrBFOd5sEg9bn3Y-Q',
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoicHJvdG9sYXRlIiwiYSI6ImNraW94NGFsMjA1bGgycmxrMjVhZGF1dnUifQ.XS5vhJrBFOd5sEg9bn3Y-Q',
                  'id': 'mapbox.mapbox-streets-v8'
                }),
            MarkerClusterLayerOptions(
              maxClusterRadius: 75,
              anchor: AnchorPos.align(AnchorAlign.center),
              size: Size(40, 40),
              fitBoundsOptions: FitBoundsOptions(
                padding: EdgeInsets.all(50),
              ),
              markers: markers,
              builder: (context, markers) {
                return Stack(alignment: Alignment.center, children: <Widget>[
                  Image(image: AssetImage('assets/location_pin.png')),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 17.5),
                    child: Text(markers.length.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold)),
                  ),
                ]);
              },
            ),
            MarkerLayerOptions(markers: locationMarker),
            userLocationOptions
          ],
          mapController: mapController),
    );
  }
}
