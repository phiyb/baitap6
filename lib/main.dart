import 'package:baitap6/screens/login.dart';
import 'package:baitap6/screens/profile_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      routes: {
        "/profilescreen":(context)=>ProfileScreen()
      },
      home: LoginScreen(),
    );
  }
}

