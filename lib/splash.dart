import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipotatotimer/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        reverse: true,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "iPotato Timer",
              style: TextStyle(shadows: <Shadow>[
                Shadow(
                    offset: const Offset(-3.0, -0.0),
                    blurRadius: 3.0,
                    color: Theme.of(context).primaryColor),
              ], fontSize: 48.0),
            ),
          ),
          Image.asset('assets/images/icon.png'),
        ],
      ),
    );
  }
}
