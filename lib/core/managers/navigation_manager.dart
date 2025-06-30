// lib/core/managers/navigation_manager.dart
import 'package:flutter/material.dart';

class NavigationManager {
  static void navigateTo(String routeName, {BuildContext? context, int? arguments}) {
    if (context != null) {
      Navigator.of(context).pushNamed(routeName);
    } else {
      // Fallback using navigator key if needed
      navigatorKey.currentState?.pushNamed(routeName);
    }
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}