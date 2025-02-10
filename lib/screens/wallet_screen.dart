import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
      ),
      body: Center(
        child: Animate(
          effects: [
            FadeEffect(
              begin: 0,
              end: 1,
              // duration: Duration(milliseconds: 500),
              // Dart 언어의 특성(extension)을 이용한 flutter_animate 패키지의 Duration 제공방법
              duration: 3.seconds,
              curve: Curves.easeInCubic,
            ),
            ScaleEffect(
              alignment: Alignment.center,
              begin: Offset.zero,
              end: Offset(1, 1),
              duration: 5.seconds,
            )
          ],
          child: Text(
            'Hello!',
            style: TextStyle(fontSize: 66),
          ),
        ),
      ),
    );
  }
}
