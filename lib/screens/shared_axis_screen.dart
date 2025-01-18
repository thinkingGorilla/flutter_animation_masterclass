import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisScreen extends StatefulWidget {
  const SharedAxisScreen({super.key});

  @override
  State<SharedAxisScreen> createState() => _SharedAxisScreenState();
}

class _SharedAxisScreenState extends State<SharedAxisScreen> {
  int _currentImage = 1;

  void _goToImage(int newImage) {
    setState(() {
      _currentImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shared Axis')),
      body: Column(
        children: [
          PageTransitionSwitcher(
            duration: Duration(seconds: 1),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) => SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
              child: child,
            ),
            child: Container(
              // 새로운 위젯이 생성되었음을 플러터 엔진에 알리기 위해 ValueKey를 사용한다.
              key: ValueKey(_currentImage),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/covers/$_currentImage.jpg',
                width: 300,
                height: 300,
              ),
            ),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var btn in [1, 2, 3, 4, 5]) ElevatedButton(onPressed: () => _goToImage(btn), child: Text('$btn')),
            ],
          )
        ],
      ),
    );
  }
}
