import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() => _ExplicitAnimationsScreenState();
}

// `SingleTickerProviderStateMixin`는 현재 화면이 트리에 있을 때만 사용가능한 `Ticker`를 제공한다.
class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    // 애니메이션이 매 프레임마다 실행되어야하므로
    // `SingleTickerProviderStateMixin`로부터 제공받은 `Ticker`를 애니메이션을 제어하는 컨트롤러에 동기화한다.
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    // `Ticker`는 매 프레임마다 콜백 함수를 호출한다.
    // `Ticker`를 생성한 화면이 트리에서 사라져도 `Ticker`는 계속 동작한다.
    // Ticker((elapsed) => print(elapsed)).start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explicit Animations')),
    );
  }
}
