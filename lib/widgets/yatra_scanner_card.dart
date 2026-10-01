import 'package:flutter/material.dart';

class YatraScannerCard extends StatelessWidget {
  final VoidCallback? onCamera;
  final VoidCallback? onUpload;

  const YatraScannerCard({
    super.key,
    this.onCamera,
    this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 18, 14, 28),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFF2E211B),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/yatra_ai_scanner.png',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF3B2920),
                );
              },
            ),
          ),

          // Dark cinematic overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF241913).withOpacity(0.98),
                    const Color(0xFF241913).withOpacity(0.82),
                    const Color(0xFF241913).withOpacity(0.35),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.42, 0.72, 1.0],
                ),
              ),
            ),
          ),

          // Gold glow
          Positioned(
            right: -50,
            top: -55,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFE6C477).withOpacity(0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE6C477),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'YATRA AI',
                      style: TextStyle(
                        color: Color(0xFFE6C477),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Main heading
                const Text(
                  'What are you\nlooking at?',
                  style: TextStyle(
                    fontFamily: 'Cormorant Garamond',
                    color: Colors.white,
                    fontSize: 31,
                    height: 0.98,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                // Description
                Text(
                  'Let YATRA identify the place\n'
                  'and uncover its story.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.76),
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                ),

                const Spacer(),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: onCamera,
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            size: 18,
                          ),
                          label: const Text(
                            'Open Camera',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFE6C477),
                            foregroundColor:
                                const Color(0xFF2E211B),
                            elevation: 5,
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
                    const SizedBox(width: 9),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: onUpload,
                          icon: const Icon(
                            Icons.photo_library_rounded,
                            size: 18,
                          ),
                          label: const Text(
                            'Upload Photo',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.white.withOpacity(0.08),
                            side: const BorderSide(
                              color: Color(0xFFE6C477),
                              width: 1.1,
                            ),
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

                const SizedBox(height: 11),

                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: Color(0xFFE6C477),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AI-powered heritage recognition',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.58),
                        fontSize: 9.5,
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
    );
  }
}