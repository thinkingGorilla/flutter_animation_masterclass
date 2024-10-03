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
  late final Tween<double> _scale = Tween(begin: 0.8, end: 1);

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
    // 애니메이션 없이 위쪽 카드를 제 위치로 돌린다.
    // _position.animateTo(0);
    _position.value = 0;

    // `_index` 값을 증가시켜 아래쪽 카드와 위쪽 카드의 이미지를 바꾼다.
    // 애니메이션이 종료되면 위쪽 카드는 사라지고 아래쪽 카드는 나타나는데,
    // setState() 메서드로 인해 위쪽 카드와 아래쪽 카드의 이미지가 바뀐다.
    // 그런데 애니메이션 종료 시점에 이미 아래쪽 카드의 이미지가
    // `_index` 값 증가에 따른 위쪽 카드의 이미지와 같으므로
    // `_position.animateTo(0)`에 의해 위쪽 카드가 제 위치로 돌아와도
    // 사용자는 동일한 카드 이미지가 보이기 때문에 마치 여러장의 카드가 있는 것처럼 느끼게 된다.
    // 이미지가 제 위치로 돌아오는 것을 확인해보려면 아래 setState() 코드 라인을 주석 처리해 보라.
    super.setState(() => _index = _index == 5 ? 1 : _index + 1);
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

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: min(scale, 1.0),
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
