import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/bottomNav_artist.dart';
import 'package:test1/page-1/bottom_nav.dart';
import 'api/firebase_api.dart';
import 'firebase_options.dart';
import 'package:test1/page-1/page0.dart'; // Ensure this import is correct

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterSecureStorage secureStorage = FlutterSecureStorage();
bool authorised = false; // Default value for authorised
String selectedValue = ''; // Holds the selected value from secure storage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize Firebase and notifications
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseApi().initNotification();
  } catch (e) {
    // Handle initialization error
    print("Error initializing Firebase: $e");
  }

  // Read authorised status and selectedValue from secure storage
  String? authStatus;
  try {
    authStatus = await secureStorage.read(key: 'authorised');
  } catch (e) {
    print("Error reading from secure storage: $e");
  }

  authorised = authStatus != null && authStatus == 'true'; // Check if user is authorised
  if (authorised) {
    selectedValue = await secureStorage.read(key: 'selected_value') ?? ''; // Read selectedValue
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
        scaffoldBackgroundColor: Colors.white, // Background color
        useMaterial3: true,
        cardTheme: CardTheme(
          color: Color(0xFFFEFEFE),   // White card color
          shadowColor: Color(0xFFE9E8E6).withOpacity(0.4),  // Shadow color
          surfaceTintColor: Colors.transparent,  // No surface tint
          elevation: 300,  // Elevation
          margin: EdgeInsets.all(16),  // Margin
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),  // Rounded corners
          ),
          clipBehavior: Clip.antiAlias,  // Clipping behavior
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor:Color(0xFFFEFEFE),  // AppBar background color
          foregroundColor: Color(0xFFFEFEFE),  // AppBar text color
          elevation: 0, // No elevation
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white), // White icons
          actionsIconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          toolbarHeight: kToolbarHeight,
          toolbarTextStyle: TextStyle(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)
            .copyWith(background: Colors.white),
      ),
      navigatorKey: navigatorKey, // Navigator key for navigation
      home: _getHomePage(), // Decide which page to load
    );
  }

  Widget _getHomePage() {
    if (!authorised) {
      return Scene(); // Load login scene if not authorised
    }
    if (selectedValue == 'hire') {
      return BottomNav(); // Load BottomNav for "hire"
    } else if (selectedValue == 'solo_artist' || selectedValue == 'team') {
      return BottomNavart(data: {}); // Load BottomNav for "solo artist" or "team"
    } else {
      return Scene(); // Default to Scene if no matching value
    }
  }
}

// Example pages with custom System UI overlay styles
class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark, // Dark system UI for light content
      child: Scaffold(
        appBar: AppBar(
          title: Text('Example Page'),
        ),
        body: Center(child: Text('White page content')),
      ),
    );
  }
}

class BlackBackgroundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // Light system UI for dark content
      child: Scaffold(
        appBar: AppBar(
          title: Text('Black Page'),
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Center(child: Text('Black page content', style: TextStyle(color: Colors.white))),
        ),
      ),
    );
  }
}
