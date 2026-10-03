import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YatraDiscoverCard extends StatefulWidget {
  final List<Map<String, String>> places;
  final void Function(Map<String, String>) onPlaceTap;

  const YatraDiscoverCard({
    super.key,
    required this.places,
    required this.onPlaceTap,
  });

  @override
  State<YatraDiscoverCard> createState() =>
      _YatraDiscoverCardState();
}

class _YatraDiscoverCardState
    extends State<YatraDiscoverCard> {
  late final PageController _pageController;

  Timer? _timer;

  int _currentPage = 0;

  final List<Map<String, String>> _discoveries = [
    {
      'name': 'Gateway of India',
      'location': 'Maharashtra',
      'image': 'assets/images/gateway_mumbai.jpg',
      'tag': 'MUMBAI LANDMARK',
      'description':
          'An iconic waterfront monument that has become one of Mumbai’s most recognisable landmarks.',
    },
    {
      'name': 'Khajuraho Temples',
      'location': 'Madhya Pradesh',
      'image': 'assets/images/khajuraho_temples.jpg',
      'tag': 'ANCIENT WONDER',
      'description':
          'A remarkable group of temples celebrated for their intricate architecture and centuries-old carvings.',
    },
    {
      'name': 'Hawa Mahal',
      'location': 'Rajasthan',
      'image': 'assets/images/hawa_mahal_jaipur.jpg',
      'tag': 'PALACE OF WINDS',
      'description':
          'Jaipur’s iconic honeycomb façade was designed with hundreds of windows to catch the desert breeze.',
    },
    {
      'name': 'Mysore Palace',
      'location': 'Karnataka',
      'image': 'assets/images/mysore_palace.jpeg',
      'tag': 'ROYAL HERITAGE',
      'description':
          'A magnificent royal residence known for its illuminated façade, grand halls and Indo-Saracenic design.',
    },
  ];

  @override
  void initState() {
    super.initState();

    final random = Random();

    _discoveries.shuffle(random);

    _pageController = PageController(
      viewportFraction: 0.94,
    );

    _timer = Timer.periodic(
      const Duration(seconds: 6),
      (_) {
        if (!mounted || !_pageController.hasClients) {
          return;
        }

        final next =
            (_currentPage + 1) % _discoveries.length;

        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =====================================================
          // SECTION LABEL
          // =====================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              3,
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC58A3A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  'DISCOVER WITH YATRA',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    color: const Color(0xFFA05D28),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: Color(0xFFC58A3A),
                ),
              ],
            ),
          ),

          // =====================================================
          // TITLE
          // =====================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              0,
              20,
              14,
            ),
            child: Text(
              'A story waiting\nto be discovered.',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 31,
                height: 0.98,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF34241C),
              ),
            ),
          ),

          // =====================================================
          // CAROUSEL
          // =====================================================

          SizedBox(
            height: 270,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _discoveries.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final place = _discoveries[index];

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: _DiscoverHero(
                    place: place,
                    onTap: () {
                      widget.onPlaceTap(place);
                    },
                  ),
                );
              },
            ),
          ),

          // =====================================================
          // INDICATORS
          // =====================================================

          const SizedBox(height: 13),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: List.generate(
              _discoveries.length,
              (index) {
                final active =
                    index == _currentPage;

                return AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 250),
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  width: active ? 28 : 7,
                  height: 5,
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFFA95F2B)
                        : const Color(0xFFD2C0A3),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// DISCOVER HERO CARD
// =============================================================

class _DiscoverHero extends StatelessWidget {
  final Map<String, String> place;
  final VoidCallback onTap;

  const _DiscoverHero({
    required this.place,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFD4B98A),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B3A27)
                    .withOpacity(0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // -------------------------------------------------
              // IMAGE
              // -------------------------------------------------

              Image.asset(
                place['image']!,
                fit: BoxFit.cover,
              ),

              // -------------------------------------------------
              // DARK CINEMATIC GRADIENT
              // -------------------------------------------------

              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.08),
                      Colors.transparent,
                      Colors.black.withOpacity(0.82),
                    ],
                    stops: const [
                      0.0,
                      0.40,
                      1.0,
                    ],
                  ),
                ),
              ),

              // -------------------------------------------------
              // INNER FRAME
              // -------------------------------------------------

              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(21),
                    border: Border.all(
                      color: Colors.white
                          .withOpacity(0.30),
                      width: 1,
                    ),
                  ),
                ),
              ),

              // -------------------------------------------------
              // TOP BADGE
              // -------------------------------------------------

              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8C47D)
                        .withOpacity(0.95),
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                  child: Text(
                    place['tag']!,
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color:
                          const Color(0xFF54331F),
                    ),
                  ),
                ),
              ),

              // -------------------------------------------------
              // ROUTE DETAIL
              // -------------------------------------------------

              Positioned(
                top: 25,
                right: 22,
                child: SizedBox(
                  width: 100,
                  height: 55,
                  child: CustomPaint(
                    painter:
                        _DiscoverRoutePainter(),
                  ),
                ),
              ),

              // -------------------------------------------------
              // CONTENT
              // -------------------------------------------------

              Positioned(
                left: 22,
                right: 22,
                bottom: 19,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: Color(0xFFE5B45F),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          place['location']!
                              .toUpperCase(),
                          style:
                              GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight:
                                FontWeight.w700,
                            letterSpacing: 1.6,
                            color:
                                const Color(0xFFE9C783),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    Text(
                      place['name']!,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          GoogleFonts.cormorantGaramond(
                        fontSize: 30,
                        height: 1,
                        fontWeight:
                            FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      place['description']!,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 9.5,
                        height: 1.35,
                        color: Colors.white
                            .withOpacity(0.82),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ------------------------------------------------
                    // EXPLORE STORY BUTTON
                    // ------------------------------------------------

                    Container(
                      padding:
                          const EdgeInsets.only(
                        left: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.20),
                        borderRadius:
                            BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Text(
                            'EXPLORE STORY',
                            style:
                                GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight:
                                  FontWeight.w800,
                              letterSpacing: 1.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 31,
                            height: 31,
                            decoration:
                                const BoxDecoration(
                              color:
                                  Color(0xFFE7B65F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons
                                  .arrow_forward_rounded,
                              size: 16,
                              color:
                                  Color(0xFF51311F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
// ROUTE PAINTER
// =============================================================

class _DiscoverRoutePainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color =
          Colors.white.withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();

    path.moveTo(5, 38);

    path.cubicTo(
      28,
      20,
      40,
      42,
      58,
      22,
    );

    path.cubicTo(
      72,
      7,
      85,
      24,
      94,
      7,
    );

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = const Color(0xFFE9B85F);

    canvas.drawCircle(
      const Offset(5, 38),
      3.5,
      dotPaint,
    );

    canvas.drawCircle(
      const Offset(94, 7),
      3.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}