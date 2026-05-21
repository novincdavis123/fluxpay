import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';
import 'package:fluxpay/core/utils/haptics.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_event.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_state.dart';

import 'package:fluxpay/features/auth/presentation/pages/login_page.dart';
import 'package:fluxpay/features/settings/presentation/pages/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),

          child: Container(
            padding: const EdgeInsets.all(28),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: AppColors.getCardColor(context),
              border: Border.all(color: AppColors.getBorderColor(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    AppColors.isDark(context) ? 0.25 : 0.08,
                  ),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: 82,
                  height: 82,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.12),
                  ),

                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 38,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Logout?',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.getTextPrimary(context),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Are you sure you want to logout from your FluxPay account?',
                  textAlign: TextAlign.center,

                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.getTextSecondary(context),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54,

                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },

                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.getBorderColor(context),
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: Text(
                            'Cancel',

                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: SizedBox(
                        height: 54,

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);

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
                                  color: Colors.white,
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
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }

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

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// =====================================================
                /// HEADER
                /// =====================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      'Profile',

                      style: AppTextStyles.displaySmall.copyWith(
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),

                    InkWell(
                      onTap: () async {
                        await AppHaptics.selection();

                        if (!context.mounted) {
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.getCardColor(context),
                          border: Border.all(
                            color: AppColors.getBorderColor(context),
                          ),
                        ),

                        child: Icon(
                          Icons.settings_outlined,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                /// =====================================================
                /// PREMIUM CARD
                /// =====================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),

                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,

                      colors: AppColors.isDark(context)
                          ? [const Color(0xFF1E1F28), const Color(0xFF2A2B36)]
                          : [const Color(0xFFF7F9FC), const Color(0xFFEDEFF5)],
                    ),

                    border: Border.all(
                      color: AppColors.getBorderColor(context),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          AppColors.isDark(context) ? 0.22 : 0.06,
                        ),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 88,
                            height: 88,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.7),
                                ],
                              ),
                            ),

                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 42,
                            ),
                          ),

                          const SizedBox(width: 18),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Novin Davis',

                                  style: AppTextStyles.headingMedium.copyWith(
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'novin@fluxpay.app',

                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.getTextSecondary(context),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: AppColors.primary.withOpacity(0.12),
                                  ),

                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      const Icon(
                                        Icons.workspace_premium_rounded,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),

                                      const SizedBox(width: 6),

                                      Text(
                                        'Premium User',

                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 26),

                      Row(
                        children: [
                          Expanded(
                            child: _ProfileStatCard(
                              icon: Icons.sync_alt_rounded,
                              title: 'Transfers',
                              value: '128',
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: _ProfileStatCard(
                              icon: Icons.public_rounded,
                              title: 'Countries',
                              value: '18',
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: _ProfileStatCard(
                              icon: Icons.account_balance_wallet_rounded,
                              title: 'Volume',
                              value: '\$42K',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 34),

                const _SectionTitle(title: 'Account'),

                const SizedBox(height: 18),

                _ProfileTile(
                  icon: Icons.badge_outlined,
                  title: 'Personal Information',
                  subtitle: 'Manage your profile details',
                  onTap: () {},
                ),

                _ProfileTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Security Settings',
                  subtitle: 'PIN, biometrics and app lock',
                  onTap: () {},
                ),

                _ProfileTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage alerts and updates',
                  onTap: () {},
                ),

                const SizedBox(height: 28),

                const _SectionTitle(title: 'Support'),

                const SizedBox(height: 18),

                _ProfileTile(
                  icon: Icons.support_agent_rounded,
                  title: 'Help Center',
                  subtitle: 'FAQs and customer support',
                  onTap: () {},
                ),

                _ProfileTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Terms & Privacy',
                  subtitle: 'Read our policies',
                  onTap: () {},
                ),

                const SizedBox(height: 42),

                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton.icon(
                    onPressed: () => _logout(context),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.12),
                      foregroundColor: Colors.redAccent,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
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
    return Text(
      title,

      style: AppTextStyles.headingSmall.copyWith(
        color: AppColors.getTextSecondary(context),
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
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,

          child: Ink(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.getCardColor(context),

              border: Border.all(color: AppColors.getBorderColor(context)),
            ),

            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
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
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        subtitle,

                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.getTextSecondary(context),
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

/// =====================================================
/// PROFILE STATS
/// =====================================================

class _ProfileStatCard extends StatelessWidget {
  final IconData icon;

  final String title;

  final String value;

  const _ProfileStatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: AppColors.primary.withOpacity(0.08),
      ),

      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),

          const SizedBox(height: 10),

          Text(
            value,

            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.getTextPrimary(context),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
