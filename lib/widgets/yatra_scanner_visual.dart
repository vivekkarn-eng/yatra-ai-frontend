import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YatraScannerVisual extends StatelessWidget {
  final Widget preview;
  final bool photoCaptured;
  final bool isCapturing;
  final bool isRestarting;
  final bool isUsingPhoto;

  final VoidCallback onCapture;
  final VoidCallback onRetake;
  final VoidCallback onUsePhoto;
  final VoidCallback onBack;

  const YatraScannerVisual({
    super.key,
    required this.preview,
    required this.photoCaptured,
    required this.isCapturing,
    required this.isRestarting,
    required this.isUsingPhoto,
    required this.onCapture,
    required this.onRetake,
    required this.onUsePhoto,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17100C),
      body: Stack(
        children: [
          // =====================================================
          // CAMERA / PHOTO AREA
          // =====================================================

          Positioned.fill(
            child: preview,
          ),

          // =====================================================
          // CINEMATIC DARK OVERLAY
          // =====================================================

          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.72),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.78),
                    ],
                    stops: const [
                      0.0,
                      0.25,
                      0.62,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // =====================================================
          // TOP BAR
          // =====================================================

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                10,
                18,
                0,
              ),
              child: Row(
                children: [
                  _circleButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: onBack,
                  ),

                  const Spacer(),

                  Column(
                    children: [
                      Text(
                        'YATRA',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 25,
                          height: 0.85,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          color: const Color(0xFFF4D59A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        photoCaptured
                            ? 'PHOTO CAPTURED'
                            : 'AI SCANNER',
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.1,
                          color: Colors.white.withOpacity(0.82),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  _circleButton(
                    icon: photoCaptured
                        ? Icons.close_rounded
                        : Icons.flash_off_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // =====================================================
          // MAP / COMPASS DETAIL
          // =====================================================

          Positioned(
            top: 118,
            right: 25,
            child: Opacity(
              opacity: 0.55,
              child: _compass(),
            ),
          ),

          // =====================================================
          // SCANNING FRAME
          // =====================================================

          if (!photoCaptured)
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  31,
                  155,
                  31,
                  205,
                ),
                child: CustomPaint(
                  painter: _ScannerFramePainter(),
                ),
              ),
            ),

          // =====================================================
          // LIVE SCAN LABEL
          // =====================================================

          if (!photoCaptured)
            Positioned(
              top: 154,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.38),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE6B967)
                          .withOpacity(0.65),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8B65E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'ALIGN THE MONUMENT',
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // =====================================================
          // CAPTURED BADGE
          // =====================================================

          if (photoCaptured)
            Positioned(
              top: 145,
              left: 22,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3E291D)
                      .withOpacity(0.86),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFD6A35C),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: Color(0xFFE8B967),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'CAPTURED',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // =====================================================
          // BOTTOM CONTROL PANEL
          // =====================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  12,
                  24,
                  18,
                ),
                child: photoCaptured
                    ? _capturedControls()
                    : _cameraControls(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // LIVE CAMERA CONTROLS
  // ===========================================================

  Widget _cameraControls() {
    return Column(
      children: [
        Text(
          'Discover the story behind what you see.',
          textAlign: TextAlign.center,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.88),
          ),
        ),

        const SizedBox(height: 17),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _smallAction(
              icon: Icons.photo_library_outlined,
              label: 'GALLERY',
              onTap: () {},
            ),

            const SizedBox(width: 42),

            GestureDetector(
              onTap: isCapturing || isRestarting
                  ? null
                  : onCapture,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 82,
                height: 82,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3C271B)
                      .withOpacity(0.92),
                  border: Border.all(
                    color: const Color(0xFFD9A75E),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE0A95B)
                          .withOpacity(0.30),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFE0B06B),
                        Color(0xFFA86732),
                      ],
                    ),
                  ),
                  child: Icon(
                    isCapturing
                        ? Icons.hourglass_top_rounded
                        : Icons.camera_alt_rounded,
                    size: 31,
                    color: const Color(0xFFFFF4DC),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 42),

            _smallAction(
              icon: Icons.flip_camera_ios_outlined,
              label: 'FLIP',
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          'AI SCAN',
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: const Color(0xFFE7B764),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // CAPTURED CONTROLS
  // ===========================================================

  Widget _capturedControls() {
    return Row(
      children: [
        Expanded(
          child: _outlineButton(
            icon: Icons.refresh_rounded,
            label: 'RETAKE',
            onTap: isRestarting || isUsingPhoto
                ? null
                : onRetake,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          flex: 1,
          child: _primaryButton(
            icon: Icons.auto_awesome_rounded,
            label: isUsingPhoto
                ? 'OPENING...'
                : 'USE PHOTO',
            onTap: isRestarting || isUsingPhoto
                ? null
                : onUsePhoto,
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // BUTTONS
  // ===========================================================

  Widget _outlineButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      height: 58,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 19),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF0D39C),
          side: BorderSide(
            color: const Color(0xFFD3A45E)
                .withOpacity(0.85),
          ),
          backgroundColor:
              Colors.black.withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _primaryButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      height: 58,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDFAE61),
          foregroundColor: const Color(0xFF42291C),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _smallAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.55),
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.42),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFD5A45F)
                  .withOpacity(0.75),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFFF4D59A),
          ),
        ),
      ),
    );
  }

  Widget _compass() {
    return SizedBox(
      width: 58,
      height: 58,
      child: CustomPaint(
        painter: _CompassPainter(),
      ),
    );
  }
}

// =============================================================
// SCANNER FRAME
// =============================================================

class _ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE9B65F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const length = 35.0;

    // top-left
    canvas.drawLine(
      const Offset(0, length),
      const Offset(0, 0),
      paint,
    );
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(length, 0),
      paint,
    );

    // top-right
    canvas.drawLine(
      Offset(size.width - length, 0),
      Offset(size.width, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, length),
      paint,
    );

    // bottom-left
    canvas.drawLine(
      Offset(0, size.height - length),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(length, size.height),
      paint,
    );

    // bottom-right
    canvas.drawLine(
      Offset(size.width - length, size.height),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - length),
      Offset(size.width, size.height),
      paint,
    );

    // center scan line
    final linePaint = Paint()
      ..color = const Color(0xFFE6B45D)
          .withOpacity(0.72)
      ..strokeWidth = 1.2;

    canvas.drawLine(
      Offset(
        0,
        size.height * 0.52,
      ),
      Offset(
        size.width,
        size.height * 0.52,
      ),
      linePaint,
    );

    // small center marker
    canvas.drawCircle(
      Offset(
        size.width * 0.5,
        size.height * 0.52,
      ),
      4,
      Paint()
        ..color = const Color(0xFFF2C879),
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// =============================================================
// COMPASS
// =============================================================

class _CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final paint = Paint()
      ..color = const Color(0xFFE8C47B)
          .withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(
      center,
      25,
      paint,
    );

    canvas.drawCircle(
      center,
      20,
      paint,
    );

    canvas.drawLine(
      Offset(center.dx - 16, center.dy + 16),
      Offset(center.dx + 16, center.dy - 16),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx - 16, center.dy - 16),
      Offset(center.dx + 16, center.dy + 16),
      paint,
    );

    final north = Path()
      ..moveTo(center.dx, center.dy - 17)
      ..lineTo(center.dx - 4, center.dy - 5)
      ..lineTo(center.dx + 4, center.dy - 5)
      ..close();

    canvas.drawPath(
      north,
      Paint()
        ..color = const Color(0xFFE8C47B)
            .withOpacity(0.7),
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}