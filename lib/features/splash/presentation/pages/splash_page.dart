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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                /// =====================================================
                /// LOGO
                /// =====================================================
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),

                  child: Image.asset(
                    'assets/icons/fxicon.png',
                    fit: BoxFit.cover,
                    width: 132,
                    height: 132,
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
                    color: AppColors.getTextPrimary(context),
                  ),
                ),

                const SizedBox(height: 10),

                /// =====================================================
                /// SUBTITLE
                /// =====================================================
                Text(
                  'Global Remittance Platform',

                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.getTextSecondary(context),
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
    );
  }
}
