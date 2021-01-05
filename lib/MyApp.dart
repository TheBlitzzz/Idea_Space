import 'package:flutter/material.dart';
import 'package:idea_space/HomePage/Homepage.dart';
import 'package:idea_space/MindMap/MindMap.dart';
import 'Login/Login.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title = "Hello, User";
    ThemeData theme = ThemeData(
      // primarySwatch: Colors.grey,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: title,
      theme: theme,
      home: HomePage(),
    );
  }
}
