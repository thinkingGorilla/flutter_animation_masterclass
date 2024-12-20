import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/screens/music_player_detail_screen.dart';

// For support swipe with mouse, we need to change default scroll behavior of app
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8)
      ..addListener(
        () {
          if (_pageController.page == null) return;
          _scroll.value = _pageController.page!;
        },
      );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _currentPage = 0;

  final ValueNotifier<double> _scroll = ValueNotifier(.0);

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  void _onTap(int imageIndex) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        reverseTransitionDuration: const Duration(seconds: 1),
        // pageBuilder에서 주어지는 animation을 사용하여
        // 페이지 전환 시 다양한 애니메이션을 만들어낼 수 있다.
        pageBuilder: (context, animation, secondaryAnimation) {
          /*
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.scale(
                scale: animation.value,
                child: MusicPlayerDetailScreen(index: imageIndex),
              );
            },
          );
          */
          /*
          return RotationTransition(
            turns: animation,
            child: MusicPlayerDetailScreen(index: imageIndex),
          );
          */
          /*
          final offset = Tween<Offset>(begin: const Offset(1, 1), end: Offset.zero).animate(animation);
          return SlideTransition(
            position: offset,
            child: MusicPlayerDetailScreen(index: imageIndex),
          );
          */
          return FadeTransition(opacity: animation, child: MusicPlayerDetailScreen(index: imageIndex));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/covers/${_currentPage + 1}.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              // 상위 위젯 화면과 BackdropFilter의 자식 위젯의 화면이 겹치는 부분에 ImageFilter를 적용한다.
              // 만약 BackdropFilter의 자식 위젯이 없다면 상위 위젯 화면과 겹치는 부분이 없어
              // ImageFilter를 적용되지 않고 이에 따라 상위 위젯 화면이 출력되지 않는다.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          PageView.builder(
            onPageChanged: _onPageChanged,
            scrollBehavior: AppScrollBehavior(),
            controller: _pageController,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _scroll,
                    builder: (context, scroll, child) {
                      final difference = scroll - index;
                      print('We are $difference cards away from card $index');

                      final scale = 1 - (difference.abs() * 0.1);
                      print('The card ${index + 1} has a scale of $scale');

                      return GestureDetector(
                        onTap: () => _onTap(index + 1),
                        child: Hero(
                          tag: '${index + 1}',
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              height: 350,
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
                                  image: AssetImage('assets/covers/${index + 1}.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 35),
                  Text(
                    'Intersellar',
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Hans Zimmer',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
