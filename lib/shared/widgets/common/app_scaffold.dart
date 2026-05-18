import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';

import 'package:fluxpay/core/connectivity/connectivity_cubit.dart';
import 'package:fluxpay/core/connectivity/connectivity_state.dart';

import 'package:fluxpay/core/widgets/connectivity_banner.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  final PreferredSizeWidget? appBar;

  final Widget? floatingActionButton;

  final Widget? bottomNavigationBar;

  final Color? backgroundColor;

  final bool resizeToAvoidBottomInset;

  final EdgeInsetsGeometry? padding;

  final bool showConnectivityBanner;

  final bool showOfflineBadge;

  const AppScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.padding,
    this.showConnectivityBanner = true,
    this.showOfflineBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.getBackground(context);

    return Scaffold(
      backgroundColor: bgColor,

      appBar: appBar,

      floatingActionButton: floatingActionButton,

      bottomNavigationBar: bottomNavigationBar,

      resizeToAvoidBottomInset: resizeToAvoidBottomInset,

      body: Column(
        children: [
          /// CONNECTIVITY BANNER
          if (showConnectivityBanner) const ConnectivityBanner(),

          /// MAIN CONTENT
          Expanded(
            child: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: padding ?? EdgeInsets.zero,
                    child: child,
                  ),
                ),

                /// OFFLINE BADGE
                if (showOfflineBadge)
                  BlocBuilder<ConnectivityCubit, ConnectivityState>(
                    builder: (context, state) {
                      final isOffline =
                          state.status == ConnectivityStatus.disconnected;

                      if (!isOffline) {
                        return const SizedBox.shrink();
                      }

                      return IgnorePointer(
                        child: SafeArea(
                          child: Align(
                            alignment: Alignment.bottomCenter,

                            child: Container(
                              margin: const EdgeInsets.only(bottom: 24),

                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),

                                color: AppColors.error.withOpacity(0.12),

                                border: Border.all(
                                  color: AppColors.error.withOpacity(0.25),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),

                              child: Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  const Icon(
                                    Icons.wifi_off_rounded,
                                    color: AppColors.error,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    'Offline Mode',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.error,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
