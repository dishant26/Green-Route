import 'package:green_route/screens/ambulace_map.dart';
import 'package:green_route/screens/main_map.dart';
import 'package:flutter/material.dart';
import 'package:green_route/buttons/pill_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_route/provider/google_signin.dart';
import 'package:green_route/provider/ambulance_verify.dart';
import 'package:provider/provider.dart';

// import 'package:brew_test/screens/ambulance_map.dart';

class AmbulanceSignUp extends StatelessWidget {
  static String id = 'ambulance_signup';
  AmbulanceSignUp({this.provider});

  final provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Center(
                child: Container(
                  width: 300,
                  child: Image(
                    image: AssetImage('images/ambulance_clipart.png'),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: 350,
                  child: Text(
                    'Are you an Ambulance Provider?',
                    style: TextStyle(color: Colors.red, fontSize: 30),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  width: 110,
                  child: PillButton(
                    display_text: Text(
                      'Yes',
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                    logo_img: AssetImage('images/ambulance_logo.png'),
                    padding: EdgeInsets.fromLTRB(1, 9, 1, 9),
                    onPressed: () {
                      Navigator.pushNamed(context, LandingScreen.id);
                      // return AmbulanceMap();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  width: 110,
                  child: PillButton(
                    display_text: Text(
                      'No',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                    logo_img: AssetImage('images/map_logo.png'),
                    padding: EdgeInsets.fromLTRB(1, 9, 1, 9),
                    onPressed: () {
                      Navigator.pushNamed(context, MainMap.id);
                      // return MainMap();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
