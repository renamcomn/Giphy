import 'package:flutter/material.dart';
import 'pages/HomeScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
    theme: ThemeData(hintColor: Colors.white),
  ));
}

