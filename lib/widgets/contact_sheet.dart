import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/profile_data.dart';
import '../theme/theme.dart';

/// Data holder for a single contact option (email / LinkedIn / GitHub).
class ContactOption {
  final String label, subtitle;
  final IconData icon;
  final Uri uri;
  ContactOption(this.label, this.subtitle, this.icon, this.uri);
}

/// Pre-built list of contact options derived from [ProfileData].
final List<ContactOption> contactOptions = [
  ContactOption(
    'Email',
    ProfileData.email,
    Icons.email_outlined,
    Uri.parse('mailto:${ProfileData.email}'
        '?subject=${Uri.encodeComponent('Hello Atharva')}'),
  ),
  ContactOption(
    'LinkedIn',
    'linkedin.com/in/atharva-shirale',
    Icons.work_outline,
    Uri.parse(ProfileData.linkedin),
  ),
  ContactOption(
    'GitHub',
    'github.com/AtharvaShirale',
    Icons.code,
    Uri.parse(ProfileData.github),
  ),
];

/// Opens a URL using the platform's default handler (browser / mail client).
///
/// [url_launcher]'s `launchUrl` returns a [Future<bool>].  If it fails and
/// the calling widget is still mounted, we show a [SnackBar] so the user
/// knows something went wrong.
Future<void> openLink(BuildContext context, Uri uri) async {
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Could not open link')));
  }
}

/// Shows a modal bottom sheet with contact options.
///
/// [showModalBottomSheet] creates a material sheet that slides up from the
/// bottom.  Each list tile opens the corresponding link and pops the sheet.
void showContactSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 12),
        Text('Get in touch', style: heading(ctx, size: 20)),
        for (final o in contactOptions)
          ListTile(
            leading: Icon(o.icon),
            title: Text(o.label),
            subtitle: Text(o.subtitle),
            onTap: () {
              Navigator.pop(ctx);
              openLink(context, o.uri);
            },
          ),
        const SizedBox(height: 8),
      ]),
    ),
  );
}
