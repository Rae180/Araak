import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/Auth/Bloc/SignupBloc/sign_up_bloc.dart';
import 'package:start/features/Auth/Models/User.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/home/view/Screens/Home.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/signup_screen';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneNumController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  late SignUpBloc _signUpBloc;

  @override
  void initState() {
    super.initState();
    _signUpBloc = SignUpBloc(client: NetworkApiServiceHttp());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneNumController.dispose();
    _signUpBloc.close();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() => _profileImage = File(selectedImage.path));
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.gallery),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.camera),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        C_password: _confirmController.text,
        phoneNumber: _phoneNumController.text,
        profileImage: _profileImage,
      );
      _signUpBloc.add(SignupUserEvent(user: user));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocProvider.value(
        value: _signUpBloc,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildHeader(isDarkMode, l10n),
                const SizedBox(height: 32),
                _buildProfileImageSelector(context),
                const SizedBox(height: 32),
                _buildSignUpForm(theme, isDarkMode, l10n),
                const SizedBox(height: 24),
                _buildLoginLink(theme, isDarkMode, l10n),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDarkMode ? Colors.white54 : Colors.grey.shade700,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.weekend,
                color: isDarkMode ? Colors.white70 : Colors.black,
                size: 28,
              ),
            ),
            Expanded(
              child: Divider(
                color: isDarkMode ? Colors.white54 : Colors.grey.shade700,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          l10n.welcome,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImageSelector(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceActionSheet(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 66,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!) as ImageProvider
                : const AssetImage('lib/assets/profile.jpeg'),
            child: _profileImage == null
                ? Icon(
                    Icons.person,
                    size: 60,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt,
              size: 24,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(
      ThemeData theme, bool isDarkMode, AppLocalizations l10n) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildNameField(theme, l10n),
            const SizedBox(height: 20),
            _buildEmailField(theme, l10n),
            const SizedBox(height: 20),
            _buildPhoneField(theme, l10n),
            const SizedBox(height: 20),
            _buildPasswordField(theme, l10n),
            const SizedBox(height: 20),
            _buildConfirmPasswordField(theme, l10n),
            const SizedBox(height: 32),
            _buildSignUpButton(theme, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(ThemeData theme, AppLocalizations l10n) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return 'l10n.nameRequired';
        return null;
      },
      controller: _nameController,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: l10n.name,
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildEmailField(ThemeData theme, AppLocalizations l10n) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return 'l10n.emailRequired';
        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(value)) return 'l10n.invalidEmail';
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: l10n.email,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPhoneField(ThemeData theme, AppLocalizations l10n) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) return 'l10n.phoneRequired';
        if (!RegExp(r'^[0-9]{10,}$').hasMatch(value)) {
          return 'l10n.invalidPhone';
        }
        return null;
      },
      controller: _phoneNumController,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: l10n.phonenum,
        prefixIcon: const Icon(Icons.phone_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPasswordField(ThemeData theme, AppLocalizations l10n) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: l10n.password,
        prefixIcon: const Icon(Icons.lock_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: theme.colorScheme.secondary,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'l10n.passwordRequired';
        if (value.length < 6) return 'l10n.passwordLengthError';
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(ThemeData theme, AppLocalizations l10n) {
    return TextFormField(
      controller: _confirmController,
      obscureText: _obscureConfirmPassword,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: l10n.confirmpass,
        prefixIcon: const Icon(Icons.lock_reset_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
            color: theme.colorScheme.secondary,
          ),
          onPressed: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'l10n.confirmPassRequired';
        if (value != _passwordController.text) return 'l10n.passwordsDontMatch';
        return null;
      },
    );
  }

  Widget _buildSignUpButton(ThemeData theme, AppLocalizations l10n) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        } else if (state is SignupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.signupsuccess),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, home.routeName);
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is SigningUpLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.colorScheme.onPrimary,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: state is SigningUpLoading
              ? const CircularProgressIndicator()
              : Text(
                  l10n.signup,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
        );
      },
    );
  }

  Widget _buildLoginLink(
      ThemeData theme, bool isDarkMode, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.haveanaccount,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, LoginPage.routeName),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            l10n.login,
            style: TextStyle(
              color: isDarkMode ? Colors.blueAccent : theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
