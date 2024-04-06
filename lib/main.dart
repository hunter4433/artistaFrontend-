import 'package:flutter/material.dart';
import 'package:test1/page-1/page0.dart';






void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artista',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set scaffold background color to white
        useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.white).copyWith(background: Colors.white),
      ),
      home: Scene(),
    );
  }
}


