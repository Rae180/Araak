import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start/features/Auth/Bloc/Auth_bloc/auth_bloc.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/home/view/Screens/homepage.dart';

class AraakSplashScreen extends StatefulWidget {
  static const String routeName = '/Araak_Splash_Screen';
  const AraakSplashScreen({super.key});

  @override
  State<AraakSplashScreen> createState() => _AraakSplashScreenState();
}

class _AraakSplashScreenState extends State<AraakSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(CheckAuth()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          } else if (state is UnAuth) {
            Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Image.asset(
                    'assets/logo.jpg',
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
