// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String? long, lat;
  late StreamSubscription<Position> positionStream;
  final TextEditingController searchController = TextEditingController();
  late GoogleMapController googleMapController;
  void _onMapCreated(GoogleMapController controller){
    googleMapController = controller;
  }
  final kGoogleApiKey = "AIzaSyDT4djfKaT95oD5yooZbXG7DKF8a2sS4vI";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkGps();
    // Timer(Duration(seconds: 3), () {
    //   checkGps();
    //   print("Yeah, this line is printed after 3 seconds");
    // });
  }
  void placeAutoComplete (String query){
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {
        "input": query,
        "key": kGoogleApiKey,
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      extendBodyBehindAppBar: true,
      body: lat == null || long == null ? Center(child: Image.asset('assets/images/spinner.gif',width: 100.0),)
      : Container(
        margin: EdgeInsets.only(top: 60.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      // locationData!.latitude!.toDouble(), locationData!.longitude!.toDouble()
                      // 22.7290653,75.8878115
                      double.parse(lat.toString()),double.parse(long.toString())
                    ),
                    zoom: 16.0
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('My current location'),
                      position: LatLng(
                          // locationData!.latitude!.toDouble(), locationData!.longitude!.toDouble()
                          // 22.7290653,75.8878115
                          double.parse(lat.toString()),double.parse(long.toString())
                      ),
                      infoWindow: InfoWindow(
                        title: 'My current location'
                      ),
                      draggable: true,
                    ),
                  },
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: true,
                ),
              ),
              Positioned(
                top: 7,
                left: 10,
                right: 60.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  height: 50.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child:
                        TextFormField(
                          onChanged: (text) {
                            setState(() {});
                          },
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search Location...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      searchController.text.isEmpty || searchController.text == null || searchController.text == ''
                      ? Container()
                      : InkWell(
                        onTap: () {
                          searchController.clear();
                          setState(() {});
                        },
                        child: Icon(Icons.close),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: InkWell(
          onTap: () {
            placeAutoComplete('Delhi');
          },
          child: Container(
            alignment: Alignment.center,
            height: 40.0,
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3),
            decoration: BoxDecoration(
              color: Colors.blue.shade500,
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined,color: Colors.white),
                Text(
                  'Locate Me',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied------------------------------------------------');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied------------------------------------------------");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location------------------------------------------------");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
      print('position.longitude is --------------${position.longitude}'); //Output: 80.24599079
      print('position.latitude is --------------${position.latitude}'); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }

}
