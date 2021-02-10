import 'package:green_route/dataprovider/appdata.dart';
import 'package:green_route/provider/ambulance_verify.dart';
import 'package:green_route/screens/ambulace_map.dart';
import 'package:green_route/screens/ambulance_signup.dart';
import 'package:green_route/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_route/home_page.dart';
import 'package:green_route/screens/main_map.dart';
import 'package:provider/provider.dart';
import 'package:green_route/services/Node_identify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: HomePage(),
    //   // initialRoute: HomePage.id,
    //   routes: {
    //     SignUpPage.id: (context) => SignUpPage(),
    //     MainMap.id: (context) => MainMap(),
    //     AmbulanceMap.id: (context) => AmbulanceMap(),
    //     // SignInPage.id: (context) => SignInPage()
    //     AmbulanceSignUp.id: (context) => AmbulanceSignUp(provider: null),
    //     LandingScreen.id: (context) => LandingScreen(),
    //     NodeIdentify.id: (context) => NodeIdentify()
    //   },
    // );
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        // initialRoute: HomePage.id,
        routes: {
          SignUpPage.id: (context) => SignUpPage(),
          MainMap.id: (context) => MainMap(),
          AmbulanceMap.id: (context) => AmbulanceMap(),
          // SignInPage.id: (context) => SignInPage()
          AmbulanceSignUp.id: (context) => AmbulanceSignUp(provider: null),
          LandingScreen.id: (context) => LandingScreen(),
          // NodeIdentify.id: (context) => NodeIdentify()
        },
      ),
    );
  }
}
