// Home Screen (Navigation)
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:start/features/Cart/view/Screens/CartScreen.dart';
import 'package:start/features/Customizations/view/Screens/CustomizationsPage.dart';
import 'package:start/features/Favoritse/view/Screens/FavPage.dart';
import 'package:start/features/home/view/Screens/homepage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
            gradient: isDarkMode
                ? LinearGradient(
                    colors: [
                      Color(0xFF1A1A2E), // Deep navy
                      Color(0xFF16213E), // Darker blue
                      Color(0xFF0F3460), // Midnight blue
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      Color(0xFFF8F9FA), // Light gray
                      Color(0xFFE9ECEF), // Soft gray
                      Color.fromARGB(255, 80, 167, 109), // Medium gray
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: SalomonBottomBar(
            currentIndex: selectedIndex,
            onTap: _onItemTapped,
            itemPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            items: [
              SalomonBottomBarItem(
                icon: Icon(Icons.home_outlined),
                title: Text(l10n.home),
                selectedColor: isDarkMode ? Colors.white : Colors.black,
                unselectedColor: isDarkMode ? Colors.white70 : Colors.black54,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.favorite_border),
                title: Text(l10n.fav),
                selectedColor: isDarkMode ? Colors.white : Colors.black,
                unselectedColor: isDarkMode ? Colors.white70 : Colors.black54,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                title: Text(l10n.cart),
                selectedColor: isDarkMode ? Colors.white : Colors.black,
                unselectedColor: isDarkMode ? Colors.white70 : Colors.black54,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.edit_note_outlined),
                title: Text(l10n.custom),
                selectedColor: isDarkMode ? Colors.white : Colors.black,
                unselectedColor: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
