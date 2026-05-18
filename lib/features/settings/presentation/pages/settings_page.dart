import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> currencies = ['USD', 'EUR', 'GBP', 'INR', 'AED', 'SGD'];

  @override
  void initState() {
    super.initState();

    context.read<SettingsBloc>().add(const LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final settings = state.settings;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          appBar: AppBar(
            backgroundColor: Colors.transparent,

            elevation: 0,

            centerTitle: false,

            title: Text(
              'Settings',

              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),

          body: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// APPEARANCE
                      Text(
                        'Appearance',

                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      _SettingsTile(
                        title: 'Dark Mode',

                        subtitle: 'Enable premium dark theme',

                        trailing: Switch(
                          activeColor: AppColors.primary,

                          value: settings.isDarkMode,

                          onChanged: (_) {
                            context.read<SettingsBloc>().add(
                              const ToggleTheme(),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      /// NOTIFICATIONS
                      Text(
                        'Notifications',

                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      _SettingsTile(
                        title: 'Push Notifications',

                        subtitle: 'Transaction & transfer updates',

                        trailing: Switch(
                          activeColor: AppColors.primary,

                          value: settings.notificationsEnabled,

                          onChanged: (_) {
                            context.read<SettingsBloc>().add(
                              const ToggleNotifications(),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      /// SECURITY
                      Text(
                        'Security',

                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      _SettingsTile(
                        title: 'Biometric Login',

                        subtitle: 'Use Face ID / Fingerprint',

                        trailing: Switch(
                          activeColor: AppColors.primary,

                          value: settings.biometricsEnabled,

                          onChanged: (_) {
                            context.read<SettingsBloc>().add(
                              const ToggleBiometrics(),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      /// PREFERENCES
                      Text(
                        'Preferences',

                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 4,
                        ),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),

                          color: AppColors.getCardColor(context),

                          border: Border.all(
                            color: AppColors.getBorderColor(context),
                          ),
                        ),

                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: settings.defaultCurrency,

                            dropdownColor: AppColors.getCardColor(context),

                            isExpanded: true,

                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,

                              color: AppColors.getTextSecondary(context),
                            ),

                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.getTextPrimary(context),
                            ),

                            items: currencies.map((e) {
                              return DropdownMenuItem(
                                value: e,

                                child: Text(
                                  e,

                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                ),
                              );
                            }).toList(),

                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              context.read<SettingsBloc>().add(
                                ChangeCurrency(value),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;

  final String subtitle;

  final Widget trailing;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        color: AppColors.getCardColor(context),

        border: Border.all(color: AppColors.getBorderColor(context)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              AppColors.isDark(context) ? 0.18 : 0.04,
            ),

            blurRadius: 18,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.getTextPrimary(context),

                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,

                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),

          trailing,
        ],
      ),
    );
  }
}
