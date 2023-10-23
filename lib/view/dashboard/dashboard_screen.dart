import 'package:flutter/material.dart';
import '../../resources/resources.dart';
import '../view.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final ValueNotifier<int> _screenIndex = ValueNotifier(0);

  final List<Widget> _screens = [
    const PortfolioScreen(),
    const BlogListingScreen(),
    const BloggerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _screenIndex,
        builder: (context, value, child) {
          return _screens[value];
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _screenIndex,
        builder: (context, value, child) {
          return BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle_outlined),
                label: StringManager.portfolioScreen,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article_outlined),
                label: StringManager.blogScreen,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.portrait_rounded),
                label: StringManager.profileScreen,
              ),
            ],
            currentIndex: value,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            iconSize: 35,
            elevation: 10,
            onTap: (value) {
              _screenIndex.value = value;
            },
          );
        },
      ),
    );
  }
}