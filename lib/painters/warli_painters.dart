import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Clamps a double to the 0–1 range. Handy for partial-draw progress values.
double c01(double v) => v < 0 ? 0 : (v > 1 ? 1 : v);

/// Returns a stroke [Paint] with rounded caps/joins — the look of a hand-
/// drawn Warli line.
Paint stroke(Color c, [double w = 3]) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

/// Builds a Warli-style human figure as a [Path].
///
/// A Warli figure is made of a circle (head), an upward triangle (torso),
/// a downward triangle (skirt/legs), and two horizontal arms.
/// [s] is a scale factor; origin is at the figure's feet.
Path figurePath(double s) {
  final p = Path();
  // Head
  p.addOval(Rect.fromCircle(center: Offset(0, -s * 1.9), radius: s * 0.28));
  // Torso (upward triangle)
  p.moveTo(-s * 0.5, -s * 1.55);
  p.lineTo(s * 0.5, -s * 1.55);
  p.lineTo(0, -s * 0.85);
  p.close();
  // Skirt (downward triangle)
  p.moveTo(0, -s * 0.85);
  p.lineTo(-s * 0.5, 0);
  p.lineTo(s * 0.5, 0);
  p.close();
  // Arms
  p.moveTo(-s * 0.5, -s * 1.45);
  p.lineTo(-s * 1.0, -s * 1.45);
  p.moveTo(s * 0.5, -s * 1.45);
  p.lineTo(s * 1.0, -s * 1.45);
  return p;
}

/// Draws a [path] only up to fraction [t] (0 → nothing, 1 → full path).
///
/// This gives the "drawing itself" effect used on the splash screen.
/// [computeMetrics] breaks the path into contiguous sub-paths (metrics),
/// then [extractPath] trims each one.
void drawPartial(Canvas c, Path path, Paint paint, double t) {
  for (final m in path.computeMetrics()) {
    c.drawPath(m.extractPath(0, m.length * t), paint);
  }
}

// ---------------------------------------------------------------------------
// CustomPainter classes
//
// CustomPainter is Flutter's low-level drawing API.  You override paint()
// to draw on a Canvas, and shouldRepaint() to tell Flutter when to redraw.
// ---------------------------------------------------------------------------

/// Splash screen painter: a sun + three dancing figures that "draw themselves".
class SplashPainter extends CustomPainter {
  final double t;
  final Color color;
  SplashPainter(this.t, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = stroke(color);
    final s = size.width / 9;
    canvas.save();
    canvas.translate(size.width / 2, s * 0.9);
    final sun = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: s * 0.55));
    drawPartial(canvas, sun, paint, c01(t * 3));
    canvas.restore();
    for (var i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(size.width * (0.25 + 0.25 * i), size.height - 4);
      drawPartial(canvas, figurePath(s), paint, c01(t * 1.4 - 0.15 * i - 0.2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(SplashPainter old) => old.t != t || old.color != color;
}

/// Tarpa dance painter: eight figures circling in a ring — the iconic Warli
/// harvest dance.
///
/// [angle] is in radians and increases each frame via an
/// [AnimationController] that repeats forever (until disposed).
class TarpaPainter extends CustomPainter {
  final double angle;
  final Color color;
  TarpaPainter(this.angle, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide * 0.36;
    final s = size.shortestSide * 0.07;
    const n = 8;
    final paint = stroke(color, 2.2);
    canvas.drawCircle(center, r, stroke(color.withAlpha(60), 1.2));
    for (var i = 0; i < n; i++) {
      final a = angle + 2 * math.pi * i / n;
      canvas.save();
      canvas.translate(
          center.dx + math.cos(a) * r, center.dy + math.sin(a) * r);
      canvas.rotate(a + math.pi / 2);
      canvas.drawPath(figurePath(s), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(TarpaPainter old) =>
      old.angle != angle || old.color != color;
}

/// Decorative ring of triangles and dots that orbits the profile avatar.
class RingPainter extends CustomPainter {
  final double rot;
  final Color color;
  RingPainter(this.rot, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width / 2 - 6;
    final fill = Paint()..color = color;
    const n = 24;
    for (var i = 0; i < n; i++) {
      final a = rot + 2 * math.pi * i / n;
      canvas.save();
      canvas.translate(
          center.dx + math.cos(a) * r, center.dy + math.sin(a) * r);
      canvas.rotate(a + math.pi / 2);
      if (i.isEven) {
        final tri = Path()
          ..moveTo(0, -5)
          ..lineTo(-4, 3)
          ..lineTo(4, 3)
          ..close();
        canvas.drawPath(tri, fill);
      } else {
        canvas.drawCircle(Offset.zero, 2, fill);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(RingPainter old) => old.rot != rot || old.color != color;
}

/// Zigzag line painter used as a Warli-style section divider.
class DividerPainter extends CustomPainter {
  final Color color;
  DividerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(0, size.height / 2);
    var x = 0.0;
    var up = true;
    while (x < size.width) {
      x += 10;
      path.lineTo(x, up ? 2 : size.height - 2);
      up = !up;
    }
    canvas.drawPath(path, stroke(color, 1.5));
  }

  @override
  bool shouldRepaint(DividerPainter old) => old.color != color;
}

/// A reusable Warli-style zigzag divider widget.
class WarliDivider extends StatelessWidget {
  final Color color;
  const WarliDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 14,
      width: double.infinity,
      child: CustomPaint(painter: DividerPainter(color.withAlpha(150))));
}

/// Custom-drawn navigation icons in the Warli geometric style.
///
/// type 0 = house (Home), type 1 = tree (Projects), type 2 = sun (Contact).
/// [semanticsLabel] is passed to a [Semantics] wrapper for accessibility.
class WarliIcon extends StatelessWidget {
  final int type;
  final Color color;
  final String? semanticsLabel;
  const WarliIcon(this.type, this.color, {super.key, this.semanticsLabel});

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticsLabel,
        child: CustomPaint(
            size: const Size(26, 26), painter: _IconPainter(type, color)),
      );
}

class _IconPainter extends CustomPainter {
  final int type;
  final Color color;
  _IconPainter(this.type, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 26);
    final p = stroke(color, 1.8);
    if (type == 0) {
      // House
      canvas.drawRect(const Rect.fromLTRB(5, 13, 21, 24), p);
      canvas.drawPath(
          Path()
            ..moveTo(3, 13)
            ..lineTo(13, 3)
            ..lineTo(23, 13)
            ..close(),
          p);
    } else if (type == 1) {
      // Tree
      canvas.drawLine(const Offset(13, 19), const Offset(13, 24), p);
      canvas.drawPath(
          Path()
            ..moveTo(13, 2)
            ..lineTo(7, 11)
            ..lineTo(19, 11)
            ..close(),
          p);
      canvas.drawPath(
          Path()
            ..moveTo(13, 8)
            ..lineTo(5, 19)
            ..lineTo(21, 19)
            ..close(),
          p);
    } else {
      // Sun
      canvas.drawCircle(const Offset(13, 13), 5, p);
      for (var i = 0; i < 8; i++) {
        final a = i * math.pi / 4;
        canvas.drawLine(
            Offset(13 + math.cos(a) * 8, 13 + math.sin(a) * 8),
            Offset(13 + math.cos(a) * 11, 13 + math.sin(a) * 11),
            p);
      }
    }
  }

  @override
  bool shouldRepaint(_IconPainter old) => old.type != type || old.color != color;
}
