import 'package:expense/Pages/SginInPage.dart';
import 'package:expense/Pages/SginUpPage.dart';
import 'package:expense/widget_tree.dart';
import 'package:flutter/material.dart';
import 'Pages/HomePgae.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:expense/auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAAzwQg-1_iWD4X-y7vJoK1lY-9k5S9o4k",
          appId: "1:647646538830:android:79f7f8e28888181c5a271f",
          messagingSenderId: "647646538830",
          projectId: "expense-c2d67"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final User? user = Auth().currentUser;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const WidgetTree(),
      routes: {
        "/homepage": (context) => HomePage(),
        "/sginin": (context) => SginInPage(),
        "/sginup": (context) => SginUpPage(),
      },
    );
  }
}
