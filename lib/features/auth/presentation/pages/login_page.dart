import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

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

  void _submit() {
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint('''
LOGIN PAGE =>
status: ${state.status}
session: ${state.session != null}
''');

        /// =====================================================
        /// FAILURE
        /// =====================================================

        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade400,
              content: Text(state.errorMessage ?? 'Login failed'),
            ),
          );
        }
      },

      builder: (context, state) {
        final isLoading =
            state.status == AuthStatus.loading && state.session == null;

        return Scaffold(
          backgroundColor: AppColors.getBackground(context),

          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),

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
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
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

                        style: const TextStyle(color: Colors.white),

                        decoration: InputDecoration(
                          hintText: 'john@fluxpay.com',

                          hintStyle: const TextStyle(color: Colors.white38),

                          filled: true,

                          fillColor: Colors.white.withOpacity(0.04),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),

                          prefixIcon: const Icon(
                            Icons.mail_outline_rounded,
                            color: Colors.white54,
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }

                          return null;
                        },
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

                        style: const TextStyle(color: Colors.white),

                        decoration: InputDecoration(
                          hintText: 'Enter password',

                          hintStyle: const TextStyle(color: Colors.white38),

                          filled: true,

                          fillColor: Colors.white.withOpacity(0.04),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),

                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.white54,
                          ),

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

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }

                          if (value.length < 6) {
                            return 'Minimum 6 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 36),

                      /// =====================================================
                      /// LOGIN BUTTON
                      /// =====================================================
                      BlocSelector<AuthBloc, AuthState, bool>(
                        selector: (state) =>
                            state.status == AuthStatus.loading &&
                            state.session == null,

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
        );
      },
    );
  }
}
