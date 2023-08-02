// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:navigator/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatelessWidget {
  const QRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CreateQRButton extends StatelessWidget {
  final String title;
  final double lat, lon;
  const CreateQRButton({
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
            builder: (context) => QRGenerator(latitude: lat, longitude: lon),
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

class QRGenerator extends StatelessWidget {
  final double latitude;
  final double longitude;
  QRGenerator({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Generator'),
      ),
      body: Center(
          child: QrImageView(
        data: 'Longitude: $longitude, Lattitude: $latitude',
        version: QrVersions.auto,
        size: 320,
        gapless: false,
      )),
    );
  }
}
