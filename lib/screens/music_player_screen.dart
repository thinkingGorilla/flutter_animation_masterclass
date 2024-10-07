import 'dart:ui';

import 'package:flutter/material.dart';

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
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _currentPage = 0;

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
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
                  Container(
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
