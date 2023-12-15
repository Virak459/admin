import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Class_Text extends StatefulWidget {
  const Class_Text({super.key});

  @override
  State<Class_Text> createState() => _Class_TextState();
}

class _Class_TextState extends State<Class_Text> {
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [],
      ),
    );
  }

  Future<void> getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // The user denied the request for location permission.
          // You can show a dialog or message to inform the user and guide them to enable location services.
          print('Location permission denied by the user.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // The user denied the request for location permission permanently.
        // You can open the device settings to guide the user to enable location services.
        print('Location permission permanently denied by the user.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double latitude = position.latitude;
      double longitude = position.longitude;

      print('Latitude: $latitude, Longitude: $longitude');

      // Now you can use the latitude and longitude as needed in your application.
    } catch (e) {
      print('Error getting location: $e');
      // Handle other errors that may occur during location retrieval.
    }
  }

  double lat = 0, log = 0;
  Future<void> _getCurrentPosition() async {
    print('================');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude;
      log = position.longitude;
      print('$lat & $log');
    });
  }
}
