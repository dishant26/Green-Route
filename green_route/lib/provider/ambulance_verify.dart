import 'dart:async';
import 'dart:io';
import 'package:green_route/screens/ambulace_map.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:green_route/buttons/simple_round_button.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:green_route/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_route/provider/google_signin.dart';
import 'package:green_route/buttons/pill_button.dart';

class LandingScreen extends StatefulWidget {
  static String id = 'ambulance_verify.dart';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  File imageFile;
  final List<String> names = <String>[];
  int i = 0, checkTrue = 0;
  var findName = "hospital";

  _openGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Text("Make a Choice"),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 35.0,
                        ),
                        SizedBox(
                          width: 13.0,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(12.0)),
                  GestureDetector(
                    child: Row(
                      children: [
                        Icon(
                          Icons.collections,
                          size: 35,
                        ),
                        SizedBox(
                          width: 13.0,
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    onTap: () {
                      _openGallery(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(imageFile);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          names.insert(i, word.text.toLowerCase());
          i++;
        }
      }
    }
    if (names.contains(findName)) {
      print("Hospital FOUND");
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;
      final uid = user.uid;
      await DatabaseService(uid: uid).updateUserData(true, 0.000, 0.0000, '');
      Navigator.pushNamed(context, AmbulanceMap.id);
    } else {
      print("Hospital Not Found");
    }
    print(names);
  }

  Widget _decideImageView() {
    if (imageFile == null) {
      return Text(
        "No Image Selected",
        style: TextStyle(fontSize: 18.0),
      );
    } else {
      return Image.file(
        imageFile,
        width: 400,
        height: 400,
      );
    }
  }

  Widget idVerify() {
    return Text(
      "Please Try Again",
      style: TextStyle(fontSize: 18.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text("IDENTITY AUTENCATION")),
        backgroundColor: const Color(0xFF0A043C),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Center(child: _decideImageView()),
                  flex: 6,
                ),
                Expanded(
                  child: SimpleRoundButton(
                    onPressed: () {
                      _showChoiceDialog(context);
                    },
                    backgroundColor: Colors.redAccent,
                    buttonText: Text(
                      "SELECT IMAGE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: SimpleRoundButton(
                    onPressed: () {
                      names.clear();
                      i = 0;
                      readText();
                    },
                    backgroundColor: Colors.redAccent,
                    buttonText: Text(
                      "AUTHENTICATE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
