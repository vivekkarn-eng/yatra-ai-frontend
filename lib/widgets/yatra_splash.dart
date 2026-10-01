import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YatraSplash extends StatefulWidget {
  final Widget destination;

  const YatraSplash({
    super.key,
    required this.destination,
  });

  @override
  State<YatraSplash> createState() => _YatraSplashState();
}

class _YatraSplashState extends State<YatraSplash>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _glowController;
  late AnimationController _routeController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Main entrance animation
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.05,
        0.55,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.05,
          0.65,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _imageAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.12,
        0.65,
        curve: Curves.easeOutCubic,
      ),
    );

    _textAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.38,
        0.88,
        curve: Curves.easeOut,
      ),
    );

    // Soft breathing glow
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    // Route-line animation
    _routeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _mainController.forward();

    // Move to Home after splash
    Timer(const Duration(milliseconds: 3600), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => widget.destination,
          transitionDuration: const Duration(milliseconds: 900),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _glowController.dispose();
    _routeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EBDD),
      body: Stack(
        children: [
          // =========================================================
          // HERITAGE BACKGROUND
          // =========================================================
          Positioned.fill(
            child: CustomPaint(
              painter: _HeritagePatternPainter(
                progress: _routeController,
              ),
            ),
          ),

          // =========================================================
          // SOFT GOLDEN GLOW
          // =========================================================
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              final glow = 0.10 +
                  (_glowController.value * 0.08);

              return Positioned(
                top: -100,
                right: -80,
                child: Container(
                  width: 330,
                  height: 330,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFD7A84F)
                            .withOpacity(glow),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // =========================================================
          // MAIN CONTENT
          // =========================================================
          SafeArea(
            child: Center(
              child: AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // =================================================
                      // TOP ORNAMENT
                      // =================================================
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFFC7A66A)
                                  .withOpacity(0.45),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Icon(
                            Icons.explore_rounded,
                            color: Color(0xFFA6532A),
                            size: 19,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFFC7A66A)
                                  .withOpacity(0.45),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // =================================================
                      // SMALL BRAND LINE
                      // =================================================
                      AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _textAnimation.value,
                            child: Transform.translate(
                              offset: Offset(
                                0,
                                15 *
                                    (1 -
                                        _textAnimation.value),
                              ),
                              child: child,
                            ),
                          );
                        },
                        child: const Text(
                          'A JOURNEY THROUGH INDIA',
                          style: TextStyle(
                            color: Color(0xFFA6532A),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // =================================================
                      // HERO IMAGE CARD
                      // =================================================
                      AnimatedBuilder(
                        animation: _imageAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _imageAnimation.value,
                            child: Transform.scale(
                              scale: 0.92 +
                                  (_imageAnimation.value * 0.08),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: 255,
                          height: 310,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.18),
                                blurRadius: 30,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(32),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/yatra_hero.png',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      color:
                                          const Color(0xFF4A3327),
                                      child: const Icon(
                                        Icons
                                            .image_not_supported_outlined,
                                        color: Colors.white54,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),

                                // Image gradient
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin:
                                          Alignment.topCenter,
                                      end:
                                          Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black
                                            .withOpacity(0.10),
                                        Colors.black
                                            .withOpacity(0.78),
                                      ],
                                      stops: const [
                                        0.30,
                                        0.55,
                                        1.0,
                                      ],
                                    ),
                                  ),
                                ),

                                // Image bottom branding
                                Positioned(
                                  left: 20,
                                  right: 20,
                                  bottom: 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'YATRA',
                                        style: GoogleFonts
                                            .cormorantGaramond(
                                          color: Colors.white,
                                          fontSize: 43,
                                          height: 0.9,
                                          fontWeight:
                                              FontWeight.w800,
                                          letterSpacing: 3,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        'See a place. Know its story.',
                                        style: GoogleFonts
                                            .cormorantGaramond(
                                          color: Colors.white
                                              .withOpacity(0.9),
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Gold corner detail
                                Positioned(
                                  top: 15,
                                  right: 15,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(
                                          0xFFE6C477,
                                        ).withOpacity(0.75),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.route_rounded,
                                      color:
                                          Color(0xFFE6C477),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      // =================================================
                      // TAGLINE
                      // =================================================
                      AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _textAnimation.value,
                            child: Transform.translate(
                              offset: Offset(
                                0,
                                20 *
                                    (1 -
                                        _textAnimation.value),
                              ),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              'SEE A PLACE.',
                              style: GoogleFonts
                                  .cormorantGaramond(
                                fontSize: 25,
                                height: 0.95,
                                fontWeight: FontWeight.w700,
                                color:
                                    const Color(0xFF30231D),
                                letterSpacing: 1.1,
                              ),
                            ),
                            Text(
                              'KNOW ITS STORY.',
                              style: GoogleFonts
                                  .cormorantGaramond(
                                fontSize: 25,
                                height: 0.95,
                                fontWeight: FontWeight.w700,
                                color:
                                    const Color(0xFF30231D),
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =================================================
                      // BOTTOM DETAIL
                      // =================================================
                      AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _textAnimation.value,
                            child: child,
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              size: 13,
                              color: Color(0xFFA6532A),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'AI • HERITAGE • TRAVEL',
                              style: TextStyle(
                                color:
                                    const Color(0xFF735B49)
                                        .withOpacity(0.85),
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// DECORATIVE HERITAGE / ROUTE BACKGROUND
// ================================================================

class _HeritagePatternPainter extends CustomPainter {
  final Animation<double> progress;

  _HeritagePatternPainter({
    required this.progress,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = const Color(0xFFB89A6A).withOpacity(0.18);

    final softPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFFA6532A).withOpacity(0.10);

    // =============================================================
    // LEFT ARCHITECTURAL MOTIF
    // =============================================================
    final leftCenter = Offset(
      -30,
      size.height * 0.45,
    );

    canvas.drawCircle(
      leftCenter,
      145,
      linePaint,
    );

    canvas.drawCircle(
      leftCenter,
      125,
      softPaint,
    );

    for (int i = 0; i < 8; i++) {
      final angle = (i * 3.14159 / 4);
      final start = Offset(
        leftCenter.dx + 95 * cos(angle),
        leftCenter.dy + 95 * sin(angle),
      );
      final end = Offset(
        leftCenter.dx + 145 * cos(angle),
        leftCenter.dy + 145 * sin(angle),
      );

      canvas.drawLine(
        start,
        end,
        linePaint,
      );
    }

    // =============================================================
    // RIGHT MANDALA
    // =============================================================
    final rightCenter = Offset(
      size.width + 35,
      size.height * 0.58,
    );

    canvas.drawCircle(
      rightCenter,
      165,
      linePaint,
    );

    canvas.drawCircle(
      rightCenter,
      135,
      softPaint,
    );

    canvas.drawCircle(
      rightCenter,
      90,
      linePaint,
    );

    // =============================================================
    // ROUTE / JOURNEY LINE
    // =============================================================
    final routePath = Path();

    routePath.moveTo(
      size.width * 0.05,
      size.height * 0.84,
    );

    routePath.cubicTo(
      size.width * 0.25,
      size.height * 0.70,
      size.width * 0.42,
      size.height * 0.94,
      size.width * 0.60,
      size.height * 0.78,
    );

    routePath.cubicTo(
      size.width * 0.73,
      size.height * 0.66,
      size.width * 0.86,
      size.height * 0.76,
      size.width * 1.05,
      size.height * 0.61,
    );

    final animatedPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFFA6532A).withOpacity(0.16);

    canvas.drawPath(
      routePath,
      animatedPaint,
    );

    // =============================================================
    // SMALL JOURNEY DOTS
    // =============================================================
    final dotPaint = Paint()
      ..color = const Color(0xFFC49A56).withOpacity(0.28);

    final positions = [
      Offset(size.width * 0.10, size.height * 0.17),
      Offset(size.width * 0.86, size.height * 0.20),
      Offset(size.width * 0.08, size.height * 0.70),
      Offset(size.width * 0.91, size.height * 0.78),
      Offset(size.width * 0.17, size.height * 0.91),
      Offset(size.width * 0.82, size.height * 0.91),
    ];

    for (final position in positions) {
      canvas.drawCircle(
        position,
        2.2,
        dotPaint,
      );

      canvas.drawCircle(
        position,
        6,
        linePaint,
      );
    }

    // =============================================================
    // SMALL CORNER ARCH DETAILS
    // =============================================================
    final archPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFF9C7D50).withOpacity(0.15);

    final archPath = Path();

    archPath.moveTo(
      size.width * 0.03,
      size.height * 0.25,
    );

    archPath.quadraticBezierTo(
      size.width * 0.03,
      size.height * 0.13,
      size.width * 0.15,
      size.height * 0.13,
    );

    archPath.lineTo(
      size.width * 0.15,
      size.height * 0.07,
    );

    canvas.drawPath(
      archPath,
      archPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _HeritagePatternPainter oldDelegate,
  ) {
    return true;
  }
}

// ================================================================
// TEMPORARY NAVIGATION TARGET
// ================================================================
//
// IMPORTANT:
// main.dart will provide the real HomeScreen when we connect this.
// This placeholder exists only so this widget remains independent.
//
// We will replace this with the actual HomeScreen connection below.
// ================================================================

