import 'package:flutter/material.dart';

import '../data/profile_data.dart';
import '../painters/warli_painters.dart';
import '../theme/theme.dart';
import '../widgets/contact_sheet.dart';

/// The Projects tab shows an animated list of project cards.
///
/// [StatelessWidget] is fine here — there is no mutable state.
/// The entrance animation uses [TweenAnimationBuilder], which is an
/// *implicit* animation widget: you give it a tween and duration and it
/// handles the controller internally.  This avoids the boilerplate of
/// creating an explicit [AnimationController] for a one-shot effect.
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final items = ProfileData.projects;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length + 1,
      itemBuilder: (c, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Projects', style: heading(context, size: 30)),
                  WarliDivider(color: p.accent),
                ]),
          );
        }
        final pr = items[i - 1];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 500 + i * 150),
          curve: Curves.easeOut,
          builder: (_, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(
                  offset: Offset(0, 30 * (1 - v)), child: child)),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
                color: p.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: p.line)),
            child: Theme(
              data: Theme.of(context)
                  .copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(pr.title, style: heading(context, size: 18)),
                subtitle: Text(pr.stack,
                    style: TextStyle(color: p.accent)),
                childrenPadding:
                    const EdgeInsets.fromLTRB(16, 0, 16, 12),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pr.description,
                      style: TextStyle(color: p.sub, height: 1.5)),
                  if (pr.link.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () =>
                          openLink(context, Uri.parse(pr.link)),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('View on GitHub'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
