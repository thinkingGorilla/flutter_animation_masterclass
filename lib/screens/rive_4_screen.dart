import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Rive4Screen extends StatefulWidget {
  const Rive4Screen({super.key});

  @override
  State<Rive4Screen> createState() => _Rive4ScreenState();
}

class _Rive4ScreenState extends State<Rive4Screen> {
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
        title: const Text('Rive4'),
      ),
      body: Stack(
        children: [
          RiveAnimation.asset(
            'assets/animations/custom-button-animation.riv',
            stateMachines: ['state'],
          ),
          Center(
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
          )
        ],
      ),
    );
  }
}
