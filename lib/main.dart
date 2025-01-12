import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:regrip/formdata.dart';
import 'package:regrip/homepage.dart';


void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
 // options: DefaultFirebaseOptions.currentPlatform,
);
runApp(UserRegistrationApp());
}

class UserRegistrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'User Registration',
      home:  RegistrationForm(),
    );
  }
}


