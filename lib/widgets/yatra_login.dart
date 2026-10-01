import 'package:flutter/material.dart';

class YatraLogin extends StatefulWidget {
  final Widget destination;

  const YatraLogin({
    super.key,
    required this.destination,
  });

  @override
  State<YatraLogin> createState() => _YatraLoginState();
}

class _YatraLoginState extends State<YatraLogin> {
  bool _mobileMode = true;

  final TextEditingController _mobileController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _nameController =
      TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _continueAsGuest() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => widget.destination,
      ),
    );
  }

  void _generateOtp() {
    final value = _mobileMode
        ? _mobileController.text.trim()
        : _emailController.text.trim();

    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _mobileMode
                ? 'Please enter your mobile number.'
                : 'Please enter your email address.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _showOtpDialog();
  }

  void _showOtpDialog() {
    final otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFBF4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Verify your journey',
            style: TextStyle(
              fontFamily: 'Cormorant Garamond',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF30251F),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'A 6-digit OTP has been requested.',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF75685D),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Demo OTP: 123456',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFA6532A),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 5,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                  filled: true,
                  fillColor: const Color(0xFFF5EADB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            18,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF806B58),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (otpController.text.trim().length == 6) {
                  Navigator.pop(dialogContext);
                  _continueAsGuest();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter the 6-digit demo OTP.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA6532A),
                foregroundColor: Colors.white,
              ),
              child: const Text('VERIFY'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EFE2),
      body: SafeArea(
        child: Stack(
          children: [
            // ========================================================
            // SUBTLE HERITAGE BACKGROUND
            // ========================================================
            Positioned.fill(
              child: CustomPaint(
                painter: _LoginPatternPainter(),
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                22,
              ),
              child: Column(
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.82),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD9C4A2),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 19,
                            color: Color(0xFF49382D),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // LOGO
                  // ==================================================
                  Container(
                    width: 70,
                    height: 70,
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFF241913),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE6C477),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/yatra_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return const Center(
                          child: Text(
                            'Y',
                            style: TextStyle(
                              color: Color(0xFFE6C477),
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'YATRA',
                    style: TextStyle(
                      color: Color(0xFFA6532A),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3.5,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Welcome, Traveller',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cormorant Garamond',
                      color: Color(0xFF30251F),
                      fontSize: 32,
                      height: 0.95,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Discover India's timeless heritage,\n"
                    'ancient temples, dynasties and living culture.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF776A5D),
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // LOGIN CARD
                  // ==================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: const Color(0xFFDCC9A9),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Method selector
                        Container(
                          height: 48,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8D2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _methodButton(
                                  icon: Icons.phone_iphone_rounded,
                                  label: 'Mobile (OTP)',
                                  active: _mobileMode,
                                  onTap: () {
                                    setState(() {
                                      _mobileMode = true;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: _methodButton(
                                  icon: Icons.mail_outline_rounded,
                                  label: 'Email',
                                  active: !_mobileMode,
                                  onTap: () {
                                    setState(() {
                                      _mobileMode = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          _mobileMode
                              ? 'MOBILE NUMBER'
                              : 'EMAIL ADDRESS',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF75685D),
                          ),
                        ),

                        const SizedBox(height: 7),

                        if (_mobileMode)
                          Row(
                            children: [
                              Container(
                                height: 52,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFBF4),
                                  borderRadius:
                                      BorderRadius.circular(15),
                                  border: Border.all(
                                    color: const Color(0xFFDCC9A9),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      '🇮🇳',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '+91',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: _textField(
                                  controller: _mobileController,
                                  hint: 'Enter 10-digit number',
                                  keyboardType:
                                      TextInputType.phone,
                                ),
                              ),
                            ],
                          )
                        else
                          _textField(
                            controller: _emailController,
                            hint: 'Enter your email address',
                            keyboardType:
                                TextInputType.emailAddress,
                          ),

                        const SizedBox(height: 6),

                        Text(
                          _mobileMode
                              ? 'A 6-digit OTP will be generated for verification.'
                              : 'We will use your email for account access.',
                          style: const TextStyle(
                            fontSize: 8.5,
                            color: Color(0xFF95887A),
                          ),
                        ),

                        const SizedBox(height: 17),

                        const Text(
                          'YOUR NAME (OPTIONAL)',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF75685D),
                          ),
                        ),

                        const SizedBox(height: 7),

                        _textField(
                          controller: _nameController,
                          hint: 'e.g. Vivek, Explorer',
                          keyboardType: TextInputType.name,
                        ),

                        const SizedBox(height: 16),

                        // Continue / OTP
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _generateOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFA6532A),
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shadowColor:
                                  Colors.black.withOpacity(0.18),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(17),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  _mobileMode
                                      ? 'GENERATE & SEND OTP'
                                      : 'CONTINUE WITH EMAIL',
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.35,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // OR
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFD8C4A4),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 9,
                            color: Color(0xFF8D7D6B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFD8C4A4),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Guest
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _continueAsGuest,
                      icon: const Icon(
                        Icons.person_outline_rounded,
                        size: 18,
                      ),
                      label: const Text(
                        'Continue as Guest Explorer',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF694A34),
                        side: const BorderSide(
                          color: Color(0xFFCDB58E),
                        ),
                        backgroundColor:
                            Colors.white.withOpacity(0.62),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Your journey begins with a place worth discovering.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cormorant Garamond',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF806B58),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'By continuing, you agree to the YATRA demo experience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 7.5,
                      color: Color(0xFFA09284),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _methodButton({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: active
                ? Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: active
                    ? const Color(0xFFA6532A)
                    : const Color(0xFF857668),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: active
                      ? const Color(0xFF4D392D)
                      : const Color(0xFF857668),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF30251F),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 10.5,
          color: Color(0xFF9B8D7D),
        ),
        filled: true,
        fillColor: const Color(0xFFFFFBF4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFDCC9A9),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFDCC9A9),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFA6532A),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

class _LoginPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = const Color(0xFFB18C5A).withOpacity(0.11);

    final center = Offset(
      size.width * 0.88,
      size.height * 0.15,
    );

    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(
        center,
        i * 42,
        paint,
      );
    }

    final route = Path();

    route.moveTo(
      size.width * 0.03,
      size.height * 0.86,
    );

    route.cubicTo(
      size.width * 0.25,
      size.height * 0.72,
      size.width * 0.45,
      size.height * 0.95,
      size.width * 0.68,
      size.height * 0.78,
    );

    route.cubicTo(
      size.width * 0.82,
      size.height * 0.68,
      size.width * 0.92,
      size.height * 0.74,
      size.width * 1.02,
      size.height * 0.60,
    );

    canvas.drawPath(route, paint);
  }

  @override
  bool shouldRepaint(covariant _LoginPatternPainter oldDelegate) {
    return false;
  }
}