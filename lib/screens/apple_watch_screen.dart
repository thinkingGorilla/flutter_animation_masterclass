import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: .005,
      upperBound: 2.0,
    );
  }

  void _animateValues() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Apple Watch'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(progress: _animationController.value),
              size: const Size(400, 400),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double progress;

  AppleWatchPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const startingAngle = -.5 * pi;

    // draw red
    final redCirclePaint = Paint()
      ..color = Colors.red.shade500.withOpacity(.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final redCircleRadius = (size.width / 2) * .9;

    canvas.drawCircle(center, redCircleRadius, redCirclePaint);

    // draw green
    final greenCirclePaint = Paint()
      ..color = Colors.green.shade500.withOpacity(.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final greenCircleRadius = (size.width / 2) * .76;

    canvas.drawCircle(center, greenCircleRadius, greenCirclePaint);

    // draw blue
    final blueCirclePaint = Paint()
      ..color = Colors.cyan.shade500.withOpacity(.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final blueCircleRadius = (size.width / 2) * .62;

    canvas.drawCircle(center, blueCircleRadius, blueCirclePaint);

    // red arc
    final redArcRect = Rect.fromCircle(center: center, radius: redCircleRadius);
    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(redArcRect, startingAngle, progress * pi, false, redArcPaint);

    // green arc
    final greenArcRect = Rect.fromCircle(center: center, radius: greenCircleRadius);
    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(greenArcRect, startingAngle, progress * pi, false, greenArcPaint);

    // blue arc
    final blueArcRect = Rect.fromCircle(center: center, radius: blueCircleRadius);
    final blueArcPaint = Paint()
      ..color = Colors.cyan.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(blueArcRect, startingAngle, progress * pi, false, blueArcPaint);
  }

  @override
  bool shouldRepaint(AppleWatchPainter oldDelegate) {
    // `false`를 반환하는 경우 새로운 CustomPainter 인스턴스가 생성되어도
    // paint() 메서드를 다시 호출하지 않는다.
    // 예를 들어 `AnimationController`에 의해 애니메이션이 진행되면서 `value` 값이 계속 바뀌는데
    // 이로 인해 AppleWatchPainter 새로운 인스턴스가 생성된다.
    // 이때 타입이 같은 새로운 인스턴스가 생성되었지만 `shouldRepaint()`가 `false`를 반환하므로
    // paint() 메서드는 호출되지 않아 애니메이션에 의한 새로운 화면이 렌더링 되지 않는다.
    // return false

    // 아래의 코드와 `true`를 반환하는 것은 동등하다.
    // 애니메이션 값이 바뀌어 새로운 인스턴스가 생기고 그래서 항상 다시 그린다는 의미의 `true`와
    // 애니메이션 값을 비교하여 바뀐 것을 확인하는 것은 같다.
    return oldDelegate.progress != progress;
  }
}
