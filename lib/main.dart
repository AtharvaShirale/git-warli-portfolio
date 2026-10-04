import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/theme.dart';

/// App entry point.
///
/// [runApp] inflates the widget tree and attaches it to the screen.
/// [WarliApp] is a [StatelessWidget] because it holds no mutable state —
/// the theme mode lives in a global [ValueNotifier] (see theme.dart).
void main() => runApp(const WarliApp());

class WarliApp extends StatelessWidget {
  const WarliApp({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        // ValueListenableBuilder rebuilds its subtree whenever the
        // ValueNotifier's value changes.  This is how the whole app
        // switches between light and dark without a state-management package.
        valueListenable: themeMode,
        builder: (_, mode, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Atharva · Warli Portfolio',
          themeMode: mode,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          home: const SplashScreen(),
        ),
      );
}
