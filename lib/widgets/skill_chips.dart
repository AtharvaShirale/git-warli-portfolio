import 'package:flutter/material.dart';

import '../data/profile_data.dart';
import '../theme/theme.dart';

/// A horizontal [Wrap] of rounded chips showing the skills list.
///
/// [StatelessWidget] is used because this widget has no internal state —
/// it just reads from [ProfileData.skills] and the current theme.
/// Each chip uses an outlined style tinted with the accent colour so it
/// looks consistent in both light and dark mode.
class SkillChips extends StatelessWidget {
  const SkillChips({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Skills', style: heading(context, size: 22)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final skill in ProfileData.skills)
              Chip(
                label: Text(
                  skill,
                  style: TextStyle(
                    color: p.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                side: BorderSide(color: p.accent.withAlpha(120)),
                backgroundColor: p.accent.withAlpha(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                // Ensure minimum 48x48 tap target for accessibility.
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
          ],
        ),
      ],
    );
  }
}
