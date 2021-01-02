import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spot_up/models/post.dart';
import 'package:spot_up/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spot_up/pages/wrapper.dart';
import 'package:spot_up/services/auth.dart';
import 'package:spot_up/services/spot_database.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(PostAdapter());

  await Hive.openBox('box');
  await SpotDatabase().updateData();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Spot Up';
  static final brandcolor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
            primaryColor: Colors.white,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.deepPurple,
              textTheme: ButtonTextTheme.primary,
            )),
        home: Wrapper(),
      );
}
