import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/features/Settings/Bloc/bloc/settings_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModAccount extends StatefulWidget {
  static const String routeName = '/Account_page';
  const ModAccount({Key? key}) : super(key: key);

  @override
  _ModAccountState createState() => _ModAccountState();
}

class _ModAccountState extends State<ModAccount> {
  File? _image;
  final picker = ImagePicker();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<ModBloc>().add(LoadUserData());
  //   });
  // }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showPasswordChangeDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text(AppLocalizations.of(context)!.changepassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.currentpass),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.newpass),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration:
                   InputDecoration(labelText: AppLocalizations.of(context)!.confirmnewpass),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text ==
                      confirmPasswordController.text &&
                  oldPasswordController.text == passwordController.text) {
                setState(() {
                  passwordController.text = newPasswordController.text;
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                      content: Text(
                          AppLocalizations.of(context)!.failpasschange)),
                );
              }
            },
            child:  Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    VoidCallback? onTap,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: readOnly ? const Icon(Icons.edit) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSuccess) {
          nameController.text = state.user.name!;
          phoneController.text = state.user.phone!;
          passwordController.text = state.user.password!;
        } else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is SettingsLoading || state is SettingsInitial) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (state is SettingsError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }

        if (state is SettingsSuccess || state is ModSaving) {
          final user = (state is SettingsSuccess)
              ? state.user
              : (context.read<SettingsBloc>().state as SettingsSuccess).user;

          return Scaffold(
            appBar: AppBar(
              title:  Text(AppLocalizations.of(context)!.editaccount,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : (user.image != null && user.image!.isNotEmpty
                                      ? NetworkImage(user.image!)
                                      : const AssetImage(
                                          'assets/images/profile.jpeg'))
                                  as ImageProvider,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                      controller: nameController, label: AppLocalizations.of(context)!.name),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: phoneController, label: AppLocalizations.of(context)!.phonenum),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: passwordController,
                    label: AppLocalizations.of(context)!.password,
                    readOnly: true,
                    onTap: _showPasswordChangeDialog,
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<SettingsBloc>().add(UpdateUserData(
                              name: nameController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                              image: _image!,
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state is ModSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          :  Text(AppLocalizations.of(context)!.save,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: Text('Unexpected state')));
      },
    );
  }
}
