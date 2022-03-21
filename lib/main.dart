import 'package:flutter/material.dart';

import 'Login/Login.dart';

void main() {
  runApp(MyApp());
}

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
      initialRoute: "/login",
      routes: {
        "/login": (context) => Login(),
      },
    );
  }
}
