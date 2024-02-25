import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter/bottomNavigation/ProfilePage.dart';

import 'bottomNavigation/NotificationsPage.dart';
import 'bottomNavigation/TaskViewPage.dart';
import 'home.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
class NavigationViewPage extends StatefulWidget {
  const NavigationViewPage({super.key});

  @override
  State<NavigationViewPage> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationViewPage> {
  int currentPageIndex = 0;

  final List<Widget> _pages = [
    const TaskViewPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar
        (
        backgroundColor: CupertinoColors.activeBlue,
        activeColor: Colors.white,
        curveSize: 70,
        top: -20,
        curve: Curves.easeInOut,
        style: TabStyle.reactCircle,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const [
          TabItem(icon: Icons.attach_money_outlined, title: 'Cost'),
          TabItem(icon: Icons.notifications_on_outlined, title: 'Notifications'),
          TabItem(icon: Icons.supervised_user_circle_outlined, title: 'Profile'),
        ],
      ),
      body: _pages[currentPageIndex],
    );
  }

}
