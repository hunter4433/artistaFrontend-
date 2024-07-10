import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test1/page-1/booked_artist.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



import '../main.dart';
// import 'package:firebase_iid/firebase_iid.dart';

Future <void> handleBackgroundMessage(RemoteMessage message) async{
  print('title: ${message.notification?.title}');
  print('body: ${message.notification?.body}');
  print('payload: ${message.data}');
}

class FirebaseApi {
  final storage = FlutterSecureStorage();
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

final androidChannel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notification',
  importance: Importance.defaultImportance,
);




  void handleMessage (RemoteMessage? message){
    if (message == null) return;
    // Add your navigation logic here
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => Booked(),
      ),
    );
  }

Future initLocalNotification() async {
    // const iOS = iOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/android_logo');
    const settings = InitializationSettings(android : android );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
          handleMessage(message);
        }
      },
    );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await  platform?.createNotificationChannel(androidChannel);
}


  Future initPushNotification() async {
    final _localNotifications = FlutterLocalNotificationsPlugin();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message){
      final notification =message.notification;
     if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails (
            androidChannel.id,
            androidChannel.name,
            channelDescription: androidChannel.description,
            icon: '@drawable/android_logo',
          )
        ),
        payload: jsonEncode(message.toMap()),
      );
    });

  }

  Future<void> sendFCMTokenBackend(String? token) async {
    if (token == null) return;

    final String backendUrl = 'https://your-backend-url.com/saveFCMToken';
    final response = await http.post(
      Uri.parse(backendUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fcm_token': token,
      }),
    );

    if (response.statusCode == 200) {
      print('FCM token sent successfully');
    } else {
      print('Failed to send FCM token: ${response.reasonPhrase}');
    }
  }




  Future<void> initNotification() async {
    try {
      await _firebaseMessaging.requestPermission();
      final fCMToken = await _firebaseMessaging.getToken();
      if (fCMToken != null) {
        print('token: $fCMToken');
        await storage.write( key: 'fCMToken', value: fCMToken);
        // sendFCMTokenBackend(fCMToken);
      }
      initPushNotification();
      initLocalNotification();

    } catch (e) {
      // Handle the case where Firebase throws an exception
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      bool gotFBCrash = true;
      if (gotFBCrash) {
        try {
          final fCMToken = await FirebaseMessaging.instance.getToken();
          print('token: $fCMToken');
        } catch (e) {
          // Handle the case where Firebase throws an exception again
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
        }
      }
    }
  }
}
