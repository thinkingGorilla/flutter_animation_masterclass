import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() => _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Decoration> _decoration;
  late final Animation<double> _rotation;
  late final Animation<double> _scale;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _decoration = DecorationTween(
      begin: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
      ),
      end: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(120),
      ),
    ).animate(_animationController);
    _rotation = Tween(begin: .0, end: 2.0).animate(_animationController);
    _scale = Tween(begin: 1.0, end: 1.1).animate(_animationController);
    _offset = Tween(begin: Offset.zero, end: const Offset(0, -.5)).animate(_animationController);
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
            // Implicit animation 구현 시 Animated~ 위젯을 이용하여 구현한다.
            // Animated~ 위젯으로 애니메이션을 구현할 수 없을 때는 `Explicit animation`로 구현한다.
            // Explicit animation 구현 시 ~Transition 위젯을 이용하여 구현한다.
            // ~Transition 위젯 위젯으로 애니메이션을 구현할 수 없을 때는 AnimatedBuilder 위젯로 구현한다.
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
            )
          ],
        ),
      ),
    );
  }
}
