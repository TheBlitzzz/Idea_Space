import 'package:flutter/material.dart';
import 'Login/Login.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      primarySwatch: Colors.grey,
      brightness: Brightness.dark,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.grey,
      ),
    );

    return MaterialApp(
      theme: theme,
      home: Login(),
    );
  }
}
