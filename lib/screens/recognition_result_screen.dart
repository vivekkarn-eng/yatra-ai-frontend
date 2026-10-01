import 'package:flutter/material.dart';

class RecognitionResultScreen extends StatelessWidget {
  const RecognitionResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E8D2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3E8D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF39291F),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recognition Result',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w800,
            color: Color(0xFF30251F),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9EF),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFFD7C09A),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.account_balance_rounded,
                  size: 90,
                  color: Color(0xFFA6532A),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Is this the place?',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 27,
                fontWeight: FontWeight.w800,
                color: Color(0xFF30251F),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'YATRA AI thinks this place is:',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF75685D),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Rajwada, Indore',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: Color(0xFFA6532A),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE8D6B8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'AI recognition • Prototype',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5D4635),
                ),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.check_circle_outline_rounded,
                ),
                label: const Text(
                  'Yes, show me the story',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA6532A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                label: const Text(
                  'Scan Again',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFA6532A),
                  side: const BorderSide(
                    color: Color(0xFFA6532A),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}