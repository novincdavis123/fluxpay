import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_event.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_state.dart';

class SecuritySetupPage extends StatefulWidget {
  const SecuritySetupPage({super.key});

  @override
  State<SecuritySetupPage> createState() => _SecuritySetupPageState();
}

class _SecuritySetupPageState extends State<SecuritySetupPage> {
  final _pinController = TextEditingController();

  bool _enableBiometric = true;

  bool _enablePin = true;

  bool _isSaving = false;

  @override
  void dispose() {
    _pinController.dispose();

    super.dispose();
  }

  Future<void> _continue() async {
    /// =====================================================
    /// VALIDATE PIN
    /// =====================================================

    if (_enablePin && _pinController.text.trim().length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN must be exactly 4 digits')),
      );

      return;
    }

    setState(() {
      _isSaving = true;
    });

    final authBloc = context.read<AuthBloc>();

    try {
      /// =====================================================
      /// SHOW BIOMETRIC POPUP
      /// WITHOUT CHANGING AUTH STATE
      /// =====================================================

      if (_enableBiometric) {
        final success = await authBloc.repository.authenticateWithBiometric();

        if (!success) {
          if (mounted) {
            setState(() {
              _isSaving = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Biometric authentication failed')),
            );
          }

          return;
        }

        authBloc.add(const EnableBiometricRequested(biometricEnabled: true));
      } else {
        authBloc.add(const DisableBiometricRequested());
      }

      /// =====================================================
      /// SAVE PIN
      /// =====================================================

      if (_enablePin) {
        authBloc.add(
          SavePinRequested(
            pin: _pinController.text.trim(),
            biometricEnabled: _enableBiometric,
          ),
        );
      } else {
        authBloc.add(const EnablePinRequested(enabled: false));

        authBloc.add(const MarkAuthenticatedRequested());
      }

      /// =====================================================
      /// WAIT FOR AUTH SUCCESS
      /// =====================================================

      await authBloc.stream.firstWhere(
        (state) =>
            state.status == AuthStatus.authenticated ||
            state.status == AuthStatus.failure,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade400,
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure) {
          setState(() {
            _isSaving = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade400,
              content: Text(state.errorMessage ?? 'Something went wrong'),
            ),
          );
        }
      },

      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.getBackground(context),

        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),

                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),

                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const SizedBox(height: 24),

                        /// =====================================================
                        /// LOGO
                        /// =====================================================
                        Center(
                          child: Container(
                            width: 92,
                            height: 92,
                            padding: const EdgeInsets.all(14),

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
                                  color: AppColors.primary.withOpacity(0.16),
                                  blurRadius: 30,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),

                              child: Image.asset(
                                'assets/icons/fxicon.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// =====================================================
                        /// TITLE
                        /// =====================================================
                        Text(
                          'Secure Your Account',
                          style: AppTextStyles.displayMedium.copyWith(
                            letterSpacing: -1,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Protect your FluxPay account using biometrics or a secure PIN.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// =====================================================
                        /// BIOMETRIC TILE
                        /// =====================================================
                        _SecurityTile(
                          icon: Icons.fingerprint_rounded,
                          title: 'Enable Biometrics',
                          subtitle: 'Unlock using Face ID or Fingerprint',
                          value: _enableBiometric,

                          onChanged: (value) {
                            setState(() {
                              _enableBiometric = value;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        /// =====================================================
                        /// PIN TILE
                        /// =====================================================
                        _SecurityTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Enable PIN',
                          subtitle: 'Use a secure 4-digit PIN',
                          value: _enablePin,

                          onChanged: (value) {
                            setState(() {
                              _enablePin = value;
                            });
                          },
                        ),

                        const SizedBox(height: 24),

                        /// =====================================================
                        /// PIN FIELD
                        /// =====================================================
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),

                          child: _enablePin
                              ? Column(
                                  key: const ValueKey('pin-field'),

                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      'Create PIN',
                                      style: AppTextStyles.bodyMedium,
                                    ),

                                    const SizedBox(height: 12),

                                    TextField(
                                      controller: _pinController,

                                      obscureText: true,

                                      keyboardType: TextInputType.number,

                                      maxLength: 4,

                                      style: const TextStyle(
                                        letterSpacing: 10,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),

                                      decoration: InputDecoration(
                                        hintText: '••••',

                                        counterText: '',

                                        hintStyle: const TextStyle(
                                          letterSpacing: 10,
                                        ),

                                        filled: true,

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),

                                          borderSide: BorderSide.none,
                                        ),

                                        prefixIcon: const Icon(
                                          Icons.pin_outlined,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),

                        const Spacer(),

                        /// =====================================================
                        /// CONTINUE BUTTON
                        /// =====================================================
                        SizedBox(
                          width: double.infinity,
                          height: 58,

                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _continue,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,

                              foregroundColor: Colors.white,

                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            child: _isSaving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,

                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Continue',

                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// =====================================================
                        /// FOOTER
                        /// =====================================================
                        Center(
                          child: Text(
                            'Your security settings can be changed later.',

                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SecurityTile extends StatelessWidget {
  final IconData icon;

  final String title;

  final String subtitle;

  final bool value;

  final ValueChanged<bool> onChanged;

  const _SecurityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.04),

        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),

              color: AppColors.primary.withOpacity(0.12),
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: AppTextStyles.headingSmall),

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
