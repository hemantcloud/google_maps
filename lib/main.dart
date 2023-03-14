// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps/map_screen.dart';
import 'package:google_maps/slpash.dart';
import 'package:google_maps/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0)
        ),
      ),
      home: Splash(),
      // home: Test(),
    );
  }
}
