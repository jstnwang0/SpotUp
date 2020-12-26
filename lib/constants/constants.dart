import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
  ),
);

AppBar appBar = AppBar(
  title: Text(
    'Spot Up',
    style: TextStyle(
      color: Colors.white,
      fontFamily: 'Manrope',
      fontWeight: FontWeight.bold,
    ),
  ),
  centerTitle: true,
  elevation: 0,
  backgroundColor: Colors.deepPurple,
);

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.deepPurple,
          size: 25.0,
        ),
      ),
    );
  }
}
