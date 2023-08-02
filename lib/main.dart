// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigator/qr_code.dart';
import 'package:navigator/splash_screen.dart';

void main() {
  runApp(MyApp());
}

final ThemeData myTheme = ThemeData(
  primarySwatch: Colors.green,
  buttonTheme: ButtonThemeData(
    buttonColor: Color.fromARGB(255, 210, 161, 13),
    textTheme: ButtonTextTheme.primary,
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map Navigation Demo',
      theme: myTheme,
      home: SplashScreen(),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        appBar: AppBar(title: Text("Navigator")),
        body: Center(
          child: ListView(
            children: [
              Container(
                height: 200.0, // Adjust the height as you wish
                width: 50.0, // Adjust the width as you wish
                child: Image.asset('assets/images/logo2.jpg'),
              ),
              ButtonTile(
                lat: 17.455953613855996,
                lon: 78.66597712039948,
                title: "Block 1",
              ),
              CreateQRButton(
                lat: 17.455953613855996,
                lon: 78.66597712039948,
                title: "Create Block 1 QR",
              ),
              ButtonTile(
                lat: 17.455692627545062,
                lon: 78.6670795083046,
                title: "Block 2",
              ),
              CreateQRButton(
                lat: 17.455692627545062,
                lon: 78.6670795083046,
                title: " Create Block 2 QR",
              ),
              ButtonTile(
                lat: 17.455498166913493,
                lon: 78.66765215992928,
                title: "Bio Tech Block",
              ),
              CreateQRButton(
                lat: 17.455498166913493,
                lon: 78.66765215992928,
                title: "Create Bio Tech Block QR",
              ),
              ButtonTile(
                lat: 17.454756144175,
                lon: 78.66547286510468,
                title: "Near Parking",
              ),
              CreateQRButton(
                lat: 17.454756144175,
                lon: 78.66547286510468,
                title: "Create Near Parking QR",
              ),
              ButtonTile(
                lat: 17.45716131034895,
                lon: 78.66805851459503,
                title: "Near BasketBall Court",
              ),
              CreateQRButton(
                lat: 17.45716131034895,
                lon: 78.66805851459503,
                title: "Create Near BasketBall Court QR",
              ),
              ButtonTile(
                lat: 17.45522182776426,
                lon: 78.6665028333664,
                title: "Admin Block",
              ),
              CreateQRButton(
                lat: 17.45522182776426,
                lon: 78.6665028333664,
                title: "Create Admin Block QR",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonTile extends StatelessWidget {
  final String title;
  final double lat, lon;
  const ButtonTile({
    super.key,
    required this.title,
    required this.lat,
    required this.lon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MapScreen(destinationLatitude: lat, destinationLongitude: lon),
          ),
        );
      },
      child: Container(
        height: 40,
        width: 200,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromARGB(255, 88, 154, 236),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final double destinationLatitude;
  final double destinationLongitude;

  const MapScreen(
      {Key? key,
      required this.destinationLatitude,
      required this.destinationLongitude})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? currentLocation;
  final Geolocator geolocator = Geolocator();

  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    currentLocation = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation;
      print(currentLocation);
    });
  }

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await getCurrentLocation();
    addMarkers();
    addPolyline();
    setState(() {
      currentLocation;
    });
  }

  void addMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(currentLocation?.latitude ?? 0.0,
            currentLocation?.longitude ?? 0.0),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    markers.add(
      Marker(
        markerId: MarkerId('destinationLocation'),
        position:
            LatLng(widget.destinationLatitude, widget.destinationLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    setState(() {});
  }

  void addPolyline() {
    polylines.add(
      Polyline(
        polylineId: PolylineId('route'),
        color: Colors.blue,
        points: [
          LatLng(currentLocation?.latitude ?? 17.45409638,
              currentLocation?.longitude ?? 78.66624926),
          LatLng(widget.destinationLatitude, widget.destinationLongitude),
        ],
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Navigation'),
      ),
      body: GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation?.latitude ?? 17.45409638,
              currentLocation?.longitude ?? 78.66624926),
          zoom: 13.0,
        ),
        markers: markers,
        polylines: polylines,
      ),
    );
  }
}
