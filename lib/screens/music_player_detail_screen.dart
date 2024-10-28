import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;

  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() => _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen> with TickerProviderStateMixin {
  final Duration playTime = const Duration(minutes: 1);
  final ValueNotifier<Duration> _passedTime = ValueNotifier(Duration.zero);
  final Curve _menuCurve = Curves.easeInOutCubic;

  late final AnimationController _progressController;
  late final AnimationController _marqueeController;
  late final AnimationController _playPauseController;
  late final AnimationController _menuController;

  late final Animation<Offset> _marqueeTween =
      Tween(begin: const Offset(.1, 0), end: const Offset(-.6, 0)).animate(_marqueeController);

  // 애니메이션 타임라인을 0부터 1까지라고 했을 때
  // 이 애니메이션이 차지할 타임라인을 Interval 클래스를 통해 지정할 수 있다.
  late final Animation<double> _screenScale = Tween(begin: 1.0, end: .7).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(.0, .3, curve: _menuCurve),
    ),
  );
  late final Animation<Offset> _screenOffset = Tween(begin: Offset.zero, end: const Offset(.5, 0)).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(.2, .4, curve: _menuCurve),
    ),
  );
  late final Animation<double> _closeButtonOpacity = Tween(begin: .0, end: 1.0).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(.3, .5, curve: _menuCurve),
    ),
  );

  late final List<Animation<Offset>> _menuAnimations = [
    for (int i = 0; i < _menus.length; i++)
      Tween(begin: const Offset(-1, .0), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _menuController,
          curve: Interval(.4 + (.1 * i), .7 + (.1 * i), curve: _menuCurve),
        ),
      )
  ];

  late final Animation<Offset> _logoutSlide = Tween(begin: const Offset(-1, .0), end: Offset.zero).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(.8, 1.0, curve: _menuCurve),
    ),
  );

  final ValueNotifier<double> _volume = ValueNotifier(.0);

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

    _marqueeController = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat(reverse: true);
    _playPauseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      reverseDuration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _marqueeController.dispose();
    _playPauseController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  String _timeToString(Duration time) {
    final twoDigitMin = time.inMinutes.remainder(60).toString().padLeft(2, '0');
    final twoDigitSec = time.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$twoDigitMin:$twoDigitSec';
  }

  void _onPlayPauseTap() {
    if (_playPauseController.isCompleted) {
      _playPauseController.reverse();
    } else {
      _playPauseController.forward();
    }
  }

  bool _dragging = false;

  void _toggleDragging() {
    super.setState(() {
      _dragging = !_dragging;
    });
  }

  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volume.value = (_volume.value + details.delta.dx).clamp(0, 350);
  }

  void _openMenu() {
    _menuController.forward();
  }

  void _closeMenu() {
    _menuController.reverse();
  }

  final List<Map<String, dynamic>> _menus = [
    {
      'icon': Icons.person,
      'text': 'Profile',
    },
    {
      'icon': Icons.notifications,
      'text': 'Notifications',
    },
    {
      'icon': Icons.settings,
      'text': 'Settings',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildSideMenu(),
        SlideTransition(
          position: _screenOffset,
          child: ScaleTransition(
            scale: _screenScale,
            child: _buildMusicPlayer(),
          ),
        ),
      ],
    );
  }

  Widget _buildMusicPlayer() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interstellar'),
        actions: [
          IconButton(onPressed: _openMenu, icon: const Icon(Icons.menu)),
        ],
      ),
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
          const SizedBox(height: 30),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return RepaintBoundary(
                child: CustomPaint(
                  size: const Size(350, 5),
                  painter: ProgressBar(progressValue: _progressController.value),
                ),
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
          const SizedBox(height: 5),
          const Text(
            'Interstellar',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            width: 350,
            child: SlideTransition(
              position: _marqueeTween,
              child: const Text(
                'A Film by Christopher Nolan - Original motion picture soundtrack',
                maxLines: 1,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _onPlayPauseTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedIcon(icon: AnimatedIcons.pause_play, progress: _playPauseController, size: 30),
                // LottieBuilder.asset(
                //   'assets/animations/play-lottie.json',
                //   controller: _playPauseController,
                //   onLoaded: (composition) {
                //     // lottie 애니메이션 파일에 지정된 애니메이션 시간을 애니메이션 컨트롤러의 duration으로 지정한다.
                //     _playPauseController.duration = composition.duration;
                //   },
                //   width: 50,
                //   height: 50,
                // ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onHorizontalDragUpdate: _onVolumeDragUpdate,
            onHorizontalDragStart: (_) => _toggleDragging(),
            onHorizontalDragEnd: (_) => _toggleDragging(),
            child: AnimatedScale(
              scale: _dragging ? 1.1 : 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceOut,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ValueListenableBuilder(
                  valueListenable: _volume,
                  builder: (context, value, child) {
                    return CustomPaint(
                      size: const Size(350, 50),
                      painter: VolumePainter(value),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: FadeTransition(
          opacity: _closeButtonOpacity,
          child: IconButton(onPressed: _closeMenu, icon: const Icon(Icons.close)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 30),
            for (int i = 0; i < _menus.length; i++) ...[
              SlideTransition(
                position: _menuAnimations[i],
                child: Row(
                  children: [
                    Icon(_menus[i]['icon'], color: Colors.grey.shade200),
                    const SizedBox(width: 10),
                    Text(
                      _menus[i]['text'],
                      style: TextStyle(color: Colors.grey.shade200, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
            const Spacer(),
            SlideTransition(
              position: _logoutSlide,
              child: const Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
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

class VolumePainter extends CustomPainter {
  final double volume;

  VolumePainter(this.volume);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.grey.shade300;
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(bgRect, bgPaint);

    final volumePaint = Paint()..color = Colors.grey.shade500;
    final volumePaintRect = Rect.fromLTWH(0, 0, volume, size.height);
    canvas.drawRect(volumePaintRect, volumePaint);
  }

  @override
  bool shouldRepaint(VolumePainter oldDelegate) {
    return oldDelegate.volume != volume;
  }
}
