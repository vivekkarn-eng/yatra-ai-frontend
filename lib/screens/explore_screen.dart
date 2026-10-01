import 'package:flutter/material.dart';

import '../data/place_data.dart';
import 'place_story_screen.dart';

class ExploreScreen extends StatefulWidget {
  final String? city;

  const ExploreScreen({
    super.key,
    this.city,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedCity = 'All';

  final List<String> cities = const [
    'All',
    'Indore',
    'Jaipur',
    'Mumbai',
    'Mysuru',
    'Bhopal',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.city != null && cities.contains(widget.city)) {
      selectedCity = widget.city!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // =========================================================
    // USE ONE CENTRAL DATABASE
    // =========================================================

    final places = YatraPlaces.all.where((place) {
      if (selectedCity == 'All') {
        return true;
      }

      return place['city'] == selectedCity;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3E8D2),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3E8D2),
        foregroundColor: const Color(0xFF30251F),
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: Column(
        children: [
          // ===================================================
          // CITY FILTERS
          // ===================================================

          SizedBox(
            height: 54,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: cities.length,
              separatorBuilder: (_, __) {
                return const SizedBox(width: 8);
              },
              itemBuilder: (_, index) {
                final city = cities[index];
                final isSelected = selectedCity == city;

                return ChoiceChip(
                  label: Text(city),
                  selected: isSelected,

                  onSelected: (_) {
                    setState(() {
                      selectedCity = city;
                    });
                  },

                  selectedColor: const Color(0xFFA6532A),
                  backgroundColor: const Color(0xFFFFF9EF),

                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF6E5C4C),
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 4),

          // ===================================================
          // RESULT COUNT
          // ===================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: Row(
              children: [
                Text(
                  selectedCity == 'All'
                      ? '${places.length} places'
                      : '${places.length} places in $selectedCity',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF75685D),
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.explore_rounded,
                  size: 16,
                  color: Color(0xFFA6532A),
                ),
              ],
            ),
          ),

          // ===================================================
          // PLACES GRID
          // ===================================================

          Expanded(
            child: places.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      14,
                      8,
                      14,
                      24,
                    ),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),

                    itemCount: places.length,

                    itemBuilder: (_, index) {
                      final place = places[index];

                      return _PlaceCard(
                        place: place,

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlaceStoryScreen(
                                place: place,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // EMPTY STATE
  // ===========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 80,
              height: 80,

              decoration: const BoxDecoration(
                color: Color(0xFFE5D5B8),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.location_city_rounded,
                size: 38,
                color: Color(0xFFA6532A),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No places yet',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF30251F),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'YATRA will add more places to this destination soon.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Color(0xFF8B7564),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// PLACE CARD
// =============================================================

class _PlaceCard extends StatelessWidget {
  final Map<String, String> place;
  final VoidCallback onTap;

  const _PlaceCard({
    required this.place,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final image = place['image'] ?? '';
    final name = place['name'] ?? 'Unknown Place';
    final city = place['city'] ?? '';
    final location = place['location'] ?? '';

    return Material(
      color: const Color(0xFFFFF9EF),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =================================================
            // IMAGE
            // =================================================

            Expanded(
              child: image.isEmpty
                  ? Container(
                      width: double.infinity,
                      color: const Color(0xFFE5D5B8),

                      child: const Center(
                        child: Icon(
                          Icons.account_balance_rounded,
                          size: 45,
                          color: Color(0xFFA6532A),
                        ),
                      ),
                    )
                  : Image.asset(
                      image,
                      width: double.infinity,
                      fit: BoxFit.cover,

                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: double.infinity,
                          color: const Color(0xFFE5D5B8),

                          child: const Center(
                            child: Icon(
                              Icons.account_balance_rounded,
                              size: 45,
                              color: Color(0xFFA6532A),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // =================================================
            // NAME
            // =================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                11,
                9,
                11,
                2,
              ),

              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF30251F),
                ),
              ),
            ),

            // =================================================
            // LOCATION
            // =================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                11,
                0,
                11,
                10,
              ),

              child: Text(
                '$city • $location',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF827467),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}