import 'package:ankidroid/HomeScreen.dart';
import 'package:flutter/material.dart';

import '../Profile.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue.shade300,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(child: _buildMenuItems(context)),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      {'icon': Icons.home_rounded, 'title': 'Home'},
      {'icon': Icons.person_rounded, 'title': 'Profile'},
      {'icon': Icons.notifications_rounded, 'title': 'Notifications'},
      {'icon': Icons.settings_rounded, 'title': 'Settings'},
      {'icon': Icons.help_outline_rounded, 'title': 'Help & Support'},
    ];

    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return TweenAnimationBuilder(
          tween: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ),
          duration: Duration(milliseconds: 300 + (index * 100)),
          builder: (context, Offset offset, child) {
            return Transform.translate(
              offset: Offset(offset.dx * 20, 0),
              child: child,
            );
          },
          child: ListTile(
            leading: Icon(item['icon'] as IconData, color: Colors.white),
            title: Text(
              item['title'] as String,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              if (index == 0) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return HomeScreen();
                }));
              }
              else if(index == 1) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return Profile();
                }));
              }
            },
          ),
        );
      },
    );
  }
}
