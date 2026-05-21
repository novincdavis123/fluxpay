import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_event.dart';

import '../bloc/app_lock_bloc.dart';
import '../bloc/app_lock_event.dart';
import '../bloc/app_lock_state.dart';

class LockScreenPage extends StatefulWidget {
  const LockScreenPage({super.key});

  @override
  State<LockScreenPage> createState() => _LockScreenPageState();
}

class _LockScreenPageState extends State<LockScreenPage> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();

    super.dispose();
  }

  void _unlockWithPin() {
    final pin = _pinController.text.trim();

    if (pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade400,
          content: const Text('Please enter your PIN'),
        ),
      );

      return;
    }

    context.read<AppLockBloc>().add(UnlockWithPin(pin));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppLockBloc, AppLockState>(
      listener: (context, state) {
        /// =====================================================
        /// FAILURE
        /// =====================================================

        if (state.status == AppLockStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade400,
              content: Text(state.errorMessage ?? 'Authentication failed'),
            ),
          );
        }

        /// =====================================================
        /// SUCCESS
        /// =====================================================

        if (state.status == AppLockStatus.unlocked) {
          /// =====================================================
          /// UPDATE AUTH STATE
          /// THIS IS WHAT MOVES APP TO HOMEPAGE
          /// =====================================================

          context.read<AuthBloc>().add(const MarkAuthenticatedRequested());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green.shade500,
              content: const Text(
                'Unlocked successfully',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.getBackground(context),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),

            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    /// =====================================================
                    /// FINGERPRINT LOGO
                    /// =====================================================
                    Container(
                      width: 130,
                      height: 130,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,

                          colors: [
                            AppColors.primary.withOpacity(0.20),
                            AppColors.primary.withOpacity(0.05),
                          ],
                        ),

                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.20),
                            blurRadius: 36,
                            spreadRadius: 4,
                          ),
                        ],
                      ),

                      child: const Icon(
                        Icons.fingerprint_rounded,
                        size: 72,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 36),

                    /// =====================================================
                    /// TITLE
                    /// =====================================================
                    Text(
                      'Unlock FluxPay',
                      style: AppTextStyles.displaySmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Authenticate using biometrics or your secure PIN',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 44),

                    /// =====================================================
                    /// BIOMETRIC BUTTON
                    /// =====================================================
                    BlocBuilder<AppLockBloc, AppLockState>(
                      builder: (context, state) {
                        final isLoading = state.status == AppLockStatus.loading;

                        return SizedBox(
                          width: double.infinity,
                          height: 58,

                          child: ElevatedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<AppLockBloc>().add(
                                      UnlockWithBiometric(),
                                    );
                                  },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            icon: const Icon(
                              Icons.fingerprint,
                              color: Colors.white,
                            ),

                            label: Text(
                              'Unlock with Biometrics',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    /// =====================================================
                    /// DIVIDER
                    /// =====================================================
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.white.withOpacity(0.10)),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),

                          child: Text(
                            'OR',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Divider(color: Colors.white.withOpacity(0.10)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    /// =====================================================
                    /// PIN INPUT
                    /// =====================================================
                    TextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 4,

                      style: AppTextStyles.bodyLarge,

                      onSubmitted: (_) => _unlockWithPin(),

                      decoration: InputDecoration(
                        counterText: '',

                        hintText: 'Enter Secure PIN',

                        prefixIcon: const Icon(Icons.lock_outline_rounded),

                        filled: true,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),

                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// =====================================================
                    /// PIN BUTTON
                    /// =====================================================
                    BlocBuilder<AppLockBloc, AppLockState>(
                      builder: (context, state) {
                        final isLoading = state.status == AppLockStatus.loading;

                        return SizedBox(
                          width: double.infinity,
                          height: 56,

                          child: OutlinedButton(
                            onPressed: isLoading ? null : _unlockWithPin,

                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors.primary.withOpacity(0.5),
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            child: isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : Text(
                                    'Unlock with PIN',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    /// =====================================================
                    /// SECURITY LABEL
                    /// =====================================================
                    Text(
                      'Your data is protected with bank-grade encryption',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white38,
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
