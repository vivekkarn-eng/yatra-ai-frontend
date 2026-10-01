import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YatraBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onScanTap;

  const YatraBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // =====================================================
          // OLD MAP PANEL
          // =====================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 91,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE7D0A2),
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFF8E623D)
                        .withOpacity(0.75),
                    width: 1.2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _OldMapPainter(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    8,
                    18,
                    8,
                    2,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MapNavItem(
                          icon: Icons.home_outlined,
                          selectedIcon: Icons.home_rounded,
                          label: 'Home',
                          selected: selectedIndex == 0,
                          onTap: () => onItemSelected(0),
                        ),
                      ),

                      Expanded(
                        child: _MapNavItem(
                          icon: Icons.explore_outlined,
                          selectedIcon: Icons.explore_rounded,
                          label: 'Explore',
                          selected: selectedIndex == 1,
                          onTap: () => onItemSelected(1),
                        ),
                      ),

                      // SPACE RESERVED FOR FLOATING CAPSULE
                      const SizedBox(width: 116),

                      Expanded(
                        child: _MapNavItem(
                          icon: Icons.bookmark_border_rounded,
                          selectedIcon: Icons.bookmark_rounded,
                          label: 'Saved',
                          selected: selectedIndex == 2,
                          onTap: () => onItemSelected(2),
                        ),
                      ),

                      Expanded(
                        child: _MapNavItem(
                          icon: Icons.person_outline_rounded,
                          selectedIcon: Icons.person_rounded,
                          label: 'Profile',
                          selected: selectedIndex == 3,
                          onTap: () => onItemSelected(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // =====================================================
          // FLOATING YATRA CAPSULE
          // =====================================================

          Positioned(
            top: -1,
            left: 0,
            right: 0,
            child: Center(
              child: _YatraScanCapsule(
                onTap: onScanTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// NAVIGATION ITEM
// =============================================================

class _MapNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MapNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const active = Color(0xFF5A3522);
    const inactive = Color(0xFF806B52);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: const Color(0xFFB57C3B).withOpacity(0.16),
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: 68,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOut,
                width: selected ? 48 : 40,
                height: selected ? 32 : 28,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFD4AD70).withOpacity(0.55)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: selected
                      ? Border.all(
                          color: const Color(0xFF9D6D3E)
                              .withOpacity(0.28),
                        )
                      : null,
                ),
                child: Icon(
                  selected ? selectedIcon : icon,
                  size: selected ? 21 : 20,
                  color: selected ? active : inactive,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: selected ? 10.5 : 9.5,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? active : inactive,
                ),
              ),

              const SizedBox(height: 3),

              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                width: selected ? 23 : 0,
                height: 2,
                decoration: BoxDecoration(
                  color: active,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================
// FLOATING YATRA SCAN CAPSULE
// =============================================================

class _YatraScanCapsule extends StatefulWidget {
  final VoidCallback onTap;

  const _YatraScanCapsule({
    required this.onTap,
  });

  @override
  State<_YatraScanCapsule> createState() =>
      _YatraScanCapsuleState();
}

class _YatraScanCapsuleState extends State<_YatraScanCapsule> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => pressed = true);
      },
      onTapCancel: () {
        setState(() => pressed = false);
      },
      onTapUp: (_) {
        setState(() => pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 130),
        child: Container(
          width: 136,
          height: 70,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF42281C),
            borderRadius: BorderRadius.circular(38),
            border: Border.all(
              color: const Color(0xFFD5A25A),
              width: 2.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B2418).withOpacity(0.40),
                blurRadius: 22,
                spreadRadius: 1,
                offset: const Offset(0, 9),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.22),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(33),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFD9A65D),
                  Color(0xFF9D5F30),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFF2D39A),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 17,
                    color: Color(0xFFFFF4DC),
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YATRA',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 13,
                        height: 0.9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                        color: const Color(0xFFFFF4DC),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'SCAN',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.7,
                        color: const Color(0xFFFFF4DC),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// OLD MAP BACKGROUND
// =============================================================

