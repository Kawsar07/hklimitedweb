import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// A clean, low-poly world map used on the Why Us page.
///
/// The land base is a bundled PNG (`assets/images/world_map.png`) rendered in
/// an equirectangular projection with a fixed extent — longitude −180…180 and
/// latitude −56…84 — so any geographic point maps to a fixed fraction of the
/// widget. Continent labels, the Hong Kong hub and the connecting arcs are
/// drawn on top of it, positioned from real lon/lat coordinates. Everything
/// scales with the available width, so it stays crisp on mobile, tablet and
/// desktop.
class SourcingMap extends StatelessWidget {
  const SourcingMap({super.key});

  // Width / height of the map image's geographic extent.
  static const double _aspect = 360 / 140;

  // Hong Kong sourcing hub.
  static const double _hkLon = 114;
  static const double _hkLat = 22;

  // Continents we source from: (name, longitude, latitude).
  static const List<(String, double, double)> _continents = [
    ('North America', -100, 50),
    ('South America', -58, -12),
    ('Europe', 20, 54),
    ('Africa', 21, 2),
    ('Asia', 95, 48),
    ('Oceania', 134, -26),
  ];

  static Offset _frac(double lon, double lat) =>
      Offset((lon + 180) / 360, (84 - lat) / 140);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = w / _aspect;
        final labelSize = (w * 0.021).clamp(9.0, 14.0);

        Widget chip(String text, {required bool hub}) {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: labelSize * 0.65, vertical: labelSize * 0.28),
            decoration: BoxDecoration(
              color: hub
                  ? AppColors.amber
                  : AppColors.navy.withOpacity(0.82),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: hub ? AppColors.navy : Colors.white,
                fontSize: labelSize,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          );
        }

        Widget place(Offset frac, Widget child) {
          return Positioned(
            left: frac.dx * w,
            top: frac.dy * h,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -0.5),
              child: child,
            ),
          );
        }

        return SizedBox(
          width: w,
          height: h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/world_map.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned.fill(
                child: CustomPaint(painter: _ConnectionsPainter()),
              ),
              for (final c in _continents)
                place(_frac(c.$2, c.$3), chip(c.$1, hub: false)),
              place(_frac(_hkLon, _hkLat), chip('Hong Kong', hub: true)),
            ],
          ),
        );
      },
    );
  }
}

class _ConnectionsPainter extends CustomPainter {
  Offset _px(Size s, double lon, double lat) =>
      Offset((lon + 180) / 360 * s.width, (84 - lat) / 140 * s.height);

  @override
  void paint(Canvas canvas, Size size) {
    final hk = _px(size, SourcingMap._hkLon, SourcingMap._hkLat);

    final arc = Paint()
      ..color = AppColors.amber.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (size.width * 0.0035).clamp(1.2, 3.0)
      ..strokeCap = StrokeCap.round;

    for (final c in SourcingMap._continents) {
      final end = _px(size, c.$2, c.$3);
      final mid = Offset((hk.dx + end.dx) / 2, (hk.dy + end.dy) / 2);
      final dist = (end - hk).distance;
      final control = Offset(mid.dx, mid.dy - dist * 0.22);
      canvas.drawPath(
        Path()
          ..moveTo(hk.dx, hk.dy)
          ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy),
        arc,
      );
    }

    // Hong Kong hub glow + core.
    final r = (size.width * 0.006).clamp(3.0, 7.0);
    canvas.drawCircle(hk, r * 2.6, Paint()..color = AppColors.amber.withOpacity(0.22));
    canvas.drawCircle(hk, r, Paint()..color = AppColors.amberDeep);
  }

  @override
  bool shouldRepaint(covariant _ConnectionsPainter oldDelegate) => false;
}
