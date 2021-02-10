import 'package:green_route/models/ambulance_class.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:green_route/services/AmbulanceRoute.dart';

List notAmb = [];

Future<void> streamReturn() async {
  var new_val = await FirebaseFirestore.instance
      .collection("User_Database")
      .get()
      .then((QuerySnapshot querySnapshot) {
    List firestoreVal = querySnapshot.docs;
    print("Current Latitude is:");
    for (var item in firestoreVal) {
      if (!item["Ambulance"]) {
        notAmb.add(
            [item.id, item["Current_Latitude"], item["Current_Longitude"]]);
      }
    }
    return [firestoreVal];
  });

  // print(new_val);
  print(notAmb);
  if (notAmb.length != 0) {
    print("that");
    print(notAmb);
    Ambulance_Model(userLocations: notAmb).printLocations();
  }
}

// class NodeIdentify extends StatelessWidget {
//   List userList = [];
//   static String id = 'Node_identify';
//   @override
//   Widget build(context) {
//     return Scaffold(
//       body: FutureBuilder(
//           future: FirebaseFirestore.instance.collection("User_Database").get(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasData) {
//               QuerySnapshot documents = snapshot.data;
//               List<DocumentSnapshot> docs = documents.docs;
//               docs.forEach((data) {
//                 if (!data['Ambulance']) {
//                   streamReturn();

//                   userList.add([
//                     data.id,
//                     data["Current_Latitude"],
//                     data["Current_Longitude"]
//                   ]);
//                   print("this");
//                 }
//               });
//             }

//             if (userList.length != 0) {
//               print("that");
//               print(userList);
//               Ambulance_Model(userLocations: userList).printLocations();
//             }
//             // Navigator.pop(context);
//             print("Ok Going out!");

//             // Navigator.pushNamed(context, MainMap.id);

//             // return AmbulanceMap();
//             return AmbulanceMap();
//           }),
//     );
//   }
// }
