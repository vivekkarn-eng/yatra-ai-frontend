import 'package:flutter/material.dart';
import '../data/place_data.dart';

class YatraPlaceCards extends StatefulWidget {
  final List<Map<String, String>> places;
  final void Function(Map<String, String> place)? onPlaceTap;

  const YatraPlaceCards({
    super.key,
    required this.places,
    this.onPlaceTap,
  });

  @override
  State<YatraPlaceCards> createState() => _YatraPlaceCardsState();
}

class _YatraPlaceCardsState extends State<YatraPlaceCards> {

  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 20),
            itemCount: widget.places.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final place = widget.places[index];

              return _PlaceCard(
                place: place,
                isSaved: YatraSaved.isSaved(place['name'] ?? ''),
                onTap: () => widget.onPlaceTap?.call(place),
                onSave: () {
                  final name = place['name'] ?? '';
                  if (name.isEmpty) return;

                  setState(() {
                    YatraSaved.toggle(name);
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC58A3A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'YATRA PICKS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.2,
                        color: Color(0xFF9A6A2F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Popular Heritage Places',
                  style: TextStyle(
                    fontFamily: 'Cormorant Garamond',
                    fontSize: 29,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                    color: Color(0xFF3E2A1E),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            color: Color(0xFF6F5139),
            size: 21,
          ),
        ],
      ),
    );
  }
}

class _PlaceCard extends StatefulWidget {
  final Map<String, String> place;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const _PlaceCard({
    required this.place,
    required this.isSaved,
    required this.onTap,
    required this.onSave,
  });

  @override
  State<_PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<_PlaceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final name = widget.place['name'] ?? 'Heritage Place';
    final location = widget.place['location'] ?? 'India';
    final image = widget.place['image'] ?? '';

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
      },
      onTapCancel: () {
        setState(() => _pressed = false);
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 245,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildImage(image),

                // Cinematic dark gradient.
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.03),
                        Colors.transparent,
                        Colors.black.withOpacity(0.18),
                        Colors.black.withOpacity(0.82),
                      ],
                      stops: const [
                        0.0,
                        0.32,
                        0.58,
                        1.0,
                      ],
                    ),
                  ),
                ),

                // Heritage frame.
                Positioned.fill(
                  child: IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.20),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Top badge.
                Positioned(
                  left: 18,
                  top: 18,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9C27D).withOpacity(0.94),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 12,
                          color: Color(0xFF4A321F),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'HERITAGE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                            color: Color(0xFF4A321F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Save button.
                Positioned(
                  top: 15,
                  right: 15,
                  child: GestureDetector(
                    onTap: widget.onSave,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.30),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.22),
                        ),
                      ),
                      child: Icon(
                        widget.isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: widget.isSaved
                            ? const Color(0xFFE9C27D)
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Bottom content.
                Positioned(
                  left: 19,
                  right: 19,
                  bottom: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFFE9C27D),
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: Color(0xFFF1D9A7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Cormorant Garamond',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          height: 0.98,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'EXPLORE STORY',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.3,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            width: 23,
                            height: 23,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9C27D),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 13,
                              color: Color(0xFF4A321F),
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
        ),
      ),
    );
  }

  Widget _buildImage(String image) {
    if (image.isEmpty) {
      return _fallbackImage();
    }

    return Image.asset(
      image,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _fallbackImage();
      },
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: const Color(0xFF6E513B),
      child: const Center(
        child: Icon(
          Icons.account_balance_rounded,
          color: Colors.white54,
          size: 55,
        ),
      ),
    );
  }
}