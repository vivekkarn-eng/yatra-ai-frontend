import 'package:flutter/material.dart';

class YatraCityCards extends StatelessWidget {
  final List<Map<String, String>> cities;
  final ValueChanged<String> onCityTap;

  const YatraCityCards({
    super.key,
    required this.cities,
    required this.onCityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(),

        const SizedBox(height: 2),

        SizedBox(
          height: 218,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: cities.length + 1,
            itemBuilder: (context, index) {
              // =====================================================
              // MORE CITIES CARD
              // =====================================================
              if (index == cities.length) {
                return Container(
                  width: 158,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D6B7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFD2B98F),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF8EC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 27,
                          color: Color(0xFFA6532A),
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'More Cities',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cormorant Garamond',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2E211B),
                        ),
                      ),

                      const SizedBox(height: 3),

                      const Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Color(0xFF8A654C),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFC7A879),
                          ),
                        ),
                        child: const Text(
                          'EXPANDING INDIA',
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                            color: Color(0xFF79553A),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final city = cities[index];

              return GestureDetector(
                onTap: () => onCityTap(city['name'] ?? ''),
                child: Container(
                  width: 158,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // =================================================
                      // CITY IMAGE
                      // =================================================
                      Image.asset(
                        city['image'] ?? '',
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF5A4030),
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.white54,
                              size: 32,
                            ),
                          );
                        },
                      ),

                      // =================================================
                      // CINEMATIC GRADIENT
                      // =================================================
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.04),
                              Colors.transparent,
                              Colors.black.withOpacity(0.88),
                            ],
                            stops: const [
                              0.0,
                              0.42,
                              1.0,
                            ],
                          ),
                        ),
                      ),

                      // =================================================
                      // TOP LOCATION MARK
                      // =================================================
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius:
                                BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.22),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 11,
                                color: Color(0xFFE6C477),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'EXPLORE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // =================================================
                      // BOTTOM CITY INFO
                      // =================================================
                      Positioned(
                        left: 13,
                        right: 13,
                        bottom: 13,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              city['name'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily:
                                    'Cormorant Garamond',
                                color: Colors.white,
                                fontSize: 25,
                                height: 0.95,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 1,
                                  color:
                                      const Color(0xFFE6C477),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  'HERITAGE JOURNEY',
                                  style: TextStyle(
                                    color: Colors.white
                                        .withOpacity(0.78),
                                    fontSize: 7,
                                    fontWeight:
                                        FontWeight.w700,
                                    letterSpacing: 0.9,
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
            },
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _sectionHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 13),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Explore by City',
              style: TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: Color(0xFF30251F),
              ),
            ),
          ),

          Icon(
            Icons.route_rounded,
            size: 17,
            color: Color(0xFFA6532A),
          ),

          SizedBox(width: 5),

          Text(
            'YOUR JOURNEY',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: Color(0xFFA6532A),
            ),
          ),
        ],
      ),
    );
  }
}