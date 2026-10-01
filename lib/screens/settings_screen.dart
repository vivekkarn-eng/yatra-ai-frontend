import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool animations = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E5),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFF7F1E5),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _sectionTitle('PREFERENCES'),

          _settingTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Receive YATRA updates',
            trailing: Switch(
              value: notifications,
              onChanged: (value) {
                setState(() {
                  notifications = value;
                });
              },
            ),
          ),

          _settingTile(
            icon: Icons.animation_rounded,
            title: 'Animations',
            subtitle: 'Use subtle YATRA transitions',
            trailing: Switch(
              value: animations,
              onChanged: (value) {
                setState(() {
                  animations = value;
                });
              },
            ),
          ),

          const SizedBox(height: 22),

          _sectionTitle('ABOUT YATRA'),

          _settingTile(
            icon: Icons.auto_awesome_rounded,
            title: 'YATRA AI',
            subtitle: 'See a place. Know its story.',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF806F62),
            ),
          ),

          _settingTile(
            icon: Icons.info_outline_rounded,
            title: 'About',
            subtitle: 'AI-powered heritage exploration',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF806F62),
            ),
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              'YATRA AI • Heritage Explorer',
              style: TextStyle(
                fontSize: 11,
                color: Colors.brown.shade400,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: Color(0xFFA6532A),
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1D0B4),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFFF2DFC1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFFA6532A),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF30251F),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF75685D),
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}