import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/screens/apple_watch_screen.dart';
import 'package:flutter_animations_masterclass/screens/explicit_animations_screen.dart';
import 'package:flutter_animations_masterclass/screens/fade_through_screen.dart';
import 'package:flutter_animations_masterclass/screens/music_player_screen.dart';
import 'package:flutter_animations_masterclass/screens/rive_1_screen.dart';
import 'package:flutter_animations_masterclass/screens/rive_2_screen.dart';
import 'package:flutter_animations_masterclass/screens/rive_3_screen.dart';
import 'package:flutter_animations_masterclass/screens/rive_4_screen.dart';
import 'package:flutter_animations_masterclass/screens/shared_axis_screen.dart';
import 'package:flutter_animations_masterclass/screens/swiping_cards_screen.dart';
import 'package:flutter_animations_masterclass/screens/wallet_screen.dart';

import 'container_transform_screen.dart';
import 'implicit_animations_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Animations')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _goToPage(context, const ImplicitAnimationsScreen()),
              child: const Text('Implicit Animations'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const ExplicitAnimationsScreen()),
              child: const Text('Explicit Animations'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const AppleWatchScreen()),
              child: const Text('Apple Watch'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const SwipingCardsScreen()),
              child: const Text('Swiping Cards'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const MusicPlayerScreen()),
              child: const Text('Music Player'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const Rive1Screen()),
              child: const Text('Rive_1'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const Rive2Screen()),
              child: const Text('Rive_2'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const Rive3Screen()),
              child: const Text('Rive_3'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const Rive4Screen()),
              child: const Text('Rive_4'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const ContainerTransformScreen()),
              child: const Text('Material Motion 1'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const SharedAxisScreen()),
              child: const Text('Material Motion 2'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const FadeThroughScreen()),
              child: const Text('Material Motion 3'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const WalletScreen()),
              child: const Text('Wallet Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
