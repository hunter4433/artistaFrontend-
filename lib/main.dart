import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/bottomNav_artist.dart';
import 'package:test1/page-1/bottom_nav.dart';
import 'api/firebase_api.dart';
import 'firebase_options.dart';
import 'package:test1/page-1/page0.dart'; // Ensure this import is correct and points to the right file

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterSecureStorage secureStorage = FlutterSecureStorage();
bool authorised = false; // Declare the authorised variable and set its default value to false
String selectedValue = ''; // Declare selectedValue to store the value from secure storage

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();

  // Read the authorised value from secure storage
  String? authStatus = await secureStorage.read(key: 'authorised');
  if (authStatus != null && authStatus == 'true') {
    authorised = true;

    // Read the selected_value from secure storage
    selectedValue = await secureStorage.read(key: 'selected_value') ?? '';
  } else {
    authorised = false;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      navigatorKey: navigatorKey, // Attach the navigator key
      home: _getHomePage(), // Check authorised and selected_value before navigating
    );
  }

  Widget _getHomePage() {
    if (!authorised) {
      return Scene();
    }
    if (selectedValue == 'hire') {
      return BottomNav(data: {},); // Home page for "hire"
    } else if (selectedValue == 'solo_artist' || selectedValue == 'team') {
      return BottomNavart(data: {},); // Home page for "solo artist" or "team"
    } else {
      return Scene(); // Fallback to Scene if no matching selected_value
    }
  }
}

