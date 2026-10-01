import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E5),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFFF7F1E5),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9EF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFD7C09A),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2DFC1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 32,
                    color: Color(0xFFA6532A),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'You’re all caught up',
                  style: TextStyle(
                    fontFamily: 'Cormorant Garamond',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF30251F),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'New discoveries, travel ideas and YATRA updates will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF75685D),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'YATRA UPDATES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFFA6532A),
            ),
          ),

          const SizedBox(height: 10),

          _notificationCard(
            icon: Icons.auto_awesome_rounded,
            title: 'YATRA AI',
            message: 'AI-powered place stories are ready to explore.',
          ),

          _notificationCard(
            icon: Icons.explore_rounded,
            title: 'Explore India',
            message: 'Discover heritage places across five destinations.',
          ),
        ],
      ),
    );
  }

  Widget _notificationCard({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1D0B4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFFF2DFC1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFFA6532A),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF30251F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFF75685D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}