class _OldMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final faded = Paint()
      ..color = const Color(0xFF745037).withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final route = Paint()
      ..color = const Color(0xFF765036).withOpacity(0.27)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final marker = Paint()
      ..color = const Color(0xFFA66D35).withOpacity(0.45);

    final border = Paint()
      ..color = const Color(0xFF8B603B).withOpacity(0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // =========================================================
    // OLD MAP CONTOUR LINES
    // =========================================================

    for (int i = 0; i < 5; i++) {
      final path = Path();

      final y = size.height * (0.10 + i * 0.18);

      path.moveTo(-30, y);

      path.cubicTo(
        size.width * 0.18,
        y - 12,
        size.width * 0.28,
        y + 14,
        size.width * 0.43,
        y - 2,
      );

      path.cubicTo(
        size.width * 0.60,
        y - 19,
        size.width * 0.76,
        y + 15,
        size.width + 30,
        y - 4,
      );

      canvas.drawPath(path, faded);
    }

    // =========================================================
    // MAIN JOURNEY ROUTE
    // =========================================================

    final path = Path();

    path.moveTo(-10, size.height * 0.74);

    path.cubicTo(
      size.width * 0.10,
      size.height * 0.26,
      size.width * 0.24,
      size.height * 0.91,
      size.width * 0.39,
      size.height * 0.39,
    );

    path.cubicTo(
      size.width * 0.52,
      size.height * 0.02,
      size.width * 0.66,
      size.height * 0.90,
      size.width * 0.82,
      size.height * 0.44,
    );

    path.cubicTo(
      size.width * 0.91,
      size.height * 0.21,
      size.width,
      size.height * 0.32,
      size.width + 15,
      size.height * 0.18,
    );

    canvas.drawPath(path, route);

    // =========================================================
    // DESTINATION DOTS
    // =========================================================

    final points = [
      Offset(size.width * 0.12, size.height * 0.57),
      Offset(size.width * 0.29, size.height * 0.67),
      Offset(size.width * 0.43, size.height * 0.38),
      Offset(size.width * 0.63, size.height * 0.55),
      Offset(size.width * 0.83, size.height * 0.47),
    ];

    for (final point in points) {
      canvas.drawCircle(point, 3.2, marker);

      canvas.drawCircle(
        point,
        6,
        Paint()
          ..color = const Color(0xFF9C6B3B).withOpacity(0.08)
          ..style = PaintingStyle.fill,
      );
    }

    // =========================================================
    // FADED TEMPLE / HERITAGE SKETCHES
    // =========================================================

    _drawTemple(
      canvas,
      Offset(size.width * 0.025, size.height * 0.40),
      faded,
    );

    _drawTemple(
      canvas,
      Offset(size.width * 0.18, size.height * 0.18),
      faded,
    );

    _drawTemple(
      canvas,
      Offset(size.width * 0.94, size.height * 0.56),
      faded,
    );

    // =========================================================
    // COMPASS
    // =========================================================

    _drawCompass(
      canvas,
      Offset(size.width * 0.975, size.height * 0.20),
      faded,
    );

    // =========================================================
    // ANTIQUE MAP BORDER
    // =========================================================

    const double margin = 9;

    canvas.drawRect(
      Rect.fromLTWH(
        margin,
        margin,
        size.width - margin * 2,
        size.height - margin * 2,
      ),
      border,
    );

    // Inner broken border
    final inner = Paint()
      ..color = const Color(0xFF8B603B).withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.drawRect(
      Rect.fromLTWH(
        margin + 4,
        margin + 4,
        size.width - (margin + 4) * 2,
        size.height - (margin + 4) * 2,
      ),
      inner,
    );

    // =========================================================
    // CORNER ORNAMENTS
    // =========================================================

    _corner(canvas, const Offset(9, 9), faded, true, true);
    _corner(
      canvas,
      Offset(size.width - 9, 9),
      faded,
      false,
      true,
    );
    _corner(
      canvas,
      Offset(9, size.height - 9),
      faded,
      true,
      false,
    );
    _corner(
      canvas,
      Offset(size.width - 9, size.height - 9),
      faded,
      false,
      false,
    );
  }

  void _corner(
    Canvas canvas,
    Offset p,
    Paint paint,
    bool left,
    bool top,
  ) {
    const length = 25.0;

    final x = left ? 1 : -1;
    final y = top ? 1 : -1;

    canvas.drawLine(
      p,
      Offset(p.dx + x * length, p.dy),
      paint,
    );

    canvas.drawLine(
      p,
      Offset(p.dx, p.dy + y * length),
      paint,
    );

    canvas.drawCircle(
      Offset(
        p.dx + x * 7,
        p.dy + y * 7,
      ),
      2,
      paint,
    );
  }

  void _drawTemple(
    Canvas canvas,
    Offset center,
    Paint paint,
  ) {
    final path = Path();

    path.moveTo(
      center.dx - 11,
      center.dy + 10,
    );

    path.lineTo(
      center.dx - 11,
      center.dy - 1,
    );

    path.lineTo(
      center.dx,
      center.dy - 14,
    );

    path.lineTo(
      center.dx + 11,
      center.dy - 1,
    );

    path.lineTo(
      center.dx + 11,
      center.dy + 10,
    );

    canvas.drawPath(path, paint);

    canvas.drawLine(
      Offset(center.dx - 14, center.dy + 10),
      Offset(center.dx + 14, center.dy + 10),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx - 4, center.dy + 10),
      Offset(center.dx - 4, center.dy),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx + 4, center.dy + 10),
      Offset(center.dx + 4, center.dy),
      paint,
    );
  }

  void _drawCompass(
    Canvas canvas,
    Offset center,
    Paint paint,
  ) {
    canvas.drawCircle(center, 12, paint);

    canvas.drawCircle(
      center,
      4,
      paint,
    );

    canvas.drawLine(
      Offset(center.dx - 8, center.dy + 8),
      Offset(center.dx + 8, center.dy - 8),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx - 8, center.dy - 8),
      Offset(center.dx + 8, center.dy + 8),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}