import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Spot Up',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 1,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Hello World'),
          RaisedButton(
              onPressed: () {},
              child: Text(
                'Raised Button',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Manrope',
                ),
              ),
              color: Colors.deepPurple)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.add_location,
          size: 30,
        ),
      ),
    );
  }
}
