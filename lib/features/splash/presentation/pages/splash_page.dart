import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_event.dart';

import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    /// =====================================================
    /// INITIALIZE APP
    /// =====================================================

    context.read<SplashBloc>().add(const InitializeApp());

    /// =====================================================
    /// CHECK AUTH SESSION
    /// =====================================================

    context.read<AuthBloc>().add(const CheckSessionRequested());

    /// =====================================================
    /// ANIMATION
    /// =====================================================

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        /// =====================================================
        /// FAILURE
        /// =====================================================

        if (state.status == SplashStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to initialize app')),
          );
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.getBackground(context),

        body: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,

              child: ScaleTransition(
                scale: _scaleAnimation,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    /// =====================================================
                    /// LOGO
                    /// =====================================================
                    Container(
                      width: 132,
                      height: 132,

                      padding: const EdgeInsets.all(18),

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

                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
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
                        borderRadius: BorderRadius.circular(40),

                        child: Image.asset(
                          'assets/icons/fxicon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    /// =====================================================
                    /// TITLE
                    /// =====================================================
                    Text(
                      'FluxPay',
                      style: AppTextStyles.displayMedium.copyWith(
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// =====================================================
                    /// SUBTITLE
                    /// =====================================================
                    Text(
                      'Global Remittance Platform',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 48),

                    /// =====================================================
                    /// LOADER
                    /// =====================================================
                    Container(
                      width: 34,
                      height: 34,

                      padding: const EdgeInsets.all(4),

                      child: const CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: AppColors.primary,
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
