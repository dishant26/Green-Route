import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_route/services/BishList.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference collectme =
      FirebaseFirestore.instance.collection('User_Database');

  final CollectionReference activeAmbulance =
      FirebaseFirestore.instance.collection('Active_Ambulance');

  final CollectionReference userTokens =
      FirebaseFirestore.instance.collection('User_Token');

  Future<void> updateUserData(bool ambulance, double latitude, double longitude,
      String usertoken) async {
    return await collectme.doc(uid).set({
      'Ambulance': ambulance,
      'Current_Latitude': latitude,
      'Current_Longitude': longitude,
      'User_Token': usertoken
    });
  }

  Future<void> updateAmbulanceData(double amb_latitude, double amb_longitude,
      List pathData, List childNodes) async {
    return await activeAmbulance.doc(uid).set({
      'Ambulance_Latitude': amb_latitude,
      'Ambulance_Longitude': amb_longitude,
      'Path_Points': pathData,
      'Child_Nodes': childNodes
    });
  }

  Future<void> updateUserToken(String userToken) async {
    return await userTokens.doc(uid).set({
      'Token_Value': userToken,
    });
  }
}
