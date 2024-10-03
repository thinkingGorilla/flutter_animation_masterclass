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
  late final Tween<double> _scale = Tween(begin: 0.8, end: 1);

  void _onHorizontalDragUpdate(DragUpdateDetails details) => _position.value += details.delta.dx;

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = _size.width - 200;
    final dropZone = _size.width + 100;
    if (_position.value.abs() >= bound) {
      _position.animateTo(dropZone * (_position.value.isNegative ? -1 : 1));
    } else {
      _position.animateTo(0, curve: Curves.bounceOut);
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swiping Cards')),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation.transform((_position.value / _size.width + 1) / 2);
          final scale = _scale.transform(_position.value.abs() / _size.width);

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: scale,
                  child: Material(
                    elevation: 10,
                    color: Colors.blue.shade100,
                    child: SizedBox(
                      width: _size.width * .8,
                      height: _size.height * .5,
                    ),
                  ),
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
