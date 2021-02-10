import 'package:green_route/buttons/pill_button.dart';
import 'package:flutter/material.dart';
import 'package:green_route/provider/google_signin.dart';
import 'package:green_route/screens/main_map.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  static String id = 'login_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Image(
              image: AssetImage('images/map_logo.png'),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Maps',
              style: TextStyle(color: Colors.grey, fontSize: 40),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 250,
              child: PillButton(
                display_text: Text(
                  'Sign in with Google',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                logo_img: AssetImage('images/google_logo.jpg'),
                padding: EdgeInsets.fromLTRB(2, 9, 2, 9),
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.login();
                },
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 250,
              child: PillButton(
                display_text: Text(
                  'Start using Maps',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                logo_img: AssetImage('images/map_logo.png'),
                padding: EdgeInsets.fromLTRB(2, 9, 2, 9),
                onPressed: () {
                  Navigator.pushNamed(context, MainMap.id);
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
