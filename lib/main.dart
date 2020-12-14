import 'package:flutter/material.dart';
import 'package:spot_up/models/post.dart';
import 'package:spot_up/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spot_up/services/database.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(PostAdapter());

  await Hive.openBox('box');
  await DatabaseService().updateData();

  runApp(MyApp());
}

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
