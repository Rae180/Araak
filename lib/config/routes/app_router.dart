import 'package:flutter/material.dart';
import 'package:start/core/managers/string_manager.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/Auth/View/Screens/SignUpPage.dart';
import 'package:start/features/Auth/View/Screens/Araak_Splash_Screen.dart';
import 'package:start/features/Auth/View/Screens/WelcomeScreen.dart';
import 'package:start/features/Auth/View/Screens/forgetpaassScreen.dart';
import 'package:start/features/Cart/view/Screens/CartScreen.dart';
import 'package:start/features/Cart/view/Screens/MapPickerScreen.dart';
import 'package:start/features/Customizations/view/Screens/CustomizationsPage.dart';
import 'package:start/features/Favoritse/view/Screens/FavPage.dart';
import 'package:start/features/Orders/view/screens/Orders_Screen.dart';
import 'package:start/features/ProductsFolder/view/Screens/ItemDetailesPage.dart';
import 'package:start/features/ProductsFolder/view/Screens/ProductDetails.dart';
import 'package:start/features/Searching/view/Screens/SearchPage.dart';
import 'package:start/features/Settings/view/Screens/ProfilePage.dart';
import 'package:start/features/Settings/view/Screens/SettingsPage.dart';
import 'package:start/features/Settings/view/Screens/UserAccountPage.dart';
import 'package:start/features/Wallet/view/Screens/TopUpScreen.dart';
import 'package:start/features/Wallet/view/Screens/Wallet_Screen.dart';
import 'package:start/features/home/view/Screens/Home.dart';
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
        case SettingScreen.routeName:
        return MaterialPageRoute(builder: (context) => SettingScreen());
        case FavPage.routeName:
        return MaterialPageRoute(builder: (context) => FavPage());
        case CartScreen.routeName:
        return MaterialPageRoute(builder: (context) => CartScreen());
        case CustomizationsPage.routeName:
        return MaterialPageRoute(builder: (context) => CustomizationsPage());
        case home.routeName:
        return MaterialPageRoute(builder: (context) => home());
        case ProductDetailsPage.routeName:
        return MaterialPageRoute(builder: (context) => ProductDetailsPage());
        case SearchPage.routeName:
        return MaterialPageRoute(builder: (context) => SearchPage());
        case ItemDetailesPage.routeName:
        return MaterialPageRoute(builder: (context) => ItemDetailesPage());
        case MapPickerScreen.routeName:
        return MaterialPageRoute(builder: (context) => MapPickerScreen());
        case WalletScreen.routeName:
        return MaterialPageRoute(builder: (context) => WalletScreen());
        case OrdersScreen.routeName:
        return MaterialPageRoute(builder: (context) => OrdersScreen());
        case TopUpScreen.routeName:
        return MaterialPageRoute(builder: (context) => TopUpScreen());
        case ProfilePage.routeName:
        return MaterialPageRoute(builder: (context) => ProfilePage());
        case ModAccount.routeName:
        return MaterialPageRoute(builder: (context) => ModAccount());
        case ForgotPasswordScreen.routeName:
        return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
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
