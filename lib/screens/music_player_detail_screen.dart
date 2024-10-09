import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;

  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() => _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this, duration: Duration(seconds: 5))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Interstellar')),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: '${widget.index}',
              child: Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    )
                  ],
                  image: DecorationImage(
                    image: AssetImage('assets/covers/${widget.index}.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          CustomPaint(
            size: const Size(350, 5),
            painter: ProgressBar(
              listenable: _progressController,
              progressValue: _progressController.value,
            ),
          )
        ],
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final ValueListenable<double> listenable;
  final double progressValue;

  ProgressBar({required this.listenable, required this.progressValue}) : super(repaint: listenable);

  @override
  void paint(Canvas canvas, Size size) {
    // 애니메이션 컨트롤러의 애니메이션 값이 0부터 1이므로 이를 진행 바의 너비로 보간해야한다.
    final progress = size.width * listenable.value;
    print(progress);

    // track
    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(10));

    canvas.drawRRect(trackRRect, trackPaint);

    // progress

    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(0, 0, progress, size.height, const Radius.circular(10));

    canvas.drawRRect(progressRRect, progressPaint);

    // thumb
    canvas.drawCircle(Offset(progress, size.height / 2), 10, progressPaint);
  }

  @override
  bool shouldRepaint(ProgressBar oldDelegate) {
    return true;
  }
}
