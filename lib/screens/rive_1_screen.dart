import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Rive1Screen extends StatefulWidget {
  const Rive1Screen({super.key});

  @override
  State<Rive1Screen> createState() => _Rive1ScreenState();
}

class _Rive1ScreenState extends State<Rive1Screen> {
  late final StateMachineController _stateMachineController;

  void _onInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(artboard, 'state')!;
    artboard.addController(_stateMachineController);
  }

  void _togglePanel() {
    final input = _stateMachineController.findInput<bool>('panelActive')!;
    input.change(!input.value);
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
        title: const Text('Rive1'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: 400,
              child: RiveAnimation.asset(
                'assets/animations/old-man-animation.riv',
                artboard: 'main',
                stateMachines: ['state'],
                onInit: _onInit,
              ),
            ),
            ElevatedButton(
              onPressed: _togglePanel,
              child: const Text('Go!'),
            ),
          ],
        ),
      ),
    );
  }
}
