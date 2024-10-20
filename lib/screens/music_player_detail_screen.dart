import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;

  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() => _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen> with SingleTickerProviderStateMixin {
  final Duration playTime = const Duration(minutes: 1);
  final ValueNotifier<Duration> _passedTime = ValueNotifier(Duration.zero);

  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this, duration: playTime)
      ..forward()
      ..addListener(
        () {
          _passedTime.value = Duration(seconds: (playTime.inSeconds * _progressController.value).toInt());
        },
      );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  String _timeToString(Duration time) {
    final twoDigitMin = time.inMinutes.remainder(60).toString().padLeft(2, '0');
    final twoDigitSec = time.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$twoDigitMin:$twoDigitSec';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Interstellar')),
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
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(350, 5),
                painter: ProgressBar(progressValue: _progressController.value),
              );
            },
          ),
          const SizedBox(height: 10),
          // AnimatedBuilder vs ValueListenableBuilder
          // 연속성을 가지는 값을 가지는 경우 AnimatedBuilder를 그렇지 않은 경우 ValueListenableBuilder를 사용하자.
          // 하지만 결국 두 Builder 모두 내부적으로는 Listenable을 사용하며
          // 옵저버 패턴을 통해 Oservable, 즉 Listenable에 값이 바뀔 때 setState()를 호출하여
          // 빌더에서 반환하는 위젯의 상태를 변경, 다시 화면을 그리게 된다.
          SizedBox(
            width: 350,
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: _passedTime,
                  builder: (context, value, child) {
                    return Text(
                      _timeToString(value),
                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                    );
                  },
                ),
                const Spacer(),
                ValueListenableBuilder(
                  valueListenable: _passedTime,
                  builder: (context, value, child) {
                    final remainedTime = playTime - value;
                    return Text(
                      _timeToString(remainedTime),
                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Interstellar',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            'A Film by Chritopher Nolan - Original motion picture soundstack',
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({super.repaint, required this.progressValue});

  @override
  void paint(Canvas canvas, Size size) {
    // 애니메이션 컨트롤러의 애니메이션 값이 0부터 1이므로 이를 진행 바의 너비로 보간해야한다.
    final progress = size.width * progressValue;

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
    return oldDelegate.progressValue != progressValue;
  }
}
