import '../models/project.dart';

/// All personal / portfolio data lives here.
///
/// Keeping everything in one file makes it easy to update details
/// (name, bio, projects) without hunting through widget code.
class ProfileData {
  static const name = 'Atharva Shirale';
  static const initials = 'AS';
  static const role = 'Software Developer';
  static const email = 'shiraleatharva@gmail.com';
  static const github = 'https://github.com/AtharvaShirale';
  static const linkedin = 'https://www.linkedin.com/in/atharva-shirale';

  /// Short one-line college info shown on the profile card.
  static const college =
      '2nd Year · Vishwakarma Institute of Technology, Pune';

  static const bio =
      'Second-year student at Vishwakarma Institute of Technology, Pune. '
      'I enjoy app development and problem solving with DSA, and I\'m '
      'currently building mobile apps with Flutter.';

  /// Skills displayed as chips on the Home screen.
  static const skills = <String>[
    'Java',
    'C',
    'C++',
    'Python',
    'DSA',
    'Flutter',
    'Git',
  ];

  static const projects = <Project>[
    Project(
      'Warli Portfolio',
      'A Flutter portfolio app with a Warli-art inspired UI, '
          'custom-painted animations, light/dark theme and a flip profile card.',
      'Flutter · Dart · CustomPainter',
      'https://github.com/AtharvaShirale/git-warli-portfolio',
    ),
    // TODO: replace with real project
    Project(
      'Project title (update me)',
      'Short description of your second project.',
      'Stack · goes · here',
      'https://github.com/AtharvaShirale',
    ),
    // TODO: replace with real project
    Project(
      'Project title (update me)',
      'Short description of your third project.',
      'Stack · goes · here',
      'https://github.com/AtharvaShirale',
    ),
  ];
}
