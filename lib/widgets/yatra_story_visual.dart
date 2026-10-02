import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YatraStoryVisual extends StatefulWidget {
  final String name;
  final String city;
  final String location;
  final String? image;

  final String intro;
  final Map<String, String> sections;

  final bool loading;
  final String? error;

  final VoidCallback onRetry;
  final VoidCallback onBack;

  final List<Map<String, String>> nearbyPlaces;
  final ValueChanged<Map<String, String>> onExplorePlace;

  const YatraStoryVisual({
    super.key,
    required this.name,
    required this.city,
    required this.location,
    required this.image,
    required this.intro,
    required this.sections,
    required this.loading,
    required this.error,
    required this.onRetry,
    required this.onBack,
    required this.nearbyPlaces,
    required this.onExplorePlace,
  });

  @override
  State<YatraStoryVisual> createState() => _YatraStoryVisualState();
}

class _YatraStoryVisualState extends State<YatraStoryVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _ink => const Color(0xFF4B3024);
  Color get _terracotta => const Color(0xFFA6532A);
  Color get _gold => const Color(0xFFB88743);
  Color get _paper => const Color(0xFFF7E8C9);

  IconData _iconFor(String title) {
    switch (title) {
      case 'THE STORY':
        return Icons.auto_stories_rounded;
      case 'HISTORY':
        return Icons.history_edu_rounded;
      case 'ARCHITECTURE':
        return Icons.account_balance_rounded;
      case 'WHAT MAKES IT SPECIAL':
        return Icons.auto_awesome_rounded;
      case 'DID YOU KNOW?':
        return Icons.lightbulb_rounded;
      case 'VISITOR CONTEXT':
        return Icons.travel_explore_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  String _clean(String text) {
    return text
        .replaceAll('###', '')
        .replaceAll('##', '')
        .replaceAll('#', '')
        .replaceAll('**', '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4C99B),
      body: Stack(
        children: [
          // ==========================================================
          // ANTIQUE MAP BACKGROUND
          // ==========================================================

          Positioned.fill(
            child: Image.asset(
              'assets/images/yatra_story_background.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // Warm overlay so text remains readable.
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF2DDB5).withOpacity(0.22),
            ),
          ),

          // ==========================================================
          // CONTENT
          // ==========================================================

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHero(),

                        const SizedBox(height: 22),

                        _buildAiLabel(),

                        const SizedBox(height: 16),

                        if (widget.loading)
                          _buildLoading()
                        else if (widget.error != null)
                          _buildError()
                        else ...[
                          if (widget.intro.trim().isNotEmpty)
                            _buildIntro(),

                          const SizedBox(height: 10),

                          ..._buildSections(),

                          if (widget.nearbyPlaces.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            _buildExploreAround(),
                            const SizedBox(height: 22),
                          ],

                          _buildGeneratedFooter(),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // TOP BAR
  // ================================================================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
      child: Row(
        children: [
          _paperButton(
            icon: Icons.arrow_back_rounded,
            onTap: widget.onBack,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _terracotta,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Color(0xFFFFEBC6),
                    size: 18,
                  ),
                ),

                const SizedBox(width: 9),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YATRA',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: _ink,
                      ),
                    ),
                    Text(
                      'HERITAGE JOURNAL',
                      style: GoogleFonts.poppins(
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                        color: _terracotta,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animationController.value * math.pi * 2,
                child: child,
              );
            },
            child: Icon(
              Icons.explore_outlined,
              size: 29,
              color: _ink.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paperButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: _paper.withOpacity(0.92),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: _gold.withOpacity(0.55),
            ),
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
            color: _ink,
            size: 21,
          ),
        ),
      ),
    );
  }

  // ================================================================
  // HERO
  // ================================================================

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            if (widget.image != null && widget.image!.isNotEmpty)
              Image.asset(
                widget.image!,
                width: double.infinity,
                height: 290,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _heroFallback();
                },
              )
            else
              _heroFallback(),

            // cinematic gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.68),
                    ],
                  ),
                ),
              ),
            ),

            // Heritage label
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: _paper.withOpacity(0.94),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _gold.withOpacity(0.65),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_balance_rounded,
                      size: 13,
                      color: _terracotta,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'HERITAGE DISCOVERY',
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: _terracotta,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 20,
              right: 20,
              bottom: 19,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 38,
                      height: 0.95,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFFFFD48A),
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          [
                            if (widget.city.isNotEmpty) widget.city,
                            if (widget.location.isNotEmpty) widget.location,
                          ].join(' • '),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Small antique corner detail
            Positioned(
              right: 15,
              top: 15,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.65),
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.explore_outlined,
                  color: Colors.white.withOpacity(0.85),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroFallback() {
    return Container(
      height: 290,
      width: double.infinity,
      color: const Color(0xFFC38A57),
      child: const Center(
        child: Icon(
          Icons.account_balance_rounded,
          color: Colors.white70,
          size: 75,
        ),
      ),
    );
  }

  // ================================================================
  // AI LABEL
  // ================================================================

  Widget _buildAiLabel() {
    return Row(
      children: [
        Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            color: _terracotta,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _terracotta.withOpacity(0.22),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 15,
          ),
        ),

        const SizedBox(width: 9),

        Text(
          'A STORY CURATED BY YATRA AI',
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: _terracotta,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Container(
            height: 1,
            color: _terracotta.withOpacity(0.28),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // INTRO
  // ================================================================

  Widget _buildIntro() {
    final text = _clean(widget.intro);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: _paper.withOpacity(0.94),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: _gold.withOpacity(0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 15,
            offset: const Offset(3, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -8,
            child: Icon(
              Icons.explore_outlined,
              size: 75,
              color: _gold.withOpacity(0.10),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: _terracotta,
                    size: 25,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'THE JOURNEY BEGINS',
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      color: _terracotta,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                text,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 21,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: _gold.withOpacity(0.45),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 9),
                    child: Icon(
                      Icons.diamond_outlined,
                      size: 11,
                      color: Color(0xFFB88743),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Color(0x73B88743),
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

  // ================================================================
  // SECTIONS
  // ================================================================

  List<Widget> _buildSections() {
    const order = [
      'THE STORY',
      'HISTORY',
      'ARCHITECTURE',
      'WHAT MAKES IT SPECIAL',
      'DID YOU KNOW?',
      'VISITOR CONTEXT',
    ];

    final widgets = <Widget>[];

    for (final title in order) {
      final content = widget.sections[title];

      if (content == null || content.trim().isEmpty) {
        continue;
      }

      widgets.add(
        _buildJournalSection(
          title,
          content,
          index: widgets.length,
        ),
      );

      widgets.add(const SizedBox(height: 18));
    }

    return widgets;
  }

  Widget _buildJournalSection(
    String title,
    String content, {
    required int index,
  }) {
    final paragraphs = content
        .split('\n')
        .map((e) => _clean(e))
        .where((e) => e.isNotEmpty)
        .toList();

    final isStory = title == 'THE STORY';
    final isHistory = title == 'HISTORY';
    final isFact = title == 'DID YOU KNOW?';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _paper.withOpacity(0.96),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: _gold.withOpacity(0.55),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 16,
            offset: const Offset(3, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          // faint compass/map decoration
          Positioned(
            right: -22,
            top: -20,
            child: Icon(
              Icons.explore_outlined,
              size: 105,
              color: _gold.withOpacity(0.075),
            ),
          ),

          Positioned(
            left: -18,
            bottom: -18,
            child: Icon(
              Icons.account_balance_outlined,
              size: 90,
              color: _terracotta.withOpacity(0.045),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(19, 19, 19, 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section heading
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: _terracotta.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _terracotta.withOpacity(0.28),
                        ),
                      ),
                      child: Icon(
                        _iconFor(title),
                        color: _terracotta,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: _terracotta,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            width: 55,
                            height: 2,
                            color: _gold,
                          ),
                        ],
                      ),
                    ),

                    Text(
                      '${(index + 1).toString().padLeft(2, '0')}',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _gold.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 17),

                // Special visual marker for history
                if (isHistory) ...[
                  _buildHistoryMarker(),
                  const SizedBox(height: 16),
                ],

                // Story section gets a small decorative divider
                if (isStory) ...[
                  _buildOrnamentalDivider(),
                  const SizedBox(height: 14),
                ],

                ...paragraphs.map(
                  (paragraph) {
                    final isBullet = paragraph.startsWith('-') ||
                        paragraph.startsWith('*') ||
                        paragraph.startsWith('•');

                    final cleanText = isBullet
                        ? paragraph.replaceFirst(
                            RegExp(r'^[-*•]\s*'),
                            '',
                          )
                        : paragraph;

                    if (isBullet) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Icon(
                                Icons.diamond_rounded,
                                size: 6,
                                color: _terracotta,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                cleanText,
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 19,
                                  height: 1.38,
                                  fontWeight: FontWeight.w500,
                                  color: _ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        cleanText,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isFact ? 20 : 18.5,
                          height: 1.42,
                          fontWeight:
                              isFact ? FontWeight.w600 : FontWeight.w500,
                          color: _ink,
                        ),
                      ),
                    );
                  },
                ),

                // Special ending ornament
                const SizedBox(height: 3),
                _buildOrnamentalDivider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryMarker() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE7C88E).withOpacity(0.38),
        border: Border(
          top: BorderSide(
            color: _gold.withOpacity(0.45),
          ),
          bottom: BorderSide(
            color: _gold.withOpacity(0.45),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            color: _terracotta,
            size: 20,
          ),
          const SizedBox(width: 9),
          Text(
            'FROM THE ARCHIVES',
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: _terracotta,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.history_rounded,
            color: _gold,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildOrnamentalDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: _gold.withOpacity(0.4),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 9),
          child: Icon(
            Icons.diamond_outlined,
            size: 10,
            color: Color(0xFFB88743),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Color(0x66B88743),
          ),
        ),
      ],
    );
  }


  // ================================================================
  // EXPLORE AROUND
  // ================================================================

  Widget _buildExploreAround() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _paper.withOpacity(0.96),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _gold.withOpacity(0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 16,
            offset: const Offset(3, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -18,
            child: Icon(
              Icons.explore_outlined,
              size: 105,
              color: _gold.withOpacity(0.075),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(19, 19, 19, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: _terracotta.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _terracotta.withOpacity(0.28),
                        ),
                      ),
                      child: const Icon(
                        Icons.explore_rounded,
                        color: Color(0xFFA6532A),
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXPLORE AROUND',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: _terracotta,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'More heritage places in ${widget.city}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _ink.withOpacity(0.78),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                ...widget.nearbyPlaces.map(
                  (place) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildExplorePlaceTile(place),
                  ),
                ),
                const SizedBox(height: 3),
                _buildOrnamentalDivider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplorePlaceTile(Map<String, String> place) {
    final name = place['name'] ?? 'Heritage Place';
    final image = place['image'] ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onExplorePlace(place),
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFFE7C88E).withOpacity(0.28),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: _gold.withOpacity(0.32),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: SizedBox(
                  width: 68,
                  height: 62,
                  child: image.isNotEmpty
                      ? Image.asset(
                          image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return _exploreImageFallback();
                          },
                        )
                      : _exploreImageFallback(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 20,
                        height: 1.05,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: _terracotta,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place['city'] ?? widget.city,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: _terracotta,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _terracotta,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _exploreImageFallback() {
    return Container(
      color: const Color(0xFFC38A57),
      child: const Center(
        child: Icon(
          Icons.account_balance_rounded,
          color: Colors.white70,
          size: 28,
        ),
      ),
    );
  }

  // ================================================================
  // LOADING
  // ================================================================

  Widget _buildLoading() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 38,
      ),
      decoration: BoxDecoration(
        color: _paper.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _gold.withOpacity(0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 15,
            offset: const Offset(3, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: _terracotta,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'YATRA AI IS WRITING THE STORY',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
              color: _terracotta,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Tracing history, architecture and forgotten details...',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: _ink,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ERROR
  // ================================================================

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: _paper.withOpacity(0.96),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _terracotta.withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(3, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 45,
            color: _terracotta,
          ),

          const SizedBox(height: 13),

          Text(
            widget.error ?? 'Something went wrong.',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _ink,
            ),
          ),

          const SizedBox(height: 17),

          ElevatedButton.icon(
            onPressed: widget.onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 17),
            label: const Text('TRY AGAIN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _terracotta,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // FOOTER
  // ================================================================

  Widget _buildGeneratedFooter() {
    return Center(
      child: Column(
        children: [
          _buildOrnamentalDivider(),

          const SizedBox(height: 13),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 14,
                color: _terracotta,
              ),
              const SizedBox(width: 7),
              Text(
                'GENERATED BY YATRA AI',
                style: GoogleFonts.poppins(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                  color: _terracotta,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            'See a place. Know its story.',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: _ink.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}