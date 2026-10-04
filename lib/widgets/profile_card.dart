import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../data/profile_data.dart';
import '../painters/warli_painters.dart';
import '../theme/theme.dart';
import 'contact_sheet.dart';

/// A flip-able profile card — tap to see the back (bio) side.
///
/// This is a [StatefulWidget] because it owns two [AnimationController]s:
/// one for the flip and one for the spinning Warli ring.  A
/// [StatelessWidget] cannot hold controllers because it has no mutable
/// state or lifecycle methods like [dispose].
///
/// The flip effect works by driving a value from 0→1, multiplying by π to
/// get radians, and applying [Matrix4.rotationY].  When the angle exceeds
/// π/2 the card is edge-on, so we swap to the back face (mirrored by
/// another `rotationY(π)` so text reads correctly).
class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});
  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard>
    with TickerProviderStateMixin {
  /// Controls the 0→1→0 flip animation.
  late final AnimationController _flip = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 450));

  /// Continuous rotation for the decorative Warli ring around the avatar.
  late final AnimationController _spin =
      AnimationController(vsync: this, duration: const Duration(seconds: 24));

  bool _back = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If the user has enabled "reduce motion" in their OS accessibility
    // settings, MediaQuery.disableAnimations will be true.  In that case
    // we skip the spinning ring animation entirely.
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (!reduceMotion && !_spin.isAnimating) {
      _spin.repeat();
    } else if (reduceMotion && _spin.isAnimating) {
      _spin.stop();
      _spin.value = 0;
    }
  }

  void _toggle() {
    _back ? _flip.reverse() : _flip.forward();
    _back = !_back;
  }

  @override
  void dispose() {
    _flip.dispose();
    _spin.dispose();
    super.dispose();
  }

  /// Card container — no fixed height so the content can grow flexibly.
  Widget _shell(Palette p, Widget child) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: p.line),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ],
        ),
        child: child,
      );

  Widget _front(Palette p) => _shell(
        p,
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Semantics(
            label: 'Photo of Atharva Shirale',
            child: AnimatedBuilder(
              animation: _spin,
              builder: (_, _) => SizedBox(
                width: 116,
                height: 116,
                child: Stack(alignment: Alignment.center, children: [
                  CustomPaint(
                      size: const Size(116, 116),
                      painter: RingPainter(
                          _spin.value * 2 * math.pi, p.accent)),
                  ClipOval(
                    child: Image.asset(
                      'assets/photo.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => CircleAvatar(
                        radius: 40,
                        backgroundColor: p.accent,
                        child: Text(ProfileData.initials,
                            style: heading(context, size: 30)
                                .copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(ProfileData.name, style: heading(context, size: 26)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
                color: p.accent.withAlpha(35),
                borderRadius: BorderRadius.circular(20)),
            child: Text(ProfileData.role,
                style:
                    TextStyle(color: p.accent, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 6),
          // College line shown just under the role chip.
          Text(
            ProfileData.college,
            style: TextStyle(color: p.sub, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Semantics(
            button: true,
            label: 'Contact Atharva',
            child: FilledButton.icon(
              onPressed: () => showContactSheet(context),
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Contact'),
              style: FilledButton.styleFrom(
                  backgroundColor: p.accent,
                  foregroundColor: Colors.white,
                  // Ensure at least 48px tall for accessibility.
                  minimumSize: const Size(0, 48)),
            ),
          ),
          const SizedBox(height: 8),
          Semantics(
            hint: 'Tap the card to flip and see the bio on the back',
            child: Text('Tap card to flip',
                style: TextStyle(color: p.sub, fontSize: 12)),
          ),
        ]),
      );

  Widget _backFace(Palette p) => _shell(
        p,
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('About', style: heading(context, size: 24)),
          const SizedBox(height: 12),
          Text(ProfileData.bio,
              textAlign: TextAlign.center,
              style: TextStyle(color: p.sub, height: 1.5)),
          const SizedBox(height: 20),
          Text('Tap to flip back',
              style: TextStyle(color: p.sub, fontSize: 12)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      label: 'Profile card for ${ProfileData.name}',
      hint: 'Double tap to flip',
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedBuilder(
          animation: _flip,
          builder: (_, _) {
            final angle = _flip.value * math.pi;
            final showBack = angle > math.pi / 2;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: showBack
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: _backFace(p))
                  : _front(p),
            );
          },
        ),
      ),
    );
  }
}
