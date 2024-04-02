 // 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test1/page-1/page0.dart';
import 'package:test1/page-1/dmeo.dart';
import 'package:test1/page-1/bottom_nav.dart';





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
      title: 'Artista',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Scene(),
      // const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


