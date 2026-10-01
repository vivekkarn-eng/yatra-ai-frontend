import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/place_data.dart';
import '../data/yatra_journey.dart';
import 'saved_screen.dart';
import 'place_story_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Animation<double> _fade(double begin, double end) {
    return CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        begin,
        end,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E5),

      body: Stack(
        children: [
          // ====================================================
          // HERITAGE BACKGROUND
          // ====================================================

          Positioned.fill(
            child: CustomPaint(
              painter: _ProfileBackgroundPainter(),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ==================================================
                // TOP BAR
                // ==================================================

                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fade(0.0, 0.35),
                    child: _buildTopBar(context),
                  ),
                ),

                // ==================================================
                // PROFILE HERO
                // ==================================================

                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fade(0.12, 0.48),
                    child: _buildProfileHero(),
                  ),
                ),

                // ==================================================
                // JOURNEY STATS
                // ==================================================

                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fade(0.25, 0.62),
                    child: _buildJourneyStats(),
                  ),
                ),

                // ==================================================
                // YOUR YATRA
                // ==================================================

                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fade(0.38, 0.75),
                    child: _buildJourneyCard(),
                  ),
                ),

                // ==================================================
                // MENU
                // ==================================================

                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fade(0.52, 0.90),
                    child: _buildMenuSection(context),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 36),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YATRA',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3.2,
                  color: const Color(0xFFA6532A),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'My Profile',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF30251F),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Decorative profile/settings button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9EF),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFDCC9A9),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Color(0xFF7B3F2A),
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PROFILE HERO
  // ==========================================================

  Widget _buildProfileHero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFBF4),
            Color(0xFFF2E3C8),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFDCC9A9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // ----------------------------------------------------
          // LOGO / AVATAR
          // ----------------------------------------------------

          Container(
            width: 94,
            height: 94,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFF9EF),
              border: Border.all(
                color: const Color(0xFFB98A55),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA6532A).withOpacity(0.16),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/yatra_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: Color(0xFFA6532A),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 15),

          Text(
            'YATRA Explorer',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 29,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF30251F),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Story Seeker • Heritage Wanderer',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: const Color(0xFFA6532A),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            height: 1,
            width: 90,
            color: const Color(0xFFB98A55).withOpacity(0.55),
          ),

          const SizedBox(height: 13),

          Text(
            'See a place. Know its story.',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF66584E),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.route_rounded,
                size: 15,
                color: Color(0xFFB98A55),
              ),
              const SizedBox(width: 6),
              Text(
                'Your journey with YATRA begins here',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: const Color(0xFF827467),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // JOURNEY STATS
  // ==========================================================

  Widget _buildJourneyStats() {
  final int placesCount = YatraPlaces.all.length;
  final int savedCount = YatraSaved.names.length;
  final int discoveriesCount =
      YatraJourney.uniqueDiscoveries;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(
          'YOUR JOURNEY',
          'A few footprints from your travels',
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9EF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFE0CFB2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.045),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _statItem(
                  Icons.location_on_rounded,
                  placesCount.toString(),
                  'Places',
                ),
              ),

              _verticalDivider(),

              Expanded(
                child: _statItem(
                  Icons.bookmark_rounded,
                  savedCount.toString(),
                  'Saved',
                ),
              ),

              _verticalDivider(),

              Expanded(
                child: _statItem(
                  Icons.auto_awesome_rounded,
                  discoveriesCount.toString(),
                  'Discoveries',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
  Widget _statItem(
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF2E3C8),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFFA6532A),
          ),
        ),

        const SizedBox(height: 7),

        Text(
          value,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF30251F),
          ),
        ),

        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF827467),
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 62,
      width: 1,
      color: const Color(0xFFE1D2BA),
    );
  }

  // ==========================================================
  // JOURNEY CARD
  // ==========================================================

  Widget _buildJourneyCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF30251F),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative route
          Positioned(
            right: -20,
            top: -25,
            child: Icon(
              Icons.explore_rounded,
              size: 120,
              color: const Color(0xFFB98A55).withOpacity(0.08),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB98A55).withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.route_rounded,
                      color: Color(0xFFD8B77A),
                      size: 19,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR YATRA',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: const Color(0xFFD8B77A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Every place has a story.',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFFF9EF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                height: 1,
                color: Colors.white.withOpacity(0.10),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: Color(0xFFD8B77A),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'Keep exploring India, one story at a time.',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        height: 1.45,
                        color: const Color(0xFFD8D0C6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MENU SECTION
  // ==========================================================

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('EXPLORE YOUR YATRA', 'Everything you need, in one place'),
          const SizedBox(height: 12),
          _premiumMenuItem(context: context, icon: Icons.bookmark_rounded, title: 'Saved Places', subtitle: 'Your collection of heritage stories', onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedScreen()));
            if (mounted) setState(() {});
          }),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.auto_awesome_rounded, title: 'My Discoveries', subtitle: 'Places you discovered with YATRA AI', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const _DiscoveriesScreen()));
          }),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.history_rounded, title: 'Journey History', subtitle: 'Your recent YATRA discoveries', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const _JourneyHistoryScreen()));
          }),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.location_on_rounded, title: 'Places Explored', subtitle: '${YatraPlaces.all.length} places in YATRA', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const _PlacesExploredScreen()));
          }),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.psychology_rounded, title: 'How YATRA AI Works', subtitle: 'Understand the recognition journey', onTap: () => _showHowYatraWorks(context)),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.explore_rounded, title: 'YATRA Experience', subtitle: 'Discover • Recognize • Remember', onTap: () => _showYatraExperience(context)),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.info_outline_rounded, title: 'About YATRA AI', subtitle: 'AI-powered heritage discovery', onTap: () {
            showAboutDialog(context: context, applicationName: 'YATRA AI', applicationVersion: '1.0', applicationIcon: const Icon(Icons.travel_explore_rounded, color: Color(0xFFA6532A), size: 30), children: const [Text('See a place. Know its story.')]);
          }),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.settings_rounded, title: 'Settings', subtitle: 'Manage your YATRA preferences', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const _SettingsScreen()));
          }),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.notifications_none_rounded, title: 'Notifications', subtitle: 'Manage app notifications', onTap: () => _showInfoDialog(context, 'Notifications', 'Notification preferences will be available here as YATRA grows.')),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.language_rounded, title: 'Language', subtitle: 'English', onTap: () => _showLanguageDialog(context)),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.help_outline_rounded, title: 'Help & FAQ', subtitle: 'Find answers about using YATRA', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const _HelpScreen()));
          }),
          const SizedBox(height: 10),
          _premiumMenuItem(context: context, icon: Icons.feedback_outlined, title: 'Feedback', subtitle: 'Share your experience with YATRA', onTap: () => _showFeedbackDialog(context)),
        ],
      ),
    );
  }

  void _showHowYatraWorks(BuildContext context) => _showInfoDialog(context, 'How YATRA AI Works', '1. Capture or upload a photo of a heritage place.\n\n2. YATRA AI analyzes the image and attempts to identify the place.\n\n3. Confirm the recognized place.\n\n4. YATRA generates its story, history and heritage context.\n\n5. Save the place or continue your YATRA.');

  void _showYatraExperience(BuildContext context) => _showInfoDialog(context, 'The YATRA Experience', 'Discover • Recognize • Remember\n\nYATRA AI turns a simple photograph into a journey through India’s heritage. Capture a place, discover its identity, learn its story, and keep it as part of your journey.');

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog<void>(context: context, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFFFF9EF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(title, style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.w700, color: const Color(0xFF30251F))),
      content: Text(message, style: GoogleFonts.poppins(fontSize: 13, height: 1.55, color: const Color(0xFF66584E))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('CLOSE', style: TextStyle(color: Color(0xFFA6532A), fontWeight: FontWeight.w700)))],
    ));
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog<void>(context: context, builder: (_) => SimpleDialog(
      backgroundColor: const Color(0xFFFFF9EF),
      title: Text('Choose Language', style: GoogleFonts.cormorantGaramond(fontSize: 25, fontWeight: FontWeight.w700, color: const Color(0xFF30251F))),
      children: [
        SimpleDialogOption(onPressed: () => Navigator.pop(context), child: const Text('English')),
        SimpleDialogOption(onPressed: () => Navigator.pop(context), child: const Text('हिन्दी')),
        SimpleDialogOption(onPressed: () => Navigator.pop(context), child: const Text('मराठी')),
      ],
    ));
  }

  void _showFeedbackDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(context: context, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFFFF9EF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text('YATRA Feedback', style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.w700, color: const Color(0xFF30251F))),
      content: TextField(controller: controller, maxLines: 5, decoration: InputDecoration(hintText: 'Tell us about your experience...', filled: true, fillColor: const Color(0xFFF7F1E5), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
      actions: [
        TextButton(onPressed: () { controller.dispose(); Navigator.pop(context); }, child: const Text('CANCEL')),
        ElevatedButton(onPressed: () { controller.dispose(); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your feedback!'))); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA6532A), foregroundColor: Colors.white), child: const Text('SEND')),
      ],
    ));
  }

  Widget _premiumMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(21),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9EF),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: const Color(0xFFE0CFB2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E3C8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFA6532A),
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF30251F),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFF827467),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F1E5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Color(0xFFA6532A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION LABEL
  // ==========================================================

  Widget _sectionLabel(
    String eyebrow,
    String title,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: const Color(0xFFA6532A),
          ),
        ),

        const SizedBox(height: 3),

        Text(
          title,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF30251F),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// STEP F SUPPORTING SCREENS
