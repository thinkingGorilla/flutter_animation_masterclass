import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/screens/apple_watch_screen.dart';
import 'package:flutter_animations_masterclass/screens/explicit_animations_screen.dart';
import 'package:flutter_animations_masterclass/screens/music_player_screen.dart';
import 'package:flutter_animations_masterclass/screens/swiping_cards_screen.dart';

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
          ],
        ),
      ),
    );
  }
}
