import 'package:flutter/material.dart';
import 'package:SubClean/Login.dart';
import 'package:SubClean/HomePage.dart';
import 'user.dart' as global;

void main() {
  runApp(SubClean());
}

class SubClean extends StatelessWidget {
  final appTitle = 'SubClean';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        //'/login': (context) => LoginScreen(),
      },
    );
  }
}
