import 'dart:typed_data';
import 'widgets/yatra_discover_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'screens/recognition_result_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/map_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/place_story_screen.dart';
import 'data/place_data.dart';
import 'screens/menu_drawer.dart';
import 'screens/notifications_screen.dart';
import 'screens/ai_recognition_screen.dart';
import 'widgets/yatra_hero.dart';
import 'widgets/yatra_scanner_card.dart';
import 'widgets/yatra_search_bar.dart';
import 'widgets/yatra_city_cards.dart';
import 'widgets/yatra_splash.dart';
import 'widgets/yatra_onboarding.dart';
import 'widgets/yatra_login.dart';
import 'widgets/yatra_place_cards.dart';
import 'widgets/yatra_bottom_nav.dart';
void main() {
  runApp(const YatraApp());
}

// ============================================================
// YATRA AI APP
// ============================================================

class YatraApp extends StatelessWidget {
  const YatraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YATRA AI',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F1E5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA6532A),
          brightness: Brightness.light,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,

        // Poppins = UI
        // Cormorant Garamond = heritage headings
        textTheme: ThemeData.light().textTheme.copyWith(
          displayLarge: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E211B),
          ),
          displayMedium: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E211B),
          ),
          displaySmall: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E211B),
          ),
          headlineLarge: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E211B),
          ),
          headlineMedium: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E211B),
          ),
          headlineSmall: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E211B),
          ),
          titleLarge: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E211B),
          ),
          titleMedium: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E211B),
          ),
          titleSmall: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E211B),
          ),
          bodyLarge: GoogleFonts.poppins(
            color: const Color(0xFF30251F),
          ),
          bodyMedium: GoogleFonts.poppins(
            color: const Color(0xFF4D4138),
          ),
          bodySmall: GoogleFonts.poppins(
            color: const Color(0xFF827467),
          ),
          labelLarge: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF7F1E5),
          foregroundColor: const Color(0xFF2E211B),
          elevation: 0,
          titleTextStyle: GoogleFonts.cormorantGaramond(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E211B),
          ),
        ),
      ),
      home: const YatraSplash(
  destination: YatraOnboarding(
    destination: HomeScreen(),
  ),
),      
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  // ==========================================================
  // SEARCH STATE
  // ==========================================================

  final TextEditingController _searchController =
      TextEditingController();

  List<Map<String, String>> _searchResults = [];
  bool _showSearchResults = false;

  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchPlaces(String query) {
  final q = query.trim().toLowerCase();

  setState(() {
    if (q.isEmpty) {
      _searchResults = [];
      _showSearchResults = false;
      return;
    }

    _searchResults = YatraPlaces.all.where((place) {
      final name =
          (place['name'] ?? '').toLowerCase();

      final city =
          (place['city'] ?? '').toLowerCase();

      final location =
          (place['location'] ?? '').toLowerCase();

      final description =
          (place['description'] ?? '').toLowerCase();

      return name.contains(q) ||
          city.contains(q) ||
          location.contains(q) ||
          description.contains(q);
    }).toList();

    _showSearchResults = true;
  });
}

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchResults = [];
      _showSearchResults = false;
    });
  }

  void _openPlace(Map<String, String> place) {
    FocusScope.of(context).unfocus();

    final name = place['name'] ?? '';

    final fullPlace = YatraPlaces.all.firstWhere(
      (p) => p['name'] == name,
      orElse: () => place,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceStoryScreen(place: fullPlace),
      ),
    );
  }

  final List<Map<String, String>> cities = [
    {
      'name': 'Indore',
      'image': 'assets/images/rajwada_indore.jpg',
    },
    {
      'name': 'Jaipur',
      'image': 'assets/images/hawa_mahal_jaipur.jpg',
    },
    {
      'name': 'Mumbai',
      'image': 'assets/images/gateway_mumbai.jpg',
    },
    {
      'name': 'Mysuru',
      'image': 'assets/images/mysore_palace.jpeg',
    },
    {
      'name': 'Bhopal',
      'image': 'assets/images/taj_ul_masajid_bhopal.jpeg',
    },
  ];

 final List<Map<String, String>> popularPlaces =
    YatraPlaces.all.take(10).toList(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E5),
      drawer: const YatraMenuDrawer(),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: YatraHero(
                onScan: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ScannerScreen(),
        ),
      );
    },
    onExplore: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ExploreScreen(),
        ),
      );
    },
  ),
),

            SliverToBoxAdapter(
              child: YatraScannerCard(
    onCamera: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ScannerScreen(),
        ),
      );
    },
    onUpload: _pickPhoto,
  ),
),
            SliverToBoxAdapter(
              child: YatraSearchBar(
    controller: _searchController,
    onChanged: _searchPlaces,
    onClear: _clearSearch,
    showResults: _showSearchResults,
    searchResults: _searchResults,
    onPlaceTap: _openPlace,
  ),
),
            SliverToBoxAdapter(
              child: YatraCityCards(
    cities: cities,
    onCityTap: (cityName) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExploreScreen(
            city: cityName,
          ),
        ),
      );
    },
  ),
),
            SliverToBoxAdapter(
              child: YatraPlaceCards(
  places: popularPlaces,
  onPlaceTap: (place) {
    _openPlace(place);
  },
),
            ),
            SliverToBoxAdapter(
  child: YatraDiscoverCard(
    places: popularPlaces,
    onPlaceTap: (place) {
      _openPlace(place);
    },
  ),
),
            const SliverToBoxAdapter(
              child: SizedBox(height: 105),
            ),
          ],
        ),
      ),
      bottomNavigationBar: YatraBottomNav(
  selectedIndex: selectedIndex,
  onItemSelected: (index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MapScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SavedScreen(),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        ),
      );
    }
  },
  onScanTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScannerScreen(),
      ),
    );
  },
),

    );
  }

  // ==========================================================
  // HERO HEADER
  // ==========================================================

  Widget _buildHero() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final heroHeight = width < 600
            ? width * 0.56
            : width < 1000
                ? width * 0.42
                : 360.0;

        return Container(
          width: double.infinity,
          height: heroHeight,
          decoration: const BoxDecoration(
            color: Color(0xFFE9D9BD),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/yatra_home_header.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFFF3E8D2).withOpacity(0.55),
                      ],
                    ),
                  ),
                ),
              ),

              // MENU
              Positioned(
                left: 18,
                top: 16,
                child: _headerIcon(
                  icon: Icons.menu_rounded,
                  onTap: () {
  Scaffold.of(context).openDrawer();
},
                ),
              ),

              // NOTIFICATIONS
              Positioned(
                right: 58,
                top: 16,
                child: _headerIcon(
                  icon: Icons.notifications_none_rounded,
                  onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const NotificationsScreen(),
    ),
  );
},
                ),
              ),

              // PROFILE
              Positioned(
                right: 16,
                top: 16,
                child: _headerIcon(
                  icon: Icons.person_rounded,
                  filled: true,
                  onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ProfileScreen(),
    ),
  );
},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _headerIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
              filled ? 0.88 : 0.78,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 21,
            color: const Color(0xFF39291F),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // AI SCANNER
  // ==========================================================

  Widget _buildScanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 22),
      height: 285,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFD7C09A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageWidth =
              (constraints.maxWidth * 0.43).clamp(
            170.0,
            245.0,
          );

          return Stack(
            children: [
              Positioned(
                right: -2,
                top: 0,
                bottom: 0,
                width: imageWidth,
                child: Image.asset(
                  'assets/images/yatra_ai_scanner.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight,
                ),
              ),
              Positioned(
                right: imageWidth - 25,
                top: 0,
                bottom: 0,
                width: 85,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFFFFF9EF),
                          const Color(0xFFFFF9EF)
                              .withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  18,
                  18,
                  14,
                ),
                child: SizedBox(
                  width: constraints.maxWidth * 0.56,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2DFC1),
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: Color(0xFFA6532A),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'YATRA AI SCANNER',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: Color(0xFF7C401F),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Text(
                        'What are you\nlooking at?',
                        style: TextStyle(
                          fontFamily: 'Cormorant Garamond',
                          fontSize: 28,
                          height: 1.02,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF263C35),
                        ),
                      ),
                      const SizedBox(height: 9),
                      const Text(
                        'Let YATRA AI identify the place\n'
                        'and tell you its story.',
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.35,
                          color: Color(0xFF665C53),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: _scannerButton(
                              icon: Icons.camera_alt_rounded,
                              title: 'Open Camera',
                              subtitle: 'Take a photo',
                              filled: true,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ScannerScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: _scannerButton(
                              icon:
                                  Icons.photo_library_rounded,
                              title: 'Upload Photo',
                              subtitle: 'From gallery',
                              filled: false,
                              onTap: _pickPhoto,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _scannerButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: filled
                ? const Color(0xFFA6532A)
                : const Color(0xFFFFFDF8),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: filled
                  ? Colors.transparent
                  : const Color(0xFFD8C8AC),
            ),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: const Color(0xFFA6532A)
                          .withOpacity(0.22),
                      blurRadius: 9,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: filled
                      ? Colors.white.withOpacity(0.18)
                      : const Color(0xFFF2E3C8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: filled
                      ? Colors.white
                      : const Color(0xFFA6532A),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: filled
                            ? Colors.white
                            : const Color(0xFF34271F),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 7.5,
                        color: filled
                            ? Colors.white70
                            : const Color(0xFF8A7B6C),
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

  // ==========================================================
  // SEARCH
  // ==========================================================

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 28),
      child: Column(
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF4),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFDCC9A9),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _searchPlaces,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF33271F),
              ),
              decoration: InputDecoration(
                hintText:
                    'Search places, temples, monuments...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9B9186),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFFA6532A),
                ),
                suffixIcon:
                    _searchController.text.isEmpty
                        ? const Icon(
                            Icons.mic_none_rounded,
                            color: Color(0xFF806B58),
                          )
                        : IconButton(
                            onPressed: _clearSearch,
                            icon: const Icon(
                              Icons.close_rounded,
                            ),
                            color:
                                const Color(0xFF806B58),
                          ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 17,
                ),
              ),
            ),
          ),
          if (_showSearchResults) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFDCC9A9),
                ),
              ),
              child: _searchResults.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(18),
                      child: Text(
                        'No place found. Try another monument or city.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF75685D),
                        ),
                      ),
                    )
                  : Column(
                      children:
                          _searchResults.map((place) {
                        return ListTile(
                          onTap: () => _openPlace(place),
                          leading: const CircleAvatar(
                            backgroundColor:
                                Color(0xFFF2E3C8),
                            child: Icon(
                              Icons.location_city_rounded,
                              color: Color(0xFFA6532A),
                            ),
                          ),
                          title: Text(
                            place['name']!,
                            style: const TextStyle(
                              fontFamily:
                                  'Cormorant Garamond',
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF30251F),
                            ),
                          ),
                          subtitle: Text(
                            '${place['city']} • ${place['location']}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF827467),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFFA6532A),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ],
      ),
    );
  }
    // ==========================================================
  // CITY SECTION
  // ==========================================================

  Widget _buildCitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Explore by City'),
        SizedBox(
          height: 176,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            itemCount: cities.length + 1,
            itemBuilder: (context, index) {
              // FINAL CARD: MORE CITIES COMING SOON
              if (index == cities.length) {
                return Container(
                  width: 136,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9D9BD),
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(
                      color: const Color(0xFFD2B98F),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF9EF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Color(0xFFA6532A),
                            size: 23,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'More Cities',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily:
                                'Cormorant Garamond',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2E211B),
                          ),
                        ),
                        const SizedBox(height: 1),
                        const Text(
                          'Coming Soon',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                            color: Color(0xFF8A654C),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final city = cities[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExploreScreen(
                        city: city['name'],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 136,
                  margin: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          city['image']!,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.78),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                city['name']!,
                                style: const TextStyle(
                                  fontFamily:
                                      'Cormorant Garamond',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
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
            },
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  // ==========================================================
  // POPULAR HERITAGE
  // ==========================================================

  
  // ==========================================================
  // DISCOVER
  // ==========================================================

  Widget _buildDiscoverSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Discover with YATRA',
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          height: 142,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9EF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFDCC9A9),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.09),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              SizedBox(
                width: 142,
                height: double.infinity,
                child: Image.asset(
                  'assets/images/khajuraho_detail.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    14,
                    14,
                    10,
                    10,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 18,
                            color: Color(0xFFA6532A),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Did you know?',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF895127),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      const Expanded(
                        child: Text(
                          'The temples of Khajuraho are over 1,000 years old and are famous for their intricate carvings.',
                          style: TextStyle(
                            fontSize: 10.5,
                            height: 1.4,
                            color: Color(0xFF4D4138),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 19,
                          color: Color(0xFFA6532A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _indicator(true),
            _indicator(false),
            _indicator(false),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // SECTION HEADER
  // ==========================================================

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        0,
        18,
        13,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF30251F),
              ),
            ),
          ),
          const Text(
            'See all',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFFA6532A),
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: Color(0xFFA6532A),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PAGE INDICATOR
  // ==========================================================

  Widget _indicator(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(
        horizontal: 3,
      ),
      width: active ? 22 : 8,
      height: 5,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFA6532A)
            : const Color(0xFFC7B8A2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

 

  // ==========================================================
  // PHOTO UPLOAD
  // ==========================================================

  Future<void> _pickPhoto() async {
    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null || !mounted) {
        return;
      }

      final Uint8List bytes =
          await image.readAsBytes();

      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor:
                const Color(0xFFFFF9EF),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(18),
                    child: Image.memory(
                      bytes,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Photo selected',
                    style: TextStyle(
                      fontFamily:
                          'Cormorant Garamond',
                      fontSize: 22,
                      fontWeight:
                          FontWeight.w800,
                      color:
                          Color(0xFF30251F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'This image is ready for YATRA AI recognition.',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          Color(0xFF75685D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AiRecognitionScreen(
                                      imageBytes: bytes,
                                      mimeType: 'image/jpeg',
                                    ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.auto_awesome_rounded,
                      ),
                      label: const Text(
                        'Use Photo',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                                0xFFA6532A),
                        foregroundColor:
                            Colors.white,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showComingSoon('Photo upload');
    }
  }

  // ==========================================================
  // TEMPORARY MESSAGE
  // ==========================================================

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature will be connected next.',
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        backgroundColor:
            const Color(0xFF7B3F2A),
        behavior:
            SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }
}