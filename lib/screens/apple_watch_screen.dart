import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final CurvedAnimation _curve;

  late Animation<double> _redArcProgress;
  late Animation<double> _greenArcProgress;
  late Animation<double> _blueArcProgress;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _curve = CurvedAnimation(parent: _animationController, curve: Curves.bounceOut);

    _redArcProgress = _createAnimation();
    _greenArcProgress = _createAnimation();
    _blueArcProgress = _createAnimation();
  }

  Animation<double> _createAnimation({double begin = 0.05, double? end, bool mulFactor = false}) {
    end ??= Random().nextDouble() * (mulFactor ? 2 : 1);
    return Tween(begin: begin, end: end).animate(_curve);
  }

  void _animateValues() {
    super.setState(() {
      _redArcProgress = _createAnimation(begin: _redArcProgress.value, mulFactor: true);
      _greenArcProgress = _createAnimation(begin: _greenArcProgress.value, mulFactor: true);
      _blueArcProgress = _createAnimation(begin: _blueArcProgress.value, mulFactor: true);
    });

    _animationController.forward(from: 0);
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
              painter: AppleWatchPainter(
                redArcProgress: _redArcProgress.value,
                greenArcProgress: _greenArcProgress.value,
                blueArcProgress: _blueArcProgress.value,
              ),
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
  final double redArcProgress;
  final double greenArcProgress;
  final double blueArcProgress;

  AppleWatchPainter({
    required this.redArcProgress,
    required this.greenArcProgress,
    required this.blueArcProgress,
  });

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

    canvas.drawArc(redArcRect, startingAngle, redArcProgress * pi, false, redArcPaint);

    // green arc
    final greenArcRect = Rect.fromCircle(center: center, radius: greenCircleRadius);
    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(greenArcRect, startingAngle, greenArcProgress * pi, false, greenArcPaint);

    // blue arc
    final blueArcRect = Rect.fromCircle(center: center, radius: blueCircleRadius);
    final blueArcPaint = Paint()
      ..color = Colors.cyan.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(blueArcRect, startingAngle, blueArcProgress * pi, false, blueArcPaint);
  }

  @override
  bool shouldRepaint(AppleWatchPainter oldDelegate) {
    return true;
  }
}
