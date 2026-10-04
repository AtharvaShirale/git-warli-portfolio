import 'package:flutter/material.dart';

import '../painters/warli_painters.dart';
import '../theme/theme.dart';
import '../widgets/contact_sheet.dart';

/// The Contact tab displays a list of clickable contact options.
///
/// This is a [StatelessWidget] — it has no state of its own.  All data
/// comes from [contactOptions] (defined in contact_sheet.dart).
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text('Contact', style: heading(context, size: 30)),
      WarliDivider(color: p.accent),
      const SizedBox(height: 16),
      for (final o in contactOptions)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
              color: p.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: p.line)),
          child: ListTile(
            leading: Icon(o.icon, color: p.accent),
            title: Text(o.label, style: heading(context, size: 18)),
            subtitle: Text(o.subtitle, style: TextStyle(color: p.sub)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => openLink(context, o.uri),
          ),
        ),
    ]);
  }
}
