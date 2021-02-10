import 'package:brand_colors/brand_colors.dart';
import 'dart:math';
import 'package:green_route/buttons/floating_searchbar.dart';
import 'package:green_route/dataprovider/appdata.dart';
import 'package:green_route/helpers/helpermethods.dart';
import 'package:green_route/helpers/path_matcher.dart';
import 'package:green_route/screens/ambulace_map.dart';
import 'package:green_route/screens/ambulance_signup.dart';
import 'package:flutter/material.dart';
import 'package:green_route/buttons/round_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_route/widgets/ProgessDialog.dart';
import 'package:green_route/services/push_notification.dart';
import 'package:permission/permission.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:green_route/provider/google_signin.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:green_route/screens/search_page.dart';
import 'package:green_route/services/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_route/services/database.dart';
import 'package:green_route/services/location.dart';
import 'package:green_route/services/push_notification.dart';
// import 'package:green_route/models/ambulance_class.dart';

double latitude = 19.079790;
double longitude = 72.904050;

class MainMap extends StatefulWidget {
  static String id = 'main_map';
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  Future<String> notificationCall() async {
    PushNotificationsManager pushNotificationService =
        PushNotificationsManager();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User usert = auth.currentUser;
    final uid = usert.uid;

    String token = await pushNotificationService.init();
    // DatabaseService(uid: uid).updateUserToken(token);
    DatabaseService(uid: uid).updateUserData(false, latitude, longitude, token);
    return token;
  }

  void initState() {
    super.initState();
    getCurrentLocation();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    notificationCall();
  }

  void getCurrentLocation() async {
    GetLocation location = GetLocation();
    await location.getLocation();
    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;
    });
  }

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;
  double mapBottomPadding = 0;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  Position currentPosition;
  var geolocator = Geolocator();

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    String address =
        await HelperMethods.findCordinateAddress(position, context);
    print(address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 14.4746,
  );

  static final CameraPosition _currentpos = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(latitude, longitude),
      tilt: 59.440717697143555,
      zoom: 14);
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      key: _drawerKey,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: _polylines,
            markers: _markers,
            circles: _circles,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;
              setupPositionLocator();
            },
          ),
          Column(
            children: [
              SizedBox(
                height: 55.0,
              ),
              GestureDetector(
                onTap: () async {
                  var response = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));

                  if (response == 'getDirection') {
                    await getDirection();
                  }
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                          size: 25.0,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'Search..',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            width: 52,
            height: 52,
            top: 120,
            right: 20,
            child: RoundButton(
              btn_color: Colors.white,
              onPressed: () => _drawerKey.currentState.openEndDrawer(),
              btn_icon: Icon(
                Icons.menu,
                color: Colors.black,
                size: 23,
              ),
            ),
          ),
          Positioned(
            width: 60,
            height: 60,
            bottom: 25,
            left: 17,
            child: RoundButton(
              btn_color: Colors.white,
              onPressed: () {
                setupPositionLocator();
              },
              btn_icon: Icon(
                Icons.gps_fixed,
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int Index) {}, // new
        currentIndex: 0, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop),
            title: Text('Explore'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.house),
            title: Text('Commute'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), title: Text('Saved')),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.local_hospital_rounded,
                color: Colors.red,
              ),
              title: Text('For Ambulance'),
              onTap: () {
                Navigator.pushNamed(context, AmbulanceSignUp.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Logout'),
              onTap: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getDirection() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Please wait...',
      ),
    );

    var thisDetails =
        await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);
    // print(results);
    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polylines.add(polyline);
    });

    LatLngBounds bounds;

    if (pickup.latitude > destination.latitude &&
        pickup.longitude > destination.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    } else if (pickup.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude));
    } else if (pickup.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
          northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude));
    } else {
      bounds =
          LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: destination.placeName, snippet: 'Destination'),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: Colors.green,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Colors.purpleAccent,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: Colors.purpleAccent,
    );

    setState(
      () {
        _circles.add(pickupCircle);
        _circles.add(destinationCircle);
      },
    );
  }

  Future<void> _currentPos() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentpos));
  }
}
