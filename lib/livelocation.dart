import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LiveLocationSender extends StatefulWidget {
  @override
  _LiveLocationSenderState createState() => _LiveLocationSenderState();
}

class _LiveLocationSenderState extends State<LiveLocationSender> {
  final Location _location = Location();
  LocationData? _currentLocation;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
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

    // Check for location permissions
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

  Future<void> _sendLocationSMS(String phoneNumber) async {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to fetch location. Please try again.')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    final latitude = _currentLocation!.latitude;
    final longitude = _currentLocation!.longitude;

    // Generate the Google Maps link
    final mapsLink = "https://www.google.com/maps?q=$latitude,$longitude";

    // Compose the SMS
    final smsMessage = "Hey! Here's my current location: $mapsLink";

    // Launch the SMS app
    final smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': smsMessage},
    );
    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Live Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_currentLocation == null)
              Center(child: CircularProgressIndicator())
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Latitude: ${_currentLocation!.latitude}',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  Text('Longitude: ${_currentLocation!.longitude}'),
                ],
              ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              onSubmitted: (value) {
                if (!_isSending) {
                  _sendLocationSMS(value);
                }
              },
            ),
            if (_isSending)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
