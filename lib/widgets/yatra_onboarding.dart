import 'package:flutter/material.dart';
import 'yatra_login.dart';

class YatraOnboarding extends StatefulWidget {
  final Widget destination;

  const YatraOnboarding({
    super.key,
    required this.destination,
  });

  @override
  State<YatraOnboarding> createState() => _YatraOnboardingState();
}

class _YatraOnboardingState extends State<YatraOnboarding> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<_YatraOnboardingData> _slides = [
    const _YatraOnboardingData(
      image: 'assets/images/yatra_onboarding_1.png',
      title: "Discover India's Heritage",
      description:
          'Explore magnificent monuments, temples and historic places across incredible cities.',
      label: 'MONUMENTS • TEMPLES • STORIES',
    ),
    const _YatraOnboardingData(
      image: 'assets/images/yatra_onboarding_2.png',
      title: "Explore India's Stories",
      description:
          'Journey across breathtaking heritage sites and uncover the history, architecture and stories behind them.',
      label: 'PLACES • HISTORY • ARCHITECTURE',
    ),
    const _YatraOnboardingData(
      image: 'assets/images/yatra_onboarding_3.png',
      title: 'Arts, Culture & Festivals',
      description:
          'Experience classical traditions, vibrant festivals, crafts and the living culture of India.',
      label: 'CULTURE • TRADITIONS • PEOPLE',
    ),
    const _YatraOnboardingData(
      image: 'assets/images/yatra_onboarding_4.png',
      title: 'Scan. Recognize. Discover.',
      description:
          'Point YATRA AI at a monument or heritage place and let it identify the place and tell you its story.',
      label: 'AI POWERED EXPLORATION',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _skip() {
    _openLogin();
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
      );
    } else {
      _openLogin();
    }
  }

  void _openLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => YatraLogin(
          destination: widget.destination,
        ),
        transitionDuration: const Duration(milliseconds: 650),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241913),
      body: SafeArea(
        child: Stack(
          children: [
            // ========================================================
            // SLIDES
            // ========================================================
            PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildSlide(_slides[index]);
              },
            ),

            // ========================================================
            // TOP BRAND + SKIP
            // ========================================================
            Positioned(
              top: 18,
              left: 22,
              right: 18,
              child: Row(
                children: [
                  // YATRA logo
                  SizedBox(
                    width: 100,
                    height: 34,
                    child: Image.asset(
                      'assets/images/yatra_logo.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      errorBuilder: (_, __, ___) {
                        return const Text(
                          'YATRA',
                          style: TextStyle(
                            color: Color(0xFFE6C477),
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.4,
                          ),
                        );
                      },
                    ),
                  ),

                  const Spacer(),

                  // Skip
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _skip,
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.38),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                        child: const Text(
                          'SKIP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ========================================================
            // BOTTOM GRADIENT
            // ========================================================
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 360,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.10),
                        Colors.black.withOpacity(0.92),
                      ],
                      stops: const [
                        0.0,
                        0.34,
                        1.0,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ========================================================
            // BOTTOM CONTENT
            // ========================================================
            Positioned(
              left: 22,
              right: 22,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) {
                        final active = index == _currentPage;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.only(right: 7),
                          width: active ? 25 : 7,
                          height: 5,
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFFE6C477)
                                : Colors.white.withOpacity(0.48),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Title
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _slides[_currentPage].title,
                      key: ValueKey(_slides[_currentPage].title),
                      style: const TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        color: Colors.white,
                        fontSize: 31,
                        height: 0.98,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 9),

                  // Description
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _slides[_currentPage].description,
                      key: ValueKey(
                        _slides[_currentPage].description,
                      ),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.82),
                        fontSize: 11.5,
                        height: 1.42,
                      ),
                    ),
                  ),

                  const SizedBox(height: 17),

                  // Bottom row
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              size: 15,
                              color: Color(0xFFE6C477),
                            ),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                _slides[_currentPage].label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFFE6C477),
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.55,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Next / Get Started
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _next,
                          borderRadius: BorderRadius.circular(28),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFC57B31),
                                  Color(0xFFE63D5A),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE63D5A)
                                      .withOpacity(0.22),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _currentPage ==
                                          _slides.length - 1
                                      ? 'GET STARTED'
                                      : 'NEXT',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildSlide(_YatraOnboardingData slide) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          slide.image,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (_, __, ___) {
            return Container(
              color: const Color(0xFF3B2920),
            );
          },
        ),

        // Cinematic top shading
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.36),
                  Colors.transparent,
                  Colors.black.withOpacity(0.25),
                ],
                stops: const [0.0, 0.38, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _YatraOnboardingData {
  final String image;
  final String title;
  final String description;
  final String label;

  const _YatraOnboardingData({
    required this.image,
    required this.title,
    required this.description,
    required this.label,
  });
}