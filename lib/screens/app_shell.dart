import 'package:flutter/material.dart';

import '../painters/warli_painters.dart';
import '../theme/theme.dart';
import 'home_screen.dart';
import 'projects_screen.dart';
import 'contact_screen.dart';

/// The main scaffold that hosts the bottom [NavigationBar] and swaps between
/// the three tab screens.
///
/// [StatefulWidget] is needed here because the selected tab index (`_i`)
/// is mutable state.  [AnimatedSwitcher] cross-fades between pages.
class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _i = 0;
  final _pages = const [HomeScreen(), ProjectsScreen(), ContactScreen()];

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Atharva', style: heading(context, size: 22)),
        actions: const [ThemeToggle()],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: KeyedSubtree(key: ValueKey(_i), child: _pages[_i]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _i,
        onDestinationSelected: (i) => setState(() => _i = i),
        destinations: [
          NavigationDestination(
              icon: WarliIcon(0, p.sub, semanticsLabel: 'Home tab'),
              selectedIcon:
                  WarliIcon(0, p.accent, semanticsLabel: 'Home tab selected'),
              label: 'Home'),
          NavigationDestination(
              icon: WarliIcon(1, p.sub, semanticsLabel: 'Projects tab'),
              selectedIcon: WarliIcon(1, p.accent,
                  semanticsLabel: 'Projects tab selected'),
              label: 'Projects'),
          NavigationDestination(
              icon: WarliIcon(2, p.sub, semanticsLabel: 'Contact tab'),
              selectedIcon: WarliIcon(2, p.accent,
                  semanticsLabel: 'Contact tab selected'),
              label: 'Contact'),
        ],
      ),
    );
  }
}

/// A toggle button that switches between light and dark themes.
///
/// Uses [ValueListenableBuilder] to rebuild only when [themeMode] changes.
/// The icon itself is wrapped in an [AnimatedSwitcher] so it rotates and
/// fades when toggling.
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (ctx, mode, _) {
          final isDark = mode == ThemeMode.dark;
          return Semantics(
            label: isDark
                ? 'Switch to light theme'
                : 'Switch to dark theme',
            button: true,
            child: IconButton(
              onPressed: () =>
                  themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark,
              // Ensure 48x48 minimum tap target.
              constraints: const BoxConstraints(
                  minWidth: 48, minHeight: 48),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => RotationTransition(
                    turns: anim,
                    child: FadeTransition(opacity: anim, child: child)),
                child: Icon(
                    isDark
                        ? Icons.dark_mode_rounded
                        : Icons.wb_sunny_rounded,
                    key: ValueKey(isDark)),
              ),
            ),
          );
        },
      );
}
