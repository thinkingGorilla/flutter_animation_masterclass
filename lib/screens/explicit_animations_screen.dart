import 'dart:developer';

import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() => _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final CurvedAnimation _curved;
  late final Animation<Decoration> _decoration;
  late final Animation<double> _rotation;
  late final Animation<double> _scale;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      reverseDuration: const Duration(seconds: 1),
    )..addListener(
        () {
          _range.value = _animationController.value;
          // `_value`가 변할 때 setState() 함수 호출로 화면을 리렌더링 하는 것은
          // 화면 전체를 리렌더링하므로 매우 비효율적이다.
          // super.setState(() {
          //   _value = _animationController.value;
          // });
        },
      );
    _curved = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.bounceIn,
    );
    _decoration = DecorationTween(
      begin: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
      ),
      end: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(120),
      ),
    ).animate(_curved);
    _rotation = Tween(begin: .0, end: .5).animate(_curved);
    _scale = Tween(begin: 1.0, end: 1.1).animate(_curved);
    _offset = Tween(begin: Offset.zero, end: const Offset(0, -.5)).animate(_curved);
  }

  void _play() => _animationController.forward();

  void _pause() => _animationController.stop();

  void _rewind() => _animationController.reverse();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // double _value = 0;

  // `_value` 변할 때 리렌더링 할 특정 위젯만을 고르기 위해 `ValueNotifier`를 사용한다.
  late final ValueNotifier<double> _range = ValueNotifier(.0);

  void _onChanged(double value) => _animationController.value = value;

  @override
  Widget build(BuildContext context) {
    log('build');
    return Scaffold(
      appBar: AppBar(title: const Text('Explicit Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _offset,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: const SizedBox(height: 400, width: 400),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _play, child: const Text('Play')),
                ElevatedButton(onPressed: _pause, child: const Text('Pause')),
                ElevatedButton(onPressed: _rewind, child: const Text('Rewind')),
              ],
            ),
            const SizedBox(height: 25),
            ValueListenableBuilder(
              valueListenable: _range,
              builder: (context, value, child) {
                return Slider(value: value, onChanged: _onChanged);
              },
            ),
            // Slider(value: _value, onChanged: _onChanged),
          ],
        ),
      ),
    );
  }
}
