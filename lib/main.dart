import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'api/firebase_api.dart';
import 'firebase_options.dart';
import 'page-1/booked_artist.dart';
import 'package:test1/page-1/page0.dart'; // Ensure this import is correct and points to the right file
// import 'package:test1/page-1/google_map_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white).copyWith(background: Colors.white),
      ),
      navigatorKey: navigatorKey,// Attach the navigator key
      home: Scene(),
    );
  }

}
