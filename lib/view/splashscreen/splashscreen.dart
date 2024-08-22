import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whitematrix/view/homescreen/homescreen.dart';
import 'package:whitematrix/view/welcomescreen/welcome.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key, this.islogged = false});
  final bool islogged;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 4)).then((value) {
      if (widget.islogged == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Welcomescreen(),
            ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
              Lottie.asset("assets/animations/Animation - 1724172095788.json")),
    );
  }
}