// ============================================================

class _DiscoveriesScreen extends StatelessWidget {
  const _DiscoveriesScreen();
  @override
  Widget build(BuildContext context) {
    final discoveries = YatraJourney.history;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E5),
      appBar: AppBar(backgroundColor: const Color(0xFFF7F1E5), foregroundColor: const Color(0xFF30251F), elevation: 0, title: const Text('My Discoveries', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w800))),
      body: discoveries.isEmpty ? _emptyPage(Icons.auto_awesome_rounded, 'No discoveries yet', 'Recognize a heritage place with YATRA AI and it will appear here.') : ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: discoveries.length, separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _journeyTile(context, discoveries[i], Icons.auto_awesome_rounded),
      ),
    );
  }
}

class _JourneyHistoryScreen extends StatelessWidget {
  const _JourneyHistoryScreen();
  @override
  Widget build(BuildContext context) {
    final history = YatraJourney.history;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E5),
      appBar: AppBar(backgroundColor: const Color(0xFFF7F1E5), foregroundColor: const Color(0xFF30251F), elevation: 0, title: const Text('Journey History', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w800))),
      body: history.isEmpty ? _emptyPage(Icons.route_rounded, 'Your journey starts here', 'Your recognized places will appear in your YATRA history.') : ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: history.length, separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _journeyTile(context, history[i], Icons.history_rounded),
      ),
    );
  }
}

