import 'package:flutter/material.dart';
import 'package:obsidian_magnetar/core/data/services/auth_services.dart';


import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../bottom_navigation_bar_view/bottom_navigation_bar_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _authService = AuthServices();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await _authService.signInWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
      } else {
        await _authService.sinUpWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
      }
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigationBarView(),
            ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.danger500,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo Section
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary500.withValues(alpha: 0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  _isLogin ? 'Welcome Back!' : 'Create Account',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray900,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin
                      ? 'Sign in to manage your finances'
                      : 'Start your journey to financial freedom',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gray900.withValues(alpha: 0.05),
                        blurRadius: 32,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: !_isLogin
                              ? Column(
                                  children: [
                                    _buildTextField(
                                      controller: _nameController,
                                      label: AppStrings.displayName,
                                      icon: Icons.person_outline_rounded,
                                      validator: _validateName,
                                      isLast: false,
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        _buildTextField(
                          controller: _emailController,
                          label: AppStrings.email,
                          icon: Icons.email_outlined,
                          inputType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          isLast: false,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          label: AppStrings.password,
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onObscurePressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          validator: _validatePassword,
                          isLast: true,
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor:
                                  AppColors.primary500.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ).copyWith(
                              elevation:
                                  MaterialStateProperty.resolveWith((states) {
                                return states.contains(MaterialState.pressed)
                                    ? 0
                                    : 8;
                              }),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _isLogin ? 'Sign In' : 'Create Account',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin
                          ? "Don't have an account?"
                          : "Already have an account?",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.gray600),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary600,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Text(_isLogin ? 'Sign Up' : 'Sign In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onObscurePressed,
    String? Function(String?)? validator,
    TextInputType inputType = TextInputType.text,
    bool isLast = false,
    Function(String)? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: inputType,
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: AppColors.gray50,
        prefixIcon: Icon(icon, color: AppColors.gray400, size: 22),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.gray400,
                  size: 22,
                ),
                onPressed: onObscurePressed,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger500, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}
