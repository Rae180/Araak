import 'package:flutter/material.dart';
import 'package:start/core/managers/string_manager.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/Auth/View/Screens/SignUpPage.dart';
import 'package:start/features/Auth/View/Screens/Araak_Splash_Screen.dart';
import 'package:start/features/Auth/View/Screens/WelcomeScreen.dart';
import 'package:start/features/home/view/Screens/homepage.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case WelcomeScreen.routeName:
        return MaterialPageRoute(builder: (context) => WelcomeScreen());
      case SignUpPage.routeName:
        return MaterialPageRoute(builder: (context) => SignUpPage());
      case LoginPage.routeName:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case HomePage.routeName:
        return MaterialPageRoute(builder: (context) => HomePage());
      case AraakSplashScreen.routeName:
        return MaterialPageRoute(builder: (context) => AraakSplashScreen());
      default:
        return unDefinedRoute();
    }
  }

  Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.noRouteFound),
        ),
        body: const Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