class _PlacesExploredScreen extends StatelessWidget {
  const _PlacesExploredScreen();
  @override
  Widget build(BuildContext context) {
    final places = YatraPlaces.all;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E5),
      appBar: AppBar(backgroundColor: const Color(0xFFF7F1E5), foregroundColor: const Color(0xFF30251F), elevation: 0, title: const Text('Places Explored', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w800))),
      body: ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: places.length, separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _placeTile(context, places[i], Icons.location_on_rounded),
      ),
    );
  }
}

Map<String, String> _placeByName(String name) {
  return YatraPlaces.all.firstWhere((p) => p['name'] == name, orElse: () => {'name': name, 'city': '', 'location': '', 'image': ''});
}

Widget _journeyTile(BuildContext context, String name, IconData icon) => _placeTile(context, _placeByName(name), icon);

Widget _placeTile(BuildContext context, Map<String, String> place, IconData fallbackIcon) {
  final image = place['image'] ?? '';
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceStoryScreen(place: place))),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFFFFF9EF), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE0CFB2))),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(13), child: image.isEmpty ? Container(width: 62, height: 62, color: const Color(0xFFE5D5B8), child: Icon(fallbackIcon, color: const Color(0xFFA6532A))) : Image.asset(image, width: 62, height: 62, fit: BoxFit.cover)),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(place['name'] ?? '', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF30251F))),
            const SizedBox(height: 4),
            Text('${place['city'] ?? ''} • ${place['location'] ?? ''}', style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF827467))),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Color(0xFFA6532A)),
        ]),
      ),
    ),
  );
}

Widget _emptyPage(IconData icon, String title, String message) => Center(
  child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 76, height: 76, decoration: const BoxDecoration(color: Color(0xFFF2E3C8), shape: BoxShape.circle), child: Icon(icon, size: 38, color: Color(0xFFA6532A))),
    const SizedBox(height: 17),
    Text(title, textAlign: TextAlign.center, style: GoogleFonts.cormorantGaramond(fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFF30251F))),
    const SizedBox(height: 8),
    Text(message, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12, height: 1.5, color: const Color(0xFF827467))),
  ]),
));

