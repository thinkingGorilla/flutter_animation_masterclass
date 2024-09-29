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
    );
    // 모든 `Tween`들이 `AnimationController`를 직접 사용하는 것이 아니라
    // `Curve`가 적용된 `CurvedAnimation`을 따라 애니메이션이 수행되도록 한다.
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

  @override
  Widget build(BuildContext context) {
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
            )
          ],
        ),
      ),
    );
  }
}
