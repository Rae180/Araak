import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:start/features/Cart/view/Screens/CartScreen.dart';
import 'package:start/features/Customizations/view/Screens/CustomizationsPage.dart';
import 'package:start/features/Favoritse/view/Screens/FavPage.dart';
import 'package:start/features/Settings/view/Screens/SettingsPage.dart';
import 'package:start/features/home/view/Screens/homepage.dart';

class home extends StatefulWidget {
  static const String routeName = '/home';
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final PageController _pageController = PageController(initialPage: 0);
  int selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomePage(),
    FavPage(),
    CartScreen(),
    CustomizationsPage(),
    SettingsPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: _onPageChanged,
        children: List.generate(_pages.length, (index) => _pages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF4F0EB), // Soft beige
                Color(0xFFEAD7B9), // Warm beige
                Color(0xFFD9B382),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SalomonBottomBar(
            currentIndex: selectedIndex,
            onTap: _onItemTapped,
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_outlined),
                title: const Text("Home"),
                selectedColor: Colors.black,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.favorite_border),
                title: const Text("Fav"),
                selectedColor: Colors.black,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.shopping_cart_outlined),
                title: const Text("Cart"),
                selectedColor: Colors.black,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.edit_note_outlined),
                title: const Text("Custom"),
                selectedColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
