import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/Auth/Bloc/LoginBloc/login_bloc.dart';
import 'package:start/features/Auth/View/Screens/SignUpPage.dart';
import 'package:start/features/home/view/Screens/Home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(client: NetworkApiServiceHttp()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F0EB),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                //Text(AppLocalizations.of(context)!.welcome);
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/login_dec.png',
                      height: 270,
                    ),
                  ),

                  Text(
                    AppLocalizations.of(context)!.login,
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.email,
                      labelStyle: TextStyle(color: Color(0xFFC9C7C5)),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      String emailPattern =
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
                      RegExp regex = RegExp(emailPattern);
                      if (!regex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.password,
                      labelStyle: const TextStyle(color: Color(0xFFC9C7C5)),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.forgetpassword,
                        style: TextStyle(fontFamily: 'Times New Roman'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 70),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginError) {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext ctx) {
                              return Container(
                                padding: const EdgeInsets.all(17.0),
                                child: Text(state.message),
                              );
                            });
                      } else if (state is LoginSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.loginsucc,
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context)
                              .pushReplacementNamed(home.routeName);
                        });
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF181614),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                              LoginUserEvent(
                                  email: _emailController.text,
                                  password: _passwordController.text));
                        },
                        child: state is LoginingLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                AppLocalizations.of(context)!.login,
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 14,
                                  color: Color.lerp(
                                      Color(0xFFF4F0EB), Colors.white, 0.2),
                                ),
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  // const Spacer(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFF181614),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(SignUpPage.routeName);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.newuser,
                      style: TextStyle(fontFamily: 'Times New Roman'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
