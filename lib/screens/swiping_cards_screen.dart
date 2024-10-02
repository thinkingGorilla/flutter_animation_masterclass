import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen> with SingleTickerProviderStateMixin {
  late Size _size;

  late final AnimationController _position = AnimationController.unbounded(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    value: 0,
  );

  late final Tween<double> _rotation = Tween(begin: -15.0, end: 15.0);

  void _onHorizontalDragUpdate(DragUpdateDetails details) => _position.value += details.delta.dx;

  void _onHorizontalDragEnd(DragEndDetails details) => _position.animateTo(0, curve: Curves.bounceOut);

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Swiping Cards')),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          // `transform`은 0부터 1사이의 값을 사용하여 `begin`부터 `end`사이의 값을 보간하여 구한다.
          // 따라서 -15도부터 +15도 사이의 각도 값을 구하기 위해서는
          // 먼저 `_position` 값을 0부터 1사이의 값으로 변환해야한다.
          // [-width, 0, +width]를 `width`로 나눈다.
          // [-1, 0, +1]에 1을 더한다.
          // [0, 1, 2]를 2로 나눈다.
          // [0, 0, 1] = 0부터 1
          // 결론적으로 `position`를 `width`로 나누고 1을 더하고 2로 나누면 0부터 1사이의 값으로 변환할 수 있다.
          final angle = _rotation.transform((_position.value / _size.width + 1) / 2);
          // print(angle);
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      // 각도를 호도법으로 변환한다.(2*pi[*rad] / 360도)
                      angle: angle * pi / 180,
                      child: Material(
                        elevation: 10,
                        color: Colors.red.shade100,
                        child: SizedBox(
                          width: _size.width * .8,
                          height: _size.height * .5,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
