import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/Auth/Bloc/SignupBloc/sign_up_bloc.dart';
import 'package:start/features/Auth/Models/User.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/home/view/Screens/homepage.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/signup_screen';
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.of(ctx).pop(); // Close the bottom sheet
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.of(ctx).pop(); // Close the bottom sheet
                  await _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _profileImage = File(selectedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(client: NetworkApiServiceHttp()),
      child: Scaffold(
        backgroundColor: Color(0xFFF4F0EB),
        body: Form(
          key: _key,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(17.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                const Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons
                            .weekend, // Change to any furniture icon you prefer.
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 17.0,
                ),
                Text(
                  AppLocalizations.of(context)!.welcome,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                GestureDetector(
                  onTap: () => _showImageSourceActionSheet(context),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 66,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!) as ImageProvider
                            : AssetImage('lib/assets/profile.jpeg')
                                as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(
                            4,
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            Icons.camera_alt,
                            size: 24,
                            color: Colors.grey[800],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 17.0,
                ),
                Card(
                  color: Color.lerp(Color(0xFFF4F0EB), Colors.white, 0.2),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: 'Times New Roman',
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width:
                                      2.0), // Change here to your preferred color
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 17.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: 'Times New Roman',
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width:
                                      2.0), // Change here to your preferred color
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 17.0,
                        ),
                        TextFormField(
                          controller: _phoneNumController,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            labelText: 'phone number',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: 'Times New Roman',
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width:
                                      2.0), // Change here to your preferred color
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 17.0,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          cursorColor: Colors.grey,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: 'Times New Roman',
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width:
                                      2.0), // Change here to your preferred color
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 17.0,
                        ),
                        TextFormField(
                          controller: _confirmController,
                          cursorColor: Colors.grey,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            labelText: 'confirm password',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: 'Times New Roman',
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width:
                                      2.0), // Change here to your preferred color
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        BlocConsumer<SignUpBloc, SignUpState>(
                          listener: (context, state) {
                            if (state is SignupError) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return Container(
                                      padding: EdgeInsets.all(17.0),
                                      child: Text(state.message),
                                    );
                                  });
                            } else if (state is SignupSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Sign up Successfully!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.of(context)
                                    .pushReplacementNamed(HomePage.routeName);
                              });
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                  200,
                                  49,
                                ),
                                backgroundColor: Colors.black,
                                elevation: 4.0,
                              ),
                              onPressed: () {
                                final User user = User(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    C_password: _confirmController.text,
                                    phoneNumber: _phoneNumController.text,
                                    profileImage: _profileImage);
                                BlocProvider.of<SignUpBloc>(context)
                                    .add(SignupUserEvent(user: user));
                              },
                              child: state is SigningUpLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Times New Roman',
                                        color: Color.lerp(Color(0xFFF4F0EB),
                                            Colors.white, 0.2),
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 17.0,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(LoginPage.routeName);
                        },
                        child: Text(
                          "Log in",
                          style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 14.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
