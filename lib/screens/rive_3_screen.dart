import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Rive3Screen extends StatefulWidget {
  const Rive3Screen({super.key});

  @override
  State<Rive3Screen> createState() => _Rive3ScreenState();
}

class _Rive3ScreenState extends State<Rive3Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive3'),
      ),
      body: Stack(
        children: [
          RiveAnimation.asset(
            'assets/animations/balls-animation.riv',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Center(
                child: Text(
                  'Welcome To AI App',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
