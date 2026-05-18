import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/core/connectivity/connectivity_cubit.dart';
import 'package:fluxpay/core/connectivity/connectivity_state.dart';
import 'package:fluxpay/core/constants/currency_data.dart';
import 'package:fluxpay/core/utils/app_snackbar.dart';
import 'package:fluxpay/core/widgets/offline_empty_state.dart';

import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_bloc.dart';
import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_event.dart';
import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_state.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _swapAnimationController;

  final TextEditingController _sendController = TextEditingController();

  final TextEditingController _receiveController = TextEditingController();

  bool _isUpdatingControllers = false;

  @override
  void initState() {
    super.initState();

    _swapAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    context.read<ExchangeBloc>().add(
      const FetchExchangeRate(fromCurrency: 'USD', toCurrency: 'INR'),
    );
  }

  @override
  void dispose() {
    _swapAnimationController.dispose();

    _sendController.dispose();

    _receiveController.dispose();

    super.dispose();
  }

  void _updateControllers(ExchangeState state) {
    if (_isUpdatingControllers) {
      return;
    }

    _isUpdatingControllers = true;

    final senderText = state.senderAmount == 0
        ? ''
        : state.senderAmount.toString();

    final receiverText = state.recipientAmount == 0
        ? ''
        : state.recipientAmount.toStringAsFixed(2);

    if (_sendController.text != senderText) {
      _sendController.value = TextEditingValue(
        text: senderText,
        selection: TextSelection.collapsed(offset: senderText.length),
      );
    }

    if (_receiveController.text != receiverText) {
      _receiveController.value = TextEditingValue(
        text: receiverText,
        selection: TextSelection.collapsed(offset: receiverText.length),
      );
    }

    _isUpdatingControllers = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExchangeBloc, ExchangeState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,

      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          AppSnackbar.showError(context, message: state.errorMessage!);
        }
      },

      child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, connectivityState) {
          final isOffline =
              connectivityState.status == ConnectivityStatus.disconnected;

          if (isOffline) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,

              body: OfflineEmptyState(
                title: 'No Internet Connection',

                subtitle:
                    'Exchange services are currently unavailable while offline.',

                onRetry: () {
                  context.read<ConnectivityCubit>().checkConnection();
                },
              ),
            );
          }

          return BlocBuilder<ExchangeBloc, ExchangeState>(
            builder: (context, state) {
              _updateControllers(state);

              final fromCurrency = currencies.firstWhere(
                (currency) => currency.code == state.fromCurrency,
              );

              final toCurrency = currencies.firstWhere(
                (currency) => currency.code == state.toCurrency,
              );

              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,

                appBar: AppBar(
                  elevation: 0,

                  centerTitle: false,

                  backgroundColor: Colors.transparent,

                  title: Text(
                    'Exchange',

                    style: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ),

                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// HEADER
                        Text(
                          'Global Exchange',

                          style: AppTextStyles.headingLarge.copyWith(
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        Text(
                          'Fast and transparent international transfers',

                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        /// MAIN CARD
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(AppSpacing.xl),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),

                            color: AppColors.getCardColor(context),

                            border: Border.all(
                              color: AppColors.getBorderColor(context),
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  AppColors.isDark(context) ? 0.20 : 0.05,
                                ),

                                blurRadius: 20,

                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),

                          child: Column(
                            children: [
                              /// SEND
                              _CurrencyInputCard(
                                title: 'You Send',

                                currencyFlag: fromCurrency.flag,

                                currencyCode: fromCurrency.code,

                                controller: _sendController,

                                readOnly: false,

                                onChanged: (value) {
                                  context.read<ExchangeBloc>().add(
                                    UpdateSenderAmount(
                                      double.tryParse(value) ?? 0,
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: AppSpacing.lg),

                              /// SWAP BUTTON
                              Center(
                                child: RotationTransition(
                                  turns: Tween<double>(begin: 0, end: 0.5)
                                      .animate(
                                        CurvedAnimation(
                                          parent: _swapAnimationController,

                                          curve: Curves.easeInOut,
                                        ),
                                      ),

                                  child: GestureDetector(
                                    onTap: () {
                                      _swapAnimationController.forward(from: 0);

                                      context.read<ExchangeBloc>().add(
                                        const SwapCurrencies(),
                                      );
                                    },

                                    child: Container(
                                      width: 58,

                                      height: 58,

                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,

                                        color: AppColors.primary,

                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.35),

                                            blurRadius: 18,

                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),

                                      child: const Icon(
                                        Icons.swap_vert_rounded,

                                        color: Colors.white,

                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: AppSpacing.lg),

                              /// RECEIVE
                              _CurrencyInputCard(
                                title: 'Recipient Gets',

                                currencyFlag: toCurrency.flag,

                                currencyCode: toCurrency.code,

                                controller: _receiveController,

                                readOnly: true,
                              ),

                              const SizedBox(height: AppSpacing.xl),

                              /// RATE INFO
                              Container(
                                width: double.infinity,

                                padding: const EdgeInsets.all(AppSpacing.lg),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),

                                  color: AppColors.isDark(context)
                                      ? Colors.white.withOpacity(0.04)
                                      : Colors.grey.shade100,
                                ),

                                child: Column(
                                  children: [
                                    _RateRow(
                                      label: 'Exchange Rate',

                                      value:
                                          '1 ${state.fromCurrency} = ${state.exchangeRate.toStringAsFixed(2)} ${state.toCurrency}',
                                    ),

                                    const SizedBox(height: AppSpacing.md),

                                    _RateRow(
                                      label: 'Fee',

                                      value:
                                          '\$${state.fee.toStringAsFixed(2)}',
                                    ),

                                    const SizedBox(height: AppSpacing.md),

                                    _RateRow(
                                      label: 'Total Payable',

                                      value:
                                          '\$${state.totalPayable.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                              ),

                              /// LOADER
                              if (state.isLoading)
                                const Padding(
                                  padding: EdgeInsets.only(top: 20),

                                  child: CircularProgressIndicator(),
                                ),

                              /// UPDATED
                              if (state.lastUpdated != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 18),

                                  child: Text(
                                    'Updated: ${state.lastUpdated}',

                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.getTextSecondary(
                                        context,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CurrencyInputCard extends StatelessWidget {
  final String title;

  final String currencyFlag;

  final String currencyCode;

  final TextEditingController controller;

  final bool readOnly;

  final Function(String)? onChanged;

  const _CurrencyInputCard({
    required this.title,
    required this.currencyFlag,
    required this.currencyCode,
    required this.controller,
    required this.readOnly,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Text(currencyFlag, style: const TextStyle(fontSize: 32)),

              const SizedBox(width: 14),

              Expanded(
                child: TextField(
                  controller: controller,

                  readOnly: readOnly,

                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.getTextPrimary(context),
                  ),

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: '0.00',

                    hintStyle: AppTextStyles.headingLarge.copyWith(
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),

                  onChanged: onChanged,
                ),
              ),

              Text(
                currencyCode,

                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  final String label;

  final String value;

  const _RateRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,

            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: Text(
            value,

            textAlign: TextAlign.end,

            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.getTextPrimary(context),

              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
