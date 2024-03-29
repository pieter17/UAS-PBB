import 'package:flutter/material.dart';
import 'package:football_info/theme.dart';
import './screens/home-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football - Info',
      theme: myTheme,
      initialRoute: '/',
      routes: {'/': (ctx) => HomeScreen()},
    );
  }
}
