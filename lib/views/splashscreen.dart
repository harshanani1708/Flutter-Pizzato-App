import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pizzato/views/homescreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 5,
        ),
        () => Navigator.pushReplacement(context,
            PageTransition(child: HomePage(), type: PageTransitionType.fade)));
    //@override
    //super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                //alignment: Align,
                width: 400.0,
                height: 200.0,
                child: Lottie.asset("lib/animations/pizza.json"),
              ),
            ),
            RichText(
              text: TextSpan(
                text: "Piz",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 56.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Z',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 56.0,
                    ),
                  ),
                  TextSpan(
                    text: 'ato',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 56.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
