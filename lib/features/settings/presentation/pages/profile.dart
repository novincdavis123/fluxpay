import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_event.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_state.dart';

import 'package:fluxpay/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          child: Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),

              color: AppColors.getBackground(context).withOpacity(0.95),

              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: 72,
                  height: 72,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.12),
                  ),

                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 34,
                  ),
                ),

                const SizedBox(height: 24),

                Text('Logout?', style: AppTextStyles.headingMedium),

                const SizedBox(height: 12),

                Text(
                  'Are you sure you want to logout from your FluxPay account?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,

                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },

                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.08),
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: Text(
                            'Cancel',

                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: SizedBox(
                        height: 52,

                        child: ElevatedButton(
                          onPressed: () {
                            /// CLOSE DIALOG
                            Navigator.pop(dialogContext);

                            /// DISPATCH LOGOUT
                            context.read<AuthBloc>().add(
                              const LogoutRequested(),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final isLoading =
                                  state.status == AuthStatus.loading;

                              if (isLoading) {
                                return const SizedBox(
                                  width: 22,
                                  height: 22,

                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                );
                              }

                              return Text(
                                'Logout',

                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,

      listener: (context, state) {
        /// =====================================================
        /// LOGOUT SUCCESS
        /// =====================================================

        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }

        /// =====================================================
        /// ERROR
        /// =====================================================

        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade400,

              content: Text(state.errorMessage ?? 'Something went wrong'),
            ),
          );
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.getBackground(context),

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

          title: Text('Profile', style: AppTextStyles.headingMedium),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                /// PROFILE HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),

                    color: Colors.white.withOpacity(0.05),

                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),

                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.6),
                            ],
                          ),
                        ),

                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text('Novin Davis', style: AppTextStyles.displaySmall),

                      const SizedBox(height: 8),

                      Text(
                        'novin@fluxpay.app',

                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white60,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),

                          color: AppColors.primary.withOpacity(0.14),
                        ),

                        child: Text(
                          'Premium User',

                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                const _SectionTitle(title: 'Account'),

                const SizedBox(height: 16),

                _ProfileTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Personal Information',
                  subtitle: 'Manage your profile details',
                  onTap: () {},
                ),

                _ProfileTile(
                  icon: Icons.security_rounded,
                  title: 'Security Settings',
                  subtitle: 'PIN, biometrics and app lock',
                  onTap: () {},
                ),

                _ProfileTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Manage alerts and updates',
                  onTap: () {},
                ),

                const SizedBox(height: 28),

                const _SectionTitle(title: 'Support'),

                const SizedBox(height: 16),

                _ProfileTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help Center',
                  subtitle: 'FAQs and customer support',
                  onTap: () {},
                ),

                _ProfileTile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Privacy',
                  subtitle: 'Read our policies',
                  onTap: () {},
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton.icon(
                    onPressed: () => _logout(context),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.12),

                      foregroundColor: Colors.redAccent,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    icon: const Icon(Icons.logout_rounded),

                    label: Text(
                      'Logout',

                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.redAccent,
                      ),
                    ),
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

/// =====================================================
/// SECTION TITLE
/// =====================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,

      child: Text(
        title,

        style: AppTextStyles.headingSmall.copyWith(color: Colors.white70),
      ),
    );
  }
}

/// =====================================================
/// PROFILE TILE
/// =====================================================

class _ProfileTile extends StatelessWidget {
  final IconData icon;

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,

          child: Ink(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),

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
                      Text(
                        title,

                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

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

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white38,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
