import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() => _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    // `AnimationController`의 addListener() 함수를 통해 매 프레임마다 setState()를 호출하여 화면을 리렌더링한다.
    // 하지만 매 프레임마다 화면 전체에 대해 setState()를 호출하는 것은 매우 비효율적이다.
    // ..addListener(() => setState(() {}));

    // `Timer`를 이용하여 setState()를 호출하여 화면을 리렌더링한다.
    // 하지만 다시 리렌더링하기 위해 `periodic` 동안 기다려야하는 문제점이 있다.
    // Timer.periodic(const Duration(milliseconds: 500), (_) => super.setState(() {}));
  }

  void _play() => _animationController.forward();

  void _pause() => _animationController.stop();

  void _rewind() => _animationController.reverse();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explicit Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 애니메이션에 의해 리렌더링되는 영역을 AnimatedBuilder 위젯 안의 영역으로 제한한다.
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  // `AnimationController`의 value 값은 0부터 1까지 범위의 값을 가지는데
                  // 이 값들만으로는 다양한 애니메이션을 만들 수 없다.
                  // 이를 해결하기 위해 `Tween`을 사용한다.
                  opacity: _animationController.value,
                  child: Container(
                    color: Colors.amber,
                    width: 400,
                    height: 400,
                  ),
                );
              },
            ),
            // Text(
            //   '${_animationController.value}',
            //   style: const TextStyle(fontSize: 28),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _play, child: const Text('Play')),
                ElevatedButton(onPressed: _pause, child: const Text('Pause')),
                ElevatedButton(onPressed: _rewind, child: const Text('Rewind')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
