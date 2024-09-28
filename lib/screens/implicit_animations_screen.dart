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
            AnimatedContainer(
              // `Curve`는 애니메이션의 진행 속도를 정의하는 함수로
              // 시간의 변화에 따른 애니메이션 효과를 조절하는 역할을 한다.
              curve: Curves.elasticOut,
              duration: const Duration(seconds: 2),
              width: _visible ? size.width : size.width * 0.8,
              height: _visible ? size.width : size.width * 0.8,
              transform: Matrix4.rotationZ(_visible ? 1 : 0),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: _visible ? Colors.red : Colors.amber,
                borderRadius: BorderRadius.circular(_visible ? 100 : 0),
              ),
            ),
            const SizedBox(height: 50),
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