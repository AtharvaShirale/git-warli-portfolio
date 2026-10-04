import 'package:flutter/material.dart';

import '../data/profile_data.dart';
import '../painters/warli_painters.dart';
import '../theme/theme.dart';
import 'app_shell.dart';

/// The splash screen shows a Warli drawing that "paints itself", then
/// navigates to the main app shell.
///
/// This is a [StatefulWidget] because it owns an [AnimationController].
/// [SingleTickerProviderStateMixin] gives us a single [Ticker] — one
/// "heartbeat" that fires every frame to update the animation value.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If the user prefers reduced motion, skip the animation entirely.
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) {
      // Jump straight to the app shell.
      _go();
    } else if (!_c.isAnimating && !_c.isCompleted) {
      _c.forward().whenComplete(_go);
    }
  }

  void _go() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, _, _) => const AppShell(),
      transitionsBuilder: (_, a, _, child) =>
          FadeTransition(opacity: a, child: child),
    ));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, _) => Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
                width: 270,
                height: 130,
                child: CustomPaint(
                    painter: SplashPainter(_c.value, p.accent))),
            const SizedBox(height: 20),
            Opacity(
                opacity: c01((_c.value - 0.6) * 2.5),
                child: Text(ProfileData.name,
                    style: heading(context, size: 28))),
            Opacity(
                opacity: c01((_c.value - 0.7) * 3),
                child: Text('Code, drawn the Warli way',
                    style: TextStyle(color: p.sub))),
          ]),
        ),
      ),
    );
  }
}
