import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
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
        cardTheme: CardTheme(
          color: Color(0xFFFEFEFE),   // Set the card color to pure white
          shadowColor: Color(0xFFE9E8E6).withOpacity(0.4),  // Custom shadow color
          surfaceTintColor: Colors.transparent,  // Disable any surface tint color
          elevation: 300,  // Set the desired elevation
          margin: EdgeInsets.all(16),  // Add margin if needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),  // Rounded corners for the card
          ),
          clipBehavior: Clip.antiAlias,  // Optional: Clip the card's content for better rendering
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor:Color(0xFFFEFEFE),  // Set the AppBar background color to the desired value
          foregroundColor: Color(0xFFFEFEFE),  // Set the foreground color for icons and text
          elevation: 0, // Remove elevation to prevent any shadow effect
          scrolledUnderElevation: 0, // Ensure no elevation when scrolled
          shadowColor: Colors.transparent, // Set shadow color to transparent to avoid any shadow effect
          surfaceTintColor: Colors.transparent, // Avoid any tint effect on the AppBar surface
          shape: null, // Keep the default shape or set a custom one if needed
          iconTheme: IconThemeData(color: Colors.white), // Set icon theme color to white
          actionsIconTheme: IconThemeData(color: Colors.white), // Set actions icon theme color to white
          centerTitle: true, // Center the title in the AppBar
          titleSpacing: NavigationToolbar.kMiddleSpacing, // Use default title spacing
          toolbarHeight: kToolbarHeight, // Use the default toolbar height
          toolbarTextStyle: TextStyle(color: Colors.white), // Set the toolbar text style to white
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Set the title text style to white
        ),
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
      return BottomNav(); // Home page for "hire"
    } else if (selectedValue == 'solo_artist' || selectedValue == 'team') {
      return BottomNavart(data: {},); // Home page for "solo artist" or "team"
    } else {
      return Scene(); // Fallback to Scene if no matching selected_value
    }
  }
}

// Example of wrapping a page with SystemUiOverlayStyle
class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark, // Set this to dark for white pages
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
      value: SystemUiOverlayStyle.light, // Set this to light for black pages
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