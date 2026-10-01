import 'package:flutter/material.dart';

import 'explore_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class YatraMenuDrawer extends StatelessWidget {
  const YatraMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 310,
      backgroundColor: const Color(0xFFF7F1E5),
      child: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                22,
                28,
                22,
                24,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFE9D9BD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YATRA',
                    style: TextStyle(
                      fontFamily: 'Cormorant Garamond',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF30251F),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'See a place. Know its story.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF75685D),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // HOME
            _MenuItem(
              icon: Icons.home_rounded,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // EXPLORE
            _MenuItem(
              icon: Icons.explore_rounded,
              title: 'Explore',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ExploreScreen(),
                  ),
                );
              },
            ),

            // SAVED
            _MenuItem(
              icon: Icons.bookmark_rounded,
              title: 'Saved Places',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SavedScreen(),
                  ),
                );
              },
            ),

            // PROFILE
            _MenuItem(
              icon: Icons.person_rounded,
              title: 'Profile',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 10,
              ),
              child: Divider(
                color: Color(0xFFD7C09A),
              ),
            ),

            // NOTIFICATIONS
            _MenuItem(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),

            // SETTINGS
            _MenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),

            const Spacer(),

            // MORE CITIES
            Container(
              margin: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                18,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2DFC1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFD7C09A),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.add_location_alt_outlined,
                    color: Color(0xFFA6532A),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'More Cities',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF30251F),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Coming soon',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF75685D),
                          ),
                        ),
                      ],
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
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 2,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Icon(
          icon,
          color: const Color(0xFFA6532A),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF30251F),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF9B8A7A),
        ),
        onTap: onTap,
      ),
    );
  }
}