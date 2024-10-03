import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen> with SingleTickerProviderStateMixin {
  late final Size _size = MediaQuery.of(context).size;
  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    value: 0,
    lowerBound: _size.width * -1,
    upperBound: _size.width,
  );
  late final Tween<double> _rotation = Tween(begin: -15.0, end: 15.0);
  late final Tween<double> _scale = Tween(begin: .8, end: 1);

  late final Tween<double> _buttonScale = Tween(begin: 1, end: 1.15);
  late final ColorTween _rejectButtonColor = ColorTween(begin: Colors.white, end: Colors.red.shade200);
  late final ColorTween _confirmButtonColor = ColorTween(begin: Colors.white, end: Colors.green.shade200);

  void _onHorizontalDragUpdate(DragUpdateDetails details) => _position.value += details.delta.dx;

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = _size.width - 200;
    final dropZone = _size.width + 100;
    if (_position.value.abs() >= bound) {
      _position.animateTo(dropZone * (_position.value.isNegative ? -1 : 1)).whenComplete(_whenComplete);
    } else {
      _position.animateTo(0, curve: Curves.bounceOut);
    }
  }

  _whenComplete() {
    _position.value = 0;
    super.setState(() => _index = _index == 5 ? 1 : _index + 1);
  }

  void _onReject() {
    if (_position.isAnimating) return;
    _position.reverse().whenComplete(_whenComplete);
  }

  void _onConfirm() {
    if (_position.isAnimating) return;
    _position.forward().whenComplete(_whenComplete);
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swiping Cards')),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation.transform((_position.value / _size.width + 1) / 2) * pi / 180;
          final scale = _scale.transform(_position.value.abs() / _size.width);

          final buttonScale = _buttonScale.transform(_position.value.abs() / _size.width);
          final rejectButtonColor = _rejectButtonColor.transform(-(_position.value / _size.width));
          final confirmButtonColor = _confirmButtonColor.transform(_position.value / _size.width);

          final iconColorBound = _size.width - 200;

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: min(scale, 1),
                  child: Card(index: _index == 5 ? 1 : _index + 1),
                ),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      // 각도를 호도법으로 변환한다.(2*pi[*rad] / 360도)
                      angle: angle,
                      child: Card(index: _index),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _onReject,
                      child: Transform.scale(
                        scale: _position.value.isNegative ? buttonScale : 1,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: rejectButtonColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, offset: Offset(1, 5), blurRadius: 10),
                            ],
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: _position.value > -iconColorBound ? Colors.red : Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: _onConfirm,
                      child: Transform.scale(
                        scale: _position.value.isNegative ? 1 : buttonScale,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: confirmButtonColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, offset: Offset(1, 5), blurRadius: 10),
                            ],
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: _position.value < iconColorBound ? Colors.green : Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size.width * .8,
        height: size.height * .5,
        child: Image.asset(
          'assets/covers/$index.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
