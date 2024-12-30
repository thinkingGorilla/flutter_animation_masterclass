import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Rive2Screen extends StatefulWidget {
  const Rive2Screen({super.key});

  @override
  State<Rive2Screen> createState() => _Rive2ScreenState();
}

class _Rive2ScreenState extends State<Rive2Screen> {
  late final StateMachineController _stateMachineController;

  void _onInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      'state',
      onStateChange: (stateMachineName, stateName) {
        print(stateMachineName);
        print(stateName);
      },
    )!;
    artboard.addController(_stateMachineController);
  }

  @override
  void dispose() {
    _stateMachineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive2'),
      ),
      body: Center(
        child: Container(
          color: Color(0xffff2ecc),
          height: 400,
          width: 400,
          child: RiveAnimation.asset(
            'assets/animations/stars-animation.riv',
            artboard: 'artboard',
            stateMachines: ['state'],
            onInit: _onInit,
          ),
        ),
      ),
    );
  }
}
