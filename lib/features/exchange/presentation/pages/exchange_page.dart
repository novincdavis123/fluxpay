import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/core/connectivity/connectivity_cubit.dart';
import 'package:fluxpay/core/connectivity/connectivity_state.dart';
import 'package:fluxpay/core/constants/currency_data.dart';
import 'package:fluxpay/core/utils/app_snackbar.dart';
import 'package:fluxpay/core/utils/money_formatter.dart';
import 'package:fluxpay/core/widgets/offline_empty_state.dart';

import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc.dart';
import 'package:fluxpay/features/exchange/presentation/bloc/exchange_event.dart';
import 'package:fluxpay/features/exchange/presentation/bloc/exchange_state.dart';

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

  final bool _isUpdatingControllers = false;

  Decimal _previousRate = Decimal.zero;

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

  /// =====================================================
  /// SAFE CONTROLLER UPDATE
  /// =====================================================

  void _updateControllers(ExchangeState state) {
    if (_isUpdatingControllers) return;

    final senderText = state.senderAmount == Decimal.zero
        ? ''
        : state.senderAmount.toStringAsFixed(2);

    final receiverText = state.recipientAmount == Decimal.zero
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
  }

  /// =====================================================
  /// SAFE DECIMAL PARSER
  /// =====================================================

  Decimal _parseDecimal(String value) {
    if (value.trim().isEmpty) {
      return Decimal.zero;
    }

    return Decimal.tryParse(value.trim()) ?? Decimal.zero;
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

              final previousRate = _previousRate == Decimal.zero
                  ? state.exchangeRate
                  : _previousRate;

              final rateDifference = state.exchangeRate - previousRate;

              final isPositive = rateDifference >= Decimal.zero;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _previousRate = state.exchangeRate;
              });

              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,

                appBar: AppBar(
                  elevation: 0,
                  centerTitle: false,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  title: Text(
                    'Exchange',

                    style: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ),

                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// MAIN CARD
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),

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

                                selectedCurrency: state.fromCurrency,

                                controller: _sendController,

                                readOnly: false,

                                onCurrencyChanged: (currency) {
                                  context.read<ExchangeBloc>().add(
                                    ChangeFromCurrency(currency),
                                  );
                                },

                                onChanged: (value) {
                                  if (_isUpdatingControllers) {
                                    return;
                                  }

                                  context.read<ExchangeBloc>().add(
                                    UpdateSenderAmount(_parseDecimal(value)),
                                  );
                                },
                              ),

                              const SizedBox(height: AppSpacing.lg),

                              /// SWAP
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

                                selectedCurrency: state.toCurrency,

                                controller: _receiveController,

                                readOnly: false,

                                onCurrencyChanged: (currency) {
                                  context.read<ExchangeBloc>().add(
                                    ChangeToCurrency(currency),
                                  );
                                },

                                onChanged: (value) {
                                  if (_isUpdatingControllers) {
                                    return;
                                  }

                                  context.read<ExchangeBloc>().add(
                                    UpdateReceiverAmount(_parseDecimal(value)),
                                  );
                                },
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
                                          '1 ${state.fromCurrency} = ${formatCurrency(amount: state.exchangeRate, currencyCode: state.toCurrency)}',
                                    ),

                                    const SizedBox(height: AppSpacing.sm),

                                    /// LIVE FLUCTUATION
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,

                                      children: [
                                        Icon(
                                          isPositive
                                              ? Icons.trending_up_rounded
                                              : Icons.trending_down_rounded,

                                          size: 18,

                                          color: isPositive
                                              ? Colors.green
                                              : Colors.red,
                                        ),

                                        const SizedBox(width: 4),

                                        Text(
                                          '${isPositive ? '+' : ''}${rateDifference.toStringAsFixed(4)}',

                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: isPositive
                                                    ? Colors.green
                                                    : Colors.red,

                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: AppSpacing.md),

                                    _RateRow(
                                      label: 'Fee',

                                      value: formatCurrency(
                                        amount: state.fee,
                                        currencyCode: state.fromCurrency,
                                      ),
                                    ),

                                    const SizedBox(height: AppSpacing.md),

                                    _RateRow(
                                      label: 'Total Payable',

                                      value: formatCurrency(
                                        amount: state.totalPayable,
                                        currencyCode: state.fromCurrency,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// STALE STATUS
                              if (state.isStale)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),

                                  child: Text(
                                    'Refreshing rates...',

                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),

                              /// LOADING
                              if (state.isLoading)
                                const Padding(
                                  padding: EdgeInsets.only(top: 20),

                                  child: CircularProgressIndicator(),
                                ),

                              /// UPDATED
                              if (state.lastUpdated != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 4,
                                  ),

                                  child: Text(
                                    'Updated just now',

                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.getTextSecondary(
                                        context,
                                      ),
                                    ),
                                  ),
                                ),

                              // const SizedBox(height: AppSpacing.xl),
                              SizedBox(
                                width: double.infinity,
                                height: 58,
                                child: ElevatedButton(
                                  onPressed: state.hasValidCalculation
                                      ? () {
                                          /// Navigate to beneficiary / review
                                        }
                                      : null,

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),

                                  child: Text(
                                    'Continue Transfer',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
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

  final String selectedCurrency;

  final TextEditingController controller;

  final bool readOnly;

  final Function(String)? onChanged;

  final Function(String)? onCurrencyChanged;

  const _CurrencyInputCard({
    required this.title,
    required this.selectedCurrency,
    required this.controller,
    required this.readOnly,
    this.onChanged,
    this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currency = currencies.firstWhere(
      (currency) => currency.code == selectedCurrency,
    );

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

              const SizedBox(width: 12),

              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCurrency,

                  dropdownColor: AppColors.getCardColor(context),

                  borderRadius: BorderRadius.circular(16),

                  onChanged: (value) {
                    if (value != null && onCurrencyChanged != null) {
                      onCurrencyChanged!(value);
                    }
                  },

                  items: currencies.map((currency) {
                    return DropdownMenuItem(
                      value: currency.code,

                      child: Row(
                        children: [
                          Text(
                            currency.flag,
                            style: const TextStyle(fontSize: 22),
                          ),

                          const SizedBox(width: 8),

                          Text(currency.code, style: AppTextStyles.bodyLarge),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,

            child: Text(
              currency.name,

              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.getTextSecondary(context),
              ),
            ),
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
