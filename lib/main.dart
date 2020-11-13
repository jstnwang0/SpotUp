import 'package:flutter/material.dart';
import 'package:spot_up/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = 'Spot Up';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primaryColor: Colors.white),
        home: Scaffold(
          body: HomePage(),
        ),
      );
}
