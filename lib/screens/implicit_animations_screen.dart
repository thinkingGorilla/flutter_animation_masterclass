import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() => _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;

  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Implicit Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // `Implicit animation`이란?
            // 애니메이션을 사용할 수 있지만 애니메이션이 코드에 없는 것을 말한다.
            AnimatedAlign(
              alignment: _visible ? Alignment.topLeft : Alignment.topRight,
              duration: const Duration(seconds: 2),
              child: AnimatedOpacity(
                opacity: _visible ? 1 : 0,
                duration: const Duration(seconds: 2),
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  color: Colors.amber,
                ),
              ),
            ),
            // Opacity(
            //   opacity: _visible ? 1 : 0,
            //   child: Container(
            //     width: size.width * 0.8,
            //     height: size.width * 0.8,
            //     color: Colors.amber,
            //   ),
            // ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _trigger,
              child: const Text('Go!'),
            ),
          ],
        ),
      ),
    );
  }
}
