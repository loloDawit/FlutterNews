import 'package:flutter/material.dart';
import './pages/homefeed.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new HomePageFeed(title: 'Flutter Demo Home Page'),
    );
  }
}