class _SettingsScreen extends StatefulWidget {
  const _SettingsScreen();
  @override State<_SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  bool notifications = true;
  bool saveJourney = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F1E5),
    appBar: AppBar(backgroundColor: const Color(0xFFF7F1E5), foregroundColor: const Color(0xFF30251F), elevation: 0, title: const Text('Settings', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w800))),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      _setting('Notifications', 'Receive YATRA updates', Icons.notifications_rounded, Switch(value: notifications, activeColor: const Color(0xFFA6532A), onChanged: (v) => setState(() => notifications = v))),
      const SizedBox(height: 10),
      _setting('Journey Tracking', 'Keep your discoveries in your journey', Icons.route_rounded, Switch(value: saveJourney, activeColor: const Color(0xFFA6532A), onChanged: (v) => setState(() => saveJourney = v))),
      const SizedBox(height: 10),
      _setting('Language', 'English', Icons.language_rounded, const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFA6532A))),
      const SizedBox(height: 10),
      _setting('App Version', 'YATRA AI • Version 1.0', Icons.info_outline_rounded, const SizedBox.shrink()),
    ]),
  );
  Widget _setting(String title, String subtitle, IconData icon, Widget trailing) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(color: const Color(0xFFFFF9EF), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE0CFB2))),
    child: Row(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFF2E3C8), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: const Color(0xFFA6532A), size: 20)),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF30251F))), const SizedBox(height: 3), Text(subtitle, style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF827467)))])),
      trailing,
    ]),
  );
}

class _HelpScreen extends StatelessWidget {
  const _HelpScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F1E5),
    appBar: AppBar(backgroundColor: const Color(0xFFF7F1E5), foregroundColor: const Color(0xFF30251F), elevation: 0, title: const Text('Help & FAQ', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w800))),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      _faq('How does YATRA AI identify a place?', 'YATRA AI analyzes the photo you capture or upload and attempts to match it with the supported heritage places.'),
      _faq('What happens after recognition?', 'After recognition, you can confirm the place and open its story to learn about its history, architecture and heritage.'),
      _faq('Where are my saved places?', 'Places saved from a story page appear in Saved Places inside your Profile.'),
      _faq('What is Journey History?', 'Journey History records the places successfully recognized through the YATRA AI scanner.'),
      _faq('Can I explore places without scanning them?', 'Yes. Explore and Search allow you to browse places directly from the YATRA database.'),
      _faq('What if YATRA cannot recognize my photo?', 'Try another photo with the monument clearly visible and enough lighting. YATRA may not recognize every image successfully.'),
    ]),
  );
  Widget _faq(String q, String a) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(color: const Color(0xFFFFF9EF), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE0CFB2))),
    child: ExpansionTile(iconColor: const Color(0xFFA6532A), collapsedIconColor: const Color(0xFFA6532A), title: Text(q, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF30251F))), childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [Text(a, style: GoogleFonts.poppins(fontSize: 11, height: 1.5, color: const Color(0xFF827467)))]),
  );
}

// ============================================================
// HERITAGE BACKGROUND PAINTER
// ============================================================

class _ProfileBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFFB98A55).withOpacity(0.055);

    final center = Offset(
      size.width * 0.88,
      size.height * 0.18,
    );

    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        center,
        45 + (i * 22),
        paint,
      );
    }

    // Small route line
    final path = Path();

    path.moveTo(
      size.width * 0.05,
      size.height * 0.50,
    );

    path.cubicTo(
      size.width * 0.30,
      size.height * 0.44,
      size.width * 0.58,
      size.height * 0.57,
      size.width * 0.94,
      size.height * 0.47,
    );

    canvas.drawPath(path, paint);

    // Route dots
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFB98A55).withOpacity(0.07);

    final dots = [
      Offset(size.width * 0.08, size.height * 0.49),
      Offset(size.width * 0.34, size.height * 0.47),
      Offset(size.width * 0.61, size.height * 0.54),
      Offset(size.width * 0.91, size.height * 0.48),
    ];

    for (final dot in dots) {
      canvas.drawCircle(dot, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}