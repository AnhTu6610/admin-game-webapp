import 'package:admin_game/views/authen_screen.dart';
import 'package:flutter/material.dart';
import 'package:admin_game/views/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trival Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/authen': (context) => AuthenScreen(),
      },
    );
  }
}
