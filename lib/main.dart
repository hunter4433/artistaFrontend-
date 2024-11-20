import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test1/page-1/bottomNav_artist.dart';
import 'package:test1/page-1/bottom_nav.dart';
import 'api/firebase_api.dart';
import 'firebase_options.dart';
// <<<<<<< HEAD
import 'package:test1/page-1/page0.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterSecureStorage secureStorage = FlutterSecureStorage();
bool authorised = false;
String? selectedValue = '';
// Updated the type to match the new connectivity_plus API
StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
// =======
// import 'package:test1/page-1/page0.dart'; // Ensure this import is correct
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final FlutterSecureStorage secureStorage = FlutterSecureStorage();
// bool authorised = false; // Default value for authorised
// String selectedValue = ''; // Holds the selected value from secure storage
// >>>>>>> 71fc5321e6356695c1a1f769543a7c429f07c784

Future<void> initializeApp() async {
  String? isInitialized = await secureStorage.read(key: 'isInitialized');

  if (isInitialized == null) {
    await secureStorage.deleteAll();
    await secureStorage.write(key: 'isInitialized', value: 'true');
  }
}

//mohit here
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();

  try {
    // Initialize Firebase and notifications
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseApi().initNotification();
  } catch (e) {

    print("Error initializing Firebase: $e");
  }


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


class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Connectivity _connectivity;
  ConnectivityResult _connectivityStatus = ConnectivityResult.none;
  bool _isDialogShowing=false;
  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _initConnectivity();
    // Subscribe to connectivity changes
    // Now this assignment will work correctly
    connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        if (results.isNotEmpty) {
          setState(() {
            _connectivityStatus = results.first;
          });
          _showConnectivitySnackbar(results.first);
        }
      },
    );

  }
  void _handleConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      _dismissNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (!_isDialogShowing && navigatorKey.currentContext != null) {
      _isDialogShowing = true;
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,  // Prevents back button dismissal
            child: AlertDialog(
              // ... dialog content ...
            ),
          );
        },
      );
    }
  }

  void _dismissNoInternetDialog() {
    if (_isDialogShowing && navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).pop();
      _isDialogShowing = false;
    }
  }

  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      setState(() {
        _connectivityStatus = results.isNotEmpty ? results.first : ConnectivityResult.none;
      });
      // _showConnectivitySnackbar(result);
    } catch (e) {
      print('Failed to get connectivity status: $e');
    }
  }



  void _showConnectivitySnackbar(ConnectivityResult result) {
    String message;
    Color color;

    switch (result) {
      case ConnectivityResult.mobile:
        message = 'Connected to Mobile Network';
        color = Colors.green;
        break;
      case ConnectivityResult.wifi:
        message = 'Connected to Wi-Fi';
        color = Colors.green;
        break;
      case ConnectivityResult.none:
        message = 'No internet connection';
        color = Colors.red;
        break;
      default:
        message = 'Connectivity status unknown';
        color = Colors.grey;
    }

    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artista',
      theme: ThemeData(
// <<<<<<< HEAD
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        cardTheme: CardTheme(
          color: Color(0xFFFEFEFE),
          shadowColor: Color(0xFFE9E8E6).withOpacity(0.4),
          surfaceTintColor: Colors.transparent,
          elevation: 3,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFEFEFE),
          foregroundColor: Color(0xFFFEFEFE),
          elevation: 0,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          titleSpacing: NavigationToolbar.kMiddleSpacing,

          toolbarHeight: kToolbarHeight,
          toolbarTextStyle: TextStyle(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)
            .copyWith(background: Colors.white),
      ),

      navigatorKey: navigatorKey,
      home: _getHomePage(),

    );
  }

  Widget _getHomePage() {
    if (!authorised) {
      return Scene(); // Load login scene if not authorised
    }
    if (selectedValue == 'hire') {

      return BottomNav();
    } else if (selectedValue == 'solo_artist' || selectedValue == 'team') {
      return BottomNavart(data: {});
    } else {
      return Scene();
    }
  }
}

