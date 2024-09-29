import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() => _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Color?> _color;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    // `Tween`이 `AnimationController`에 의해 애니메이션되도록
    // animate() 함수를 통해 `AnimationController`와 연결한다.
    // `Tween`은 `AnimationController`에서 제공하는 0부터 1까지의 실수 값을 따라
    // 설정된 `begin`부터 `end`까지의 값으로부터 자신이 애니메이션할 목표값을 보간하여 계산한다.
    _color = ColorTween(begin: Colors.amber, end: Colors.red).animate(_animationController);
  }

  void _play() => _animationController.forward();

  void _pause() => _animationController.stop();

  void _rewind() => _animationController.reverse();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explicit Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _color,
              builder: (context, child) {
                return Container(
                  // `AnimationController.value`에 의해 `ColorTween.value`에 매핑된 값을 사용한다.
                  color: _color.value,
                  width: 400,
                  height: 400,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _play, child: const Text('Play')),
                ElevatedButton(onPressed: _pause, child: const Text('Pause')),
                ElevatedButton(onPressed: _rewind, child: const Text('Rewind')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
