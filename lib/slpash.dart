// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps/map_screen.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLoading = false;
  loc.LocationData? locationData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
    Timer(
      Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) => MapScreen())), (route) => false);
      }
    );
  }

  Future getPermission() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (await Permission.location.isGranted) {
      getLatLong();
    } else {
      Permission.location.request();
    }
  }

  Future getLatLong() async {
    setState(() {
      isLoading = true;
    });
    locationData = await loc.Location.instance.getLocation();
    print('lat : ---------' + locationData!.latitude.toString());
    print('long : ---------' + locationData!.longitude.toString());
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: null /* add child content here */,
      ),
    );
  }
}
