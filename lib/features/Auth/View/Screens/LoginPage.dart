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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(client: NetworkApiServiceHttp());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginBloc.close();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _loginBloc.add(LoginUserEvent(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: _loginBloc,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.vertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Image.asset(
                        'assets/login_dec.png',
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      l10n.login,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildEmailField(theme, isDarkMode, l10n),
                          const SizedBox(height: 20),
                          _buildPasswordField(theme, isDarkMode, l10n),
                          const SizedBox(height: 8),
                          _buildForgotPasswordButton(isDarkMode, l10n),
                          const SizedBox(height: 40),
                          _buildLoginButton(theme, isDarkMode, l10n),
                          const SizedBox(height: 16),
                          _buildSignUpButton(theme, isDarkMode, l10n),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(
      ThemeData theme, bool isDarkMode, AppLocalizations l10n) {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: l10n.email,
        filled: true,
        fillColor: isDarkMode
            ? Colors.deepPurple.shade800.withOpacity(0.3)
            : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) return 'email required';
        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(value)) return 'invalid email';
        return null;
      },
    );
  }

  Widget _buildPasswordField(
      ThemeData theme, bool isDarkMode, AppLocalizations l10n) {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: l10n.password,
        filled: true,
        fillColor: isDarkMode
            ? Colors.deepPurple.shade800.withOpacity(0.3)
            : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: theme.colorScheme.secondary,
          ),
          onPressed: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submitForm(),
      validator: (value) {
        if (value == null || value.isEmpty) return 'password required';
        if (value.length < 6) return 'invalid password';
        return null;
      },
    );
  }

  Widget _buildForgotPasswordButton(bool isDarkMode, AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
        child: Text(
          l10n.forgetpassword,
          style: TextStyle(
            color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
      ThemeData theme, bool isDarkMode, AppLocalizations l10n) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        } else if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, home.routeName);
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is LoginingLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.colorScheme.onPrimary,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: state is LoginingLoading
              ? const CircularProgressIndicator()
              : Text(
                  l10n.login,
                  style: const TextStyle(fontSize: 16),
                ),
        );
      },
    );
  }

  Widget _buildSignUpButton(
      ThemeData theme, bool isDarkMode, AppLocalizations l10n) {
    return OutlinedButton(
      onPressed: () =>
          Navigator.pushReplacementNamed(context, SignUpPage.routeName),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: theme.colorScheme.primary,
          width: 1.5,
        ),
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        l10n.newuser,
        style: TextStyle(
          color: isDarkMode ? Colors.blueAccent : theme.colorScheme.primary ,
          fontSize: 16,
        ),
      ),
    );
  }
}
