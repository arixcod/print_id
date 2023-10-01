import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:print_id/dashboard.dart';
import 'welcomePage.dart';
import 'package:firebase_core/firebase_core.dart';


import 'package:firebase_app_check/firebase_app_check.dart';


Future <void> main() async{


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

  runApp(const MyApp());
}




class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn=false;
  final FirebaseAuth _auth= FirebaseAuth.instance;
  void checkloginState(){
        _auth.authStateChanges().listen((User ? user ){
          if (user!=null){
            setState(() {
              isLoggedIn=true;
            });
          }
        });
  }

      @override
  void initState() {
      checkloginState();
    // TODO: implement initState
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home:isLoggedIn ? const dashboard(): const WelcomePage(),
    );
  }
}
