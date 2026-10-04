import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../painters/warli_painters.dart';
import '../theme/theme.dart';
import '../widgets/profile_card.dart';
import '../widgets/skill_chips.dart';

/// The Home tab — profile card, intro text, skills, and the Tarpa dance.
///
/// Uses a [StatefulWidget] so we can own an [AnimationController] for the
/// continuously rotating Tarpa dance at the bottom.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(seconds: 30));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect the user's "reduce motion" accessibility preference.
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (!reduceMotion && !_c.isAnimating) {
      _c.repeat();
    } else if (reduceMotion && _c.isAnimating) {
      _c.stop();
      _c.value = 0;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return ListView(padding: const EdgeInsets.all(20), children: [
      const ProfileCard(),
      const SizedBox(height: 24),
      WarliDivider(color: p.accent),
      const SizedBox(height: 16),
      Text('Hi, I am Atharva', style: heading(context, size: 22)),
      const SizedBox(height: 6),
      Text(
          'Welcome to my portfolio. Explore my projects or get in touch.',
          style: TextStyle(color: p.sub, height: 1.5)),
      const SizedBox(height: 20),
      // Skills section
      const SkillChips(),
      const SizedBox(height: 16),
      SizedBox(
        height: 220,
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, _) => CustomPaint(
              painter:
                  TarpaPainter(_c.value * 2 * math.pi, p.accent)),
        ),
      ),
      Center(
          child: Text('Inspired by Warli art of Maharashtra',
              style: TextStyle(color: p.sub, fontSize: 12))),
    ]);
  }
}
