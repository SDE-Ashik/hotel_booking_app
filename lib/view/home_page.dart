import 'package:airbnb/view/explore_page.dart';
import 'package:airbnb/view/message_screen.dart';
import 'package:airbnb/view/profile_screen.dart';
import 'package:airbnb/view/wishlist_page.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int selectedIndex = 0;
  late final List<Widget> page;

  final List<Map<String, dynamic>> navItems = [
    {"icon": Icon(Icons.search, size: 30), "label": "Explore"},
    {"icon": Icon(Icons.favorite_border, size: 30), "label": "Wishlist"},
    {"icon": Icon(Icons.flight_takeoff, size: 30), "label": "Trip"},
    {"icon": Icon(Icons.chat_bubble_outline, size: 30), "label": "Messages"},
    {"icon": Icon(Icons.person_outline, size: 30), "label": "Profile"},
  ];

  @override
  void initState() {
    page = [
  const ExploreScrren(),
   const Wishlists(),
      const Scaffold(body: Center(child: Text("Trip Page"))),
    const MessagesScreen(),
    const   ProfilePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: page[selectedIndex],
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: AnimatedBottomNavigationBar.builder(
          
          itemCount: navItems.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? Colors.pinkAccent : Colors.black45;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                navItems[index]["icon"],
                const SizedBox(height: 2),
                Text(
                  navItems[index]["label"],
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isActive)
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            );
          },

          backgroundColor: Colors.white,
          activeIndex: selectedIndex,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          gapLocation: GapLocation.none,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          splashSpeedInMilliseconds: 300,
        ),
      ),
    );
  }
}
