import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';
import 'package:fluxpay/core/validators/auth_validators.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  // =====================================================
  /// SUBMIT
  /// =====================================================
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
    debugPrint('LOGIN AUTH BLOC => ${context.read<AuthBloc>().hashCode}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,

      listener: (context, state) {
        debugPrint('''
================ LOGIN PAGE ================
STATUS => ${state.status}
============================================
''');

        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade400,
              content: Text(state.errorMessage ?? 'Login failed'),
            ),
          );
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.getBackground(context),

        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// =====================================================
                    /// LOGO
                    /// =====================================================
                    Center(
                      child: Container(
                        width: 110,
                        height: 110,

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,

                            colors: [
                              AppColors.primary.withOpacity(0.18),
                              AppColors.primary.withOpacity(0.06),
                            ],
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.18),
                              blurRadius: 40,
                              spreadRadius: 2,
                            ),
                          ],
                        ),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),

                          child: Image.asset(
                            'assets/icons/fxicon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 42),

                    /// =====================================================
                    /// TITLE
                    /// =====================================================
                    Text(
                      'Welcome Back',
                      style: AppTextStyles.displayMedium.copyWith(
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Sign in to continue using FluxPay',
                      style: AppTextStyles.bodyMedium,
                    ),

                    const SizedBox(height: 42),

                    /// =====================================================
                    /// EMAIL
                    /// =====================================================
                    Text('Email', style: AppTextStyles.bodyMedium),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _emailController,

                      keyboardType: TextInputType.emailAddress,

                      textInputAction: TextInputAction.next,

                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      decoration: InputDecoration(
                        hintText: 'john@fluxpay.com',

                        filled: true,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),

                        prefixIcon: const Icon(Icons.mail_outline_rounded),
                      ),

                      validator: AuthValidators.validateEmail,
                    ),

                    const SizedBox(height: 24),

                    /// =====================================================
                    /// PASSWORD
                    /// =====================================================
                    Text('Password', style: AppTextStyles.bodyMedium),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _passwordController,

                      obscureText: _obscurePassword,

                      textInputAction: TextInputAction.done,

                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      onFieldSubmitted: (_) => _submit(),

                      decoration: InputDecoration(
                        hintText: 'Enter password',

                        filled: true,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),

                        prefixIcon: const Icon(Icons.lock_outline_rounded),

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },

                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,

                            color: Colors.white54,
                          ),
                        ),
                      ),

                      validator: AuthValidators.validatePassword,
                    ),

                    const SizedBox(height: 36),

                    /// =====================================================
                    /// LOGIN BUTTON
                    /// =====================================================
                    BlocSelector<AuthBloc, AuthState, bool>(
                      selector: (state) => state.status == AuthStatus.loading,

                      builder: (context, isLoading) {
                        return SizedBox(
                          width: double.infinity,
                          height: 58,

                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,

                              foregroundColor: Colors.white,

                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),

                              child: isLoading
                                  ? const SizedBox(
                                      key: ValueKey('loader'),

                                      width: 22,
                                      height: 22,

                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Continue',

                                      key: const ValueKey('text'),

                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    /// =====================================================
                    /// FOOTER
                    /// =====================================================
                    Center(
                      child: Text(
                        'Secure fintech authentication',

                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white38,
                        ),
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
}
