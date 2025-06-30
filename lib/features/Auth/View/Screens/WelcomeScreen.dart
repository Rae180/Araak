import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<Widget> pages = [
    // Page 1: Warm Welcome
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Material(
          elevation: 16,
          borderRadius: BorderRadius.circular(30),
          color: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/welcome.gif', height: 280),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to Ara'ak",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your journey to exquisite living begins here.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    // Page 2: Discover Premium Furniture
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Material(
          elevation: 16,
          borderRadius: BorderRadius.circular(30),
          color: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/findout.gif', height: 280),
                const SizedBox(height: 20),
                const Text(
                  "Discover Premium Furniture",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Find pieces that make a statement.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    // Page 3: Swift & Secure Delivery
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Material(
          elevation: 16,
          borderRadius: BorderRadius.circular(30),
          color: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/delivery.gif', height: 280),
                const SizedBox(height: 20),
                const Text(
                  "Swift & Secure Delivery",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your dream furniture, delivered with care.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    // Page 4: Final Impression
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Material(
          elevation: 16,
          borderRadius: BorderRadius.circular(30),
          color: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/dec.jpg', height: 280, fit: BoxFit.cover),
                const SizedBox(height: 20),
                const Text(
                  "Experience Elegance",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Step into a world of timeless design.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // slides in from bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Global background gradient using your specified Color(0xFFF4F0EB)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF4F0EB), // your base color
              Color(0xFFFAF7F2)  // a subtle, slightly lighter variant
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // "Skip" button at top right.
              Positioned(
                top: 16,
                right: 16,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginPage.routeName);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              // Main PageView for onboarding pages.
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: pages,
              ),
              // Custom bottom navigation bar with slide animation.
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button: Available only if not on first page.
                        IconButton(
                          onPressed: _currentPage > 0
                              ? () => _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                              : null,
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color:
                                _currentPage > 0 ? Colors.black : Colors.grey,
                            size: 24,
                          ),
                        ),
                        // Smooth page indicator with expanding dots.
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: pages.length,
                          effect: ExpandingDotsEffect(
                            expansionFactor: 2,
                            activeDotColor: Colors.black,
                            dotColor: Colors.black.withOpacity(0.3),
                            dotHeight: 8,
                            dotWidth: 8,
                          ),
                        ),
                        // Next/Finish button.
                        IconButton(
                          onPressed: () {
                            if (_currentPage == pages.length - 1) {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginPage.routeName);
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          icon: Icon(
                            _currentPage == pages.length - 1
                                ? Icons.check_circle
                                : Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
