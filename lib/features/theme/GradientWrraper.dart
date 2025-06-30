import 'package:flutter/material.dart';

class GradientWrapper extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;

  const GradientWrapper({
    super.key,
    required this.child,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: isDarkMode
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0E21),
                  Color(0xFF1D2671), 
                  Color(0xFF5C469C),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: isDarkMode
                  ? [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ]
                  : null,
            )
          : const BoxDecoration(
              color: const Color(0xFFF4F0EB),
            ),
      child: child,
    );
  }
}
