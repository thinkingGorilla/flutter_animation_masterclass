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
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
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
              )
            ],
          );
        },
      ),
    );
  }
}
