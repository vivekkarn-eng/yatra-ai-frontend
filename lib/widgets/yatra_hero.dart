import 'package:flutter/material.dart';

class YatraHero extends StatelessWidget {
  final VoidCallback? onExplore;
  final VoidCallback? onScan;

  const YatraHero({
    super.key,
    this.onExplore,
    this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 560,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // HERO IMAGE
            Image.asset(
              'assets/images/yatra_hero.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF3B2920),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white54,
                    size: 48,
                  ),
                );
              },
            ),

            // CINEMATIC GRADIENT
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.12),
                    Colors.transparent,
                    Colors.black.withOpacity(0.30),
                    Colors.black.withOpacity(0.82),
                  ],
                  stops: const [
                    0.0,
                    0.32,
                    0.62,
                    1.0,
                  ],
                ),
              ),
            ),

            // TOP GOLD GLOW
            Positioned(
              top: -80,
              right: -50,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFE9C77B).withOpacity(0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // DECORATIVE TOP LINE
            Positioned(
              top: 24,
              left: 24,
              right: 24,
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6C477),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.35),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.explore_rounded,
                    color: Color(0xFFE6C477),
                    size: 20,
                  ),
                ],
              ),
            ),

            // CONTENT
            Positioned(
              left: 26,
              right: 26,
              bottom: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // EYEBROW
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 1,
                        color: const Color(0xFFE6C477),
                      ),
                      const SizedBox(width: 9),
                      const Text(
                        'DISCOVER INDIA',
                        style: TextStyle(
                          color: Color(0xFFE6C477),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // TITLE
                  const Text(
                    'YATRA',
                    style: TextStyle(
                      fontFamily: 'Cormorant Garamond',
                      color: Colors.white,
                      fontSize: 58,
                      height: 0.9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // TAGLINE
                  const Text(
                    'See a place.\nKnow its story.',
                    style: TextStyle(
                      fontFamily: 'Cormorant Garamond',
                      color: Colors.white,
                      fontSize: 25,
                      height: 1.02,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: onScan,
                            icon: const Icon(
                              Icons.auto_awesome_rounded,
                              size: 18,
                            ),
                            label: const Text(
                              'AI Scan',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFE6C477),
                              foregroundColor:
                                  const Color(0xFF33251E),
                              elevation: 8,
                              shadowColor:
                                  Colors.black.withOpacity(0.25),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: onExplore,
                            icon: const Icon(
                              Icons.explore_rounded,
                              size: 18,
                            ),
                            label: const Text(
                              'Explore',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFFE6C477),
                                width: 1.3,
                              ),
                              backgroundColor:
                                  Colors.black.withOpacity(0.16),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  // JOURNEY SIGNATURE
                  Row(
                    children: [
                      const Icon(
                        Icons.route_rounded,
                        size: 16,
                        color: Color(0xFFE6C477),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Every place has a story waiting to be discovered.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}