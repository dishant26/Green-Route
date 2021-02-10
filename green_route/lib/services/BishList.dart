import 'package:green_route/screens/ambulace_map.dart';
import 'package:green_route/screens/main_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser;
final uid = user.uid;

class BishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User_Database')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new CircularProgressIndicator();
          }
          var document = snapshot.data;
          print(document["Ambulance"]);
          return (document["Ambulance"] ? AmbulanceMap() : MainMap());
        },
      ),
    );
  }
}
