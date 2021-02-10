import 'dart:developer';
// import 'dart:js';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:green_route/screens/ambulace_map.dart';

String token = '';

int counter_1 = 1;
int counter_2 = 1;
int counter_3 = 1;

void playsound() {
  final player = AudioCache();
  player.play("Amb_1.wav");
}

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<String> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          // AlertDialog(
          //   title: Text("Please Make way for Ambulance"),
          //   content: Text("Blah Blah Blah"),
          //   actions: [
          //     FlatButton(
          //       child: Text("Ok"),
          //       onPressed: () {
          //         // Navigator.of(context).pop();
          //       },
          //     )
          //   ],
          // );
          // popNotif();

          if (counter_1 == 1) {
            playsound();
            counter_1++;
          }

          // _showItemDialog(message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");

          if (counter_2 == 1) {
            playsound();
            counter_2++;
          }
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");

          if (counter_3 == 1) {
            playsound();
            counter_3++;
          }
        },
      );

      token = await _firebaseMessaging.getToken();
      _firebaseMessaging.subscribeToTopic('news');
      print("token: $token");
      //
      _initialized = true;
      return token;
    }
  }

  // String returnToken() {
  //   print("token: $token");
  //   print(_initialized);
  //   return token;
  // }
}
