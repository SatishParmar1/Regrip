import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:regrip/formdata.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  final Location _location = Location();
  LocationData? _currentLocation;
  late DatabaseReference location;
  Timer? _timer;
  bool share= false;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    location = FirebaseDatabase.instance.ref().child('data');
  }

  void _startAutoUpdate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location Sharing Start.')),
    );
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      _updateLocationInDatabase();
    });

  }
  void _stopAutoUpdate() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location Sharing stopped.')),
      );
    }
  }

  Future<void> _updateLocationInDatabase() async {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not available.')),
      );
      return;
    }
    // Update the database
    Map<String, dynamic> data = {
      'latitude': _currentLocation!.latitude.toString(),
      'longitude': _currentLocation!.longitude.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    await location.push().update(data);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SOS location updated in the database.')),
    );
  }
  

  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    // Check if location service is enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get the current location
    _currentLocation = await _location.getLocation();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page",style: TextStyle(color: Colors.deepPurple.shade700),),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
          Column(
            children: [
              if (_currentLocation == null)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latitude: ${_currentLocation!.latitude}',style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    Text('Longitude: ${_currentLocation!.longitude}',style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                   const SizedBox(height: 60,),

                        Visibility(
                          visible: share,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.redAccent.shade100,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: TextButton(onPressed: (){
                                //_updateLocationInDatabase();
                                _stopAutoUpdate();
                                setState(() {
                                  share= false;
                                });
                              }, child: const Text("Stop", style: TextStyle(fontSize:30,color: Colors.black))),
                            ),
                        ),
                          Visibility(
                            visible: !share,
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade200,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: TextButton(onPressed: (){
                                  //_updateLocationInDatabase();
                                  _startAutoUpdate();
                                  setState(() {
                                    share = true;
                                  });
                                }, child: const Text("Share", style: TextStyle(fontSize:30,color: Colors.black))),
                              ),
                          ),
                  ]

                ),

            ],
          ),
        ),
      )
    );
  }
}
