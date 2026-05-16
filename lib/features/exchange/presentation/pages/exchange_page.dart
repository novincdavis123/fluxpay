import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/core/constants/currency_data.dart';

import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_bloc.dart';
import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_event.dart';
import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_state.dart';

import 'package:fluxpay/features/exchange/presentation/widgets/currency_selector_bottom_sheet.dart';
import 'package:fluxpay/features/exchange/presentation/widgets/live_rate_indicator.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _swapAnimationController;

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeBloc, ExchangeState>(
      builder: (context, state) {
        final fromCurrency = currencies.firstWhere(
          (currency) => currency.code == state.fromCurrency,
        );

        final toCurrency = currencies.firstWhere(
          (currency) => currency.code == state.toCurrency,
        );

        return Scaffold(
          backgroundColor: const Color(0xFF0D1117),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),

                  Text('Global Exchange', style: AppTextStyles.headingLarge),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    'Fast and transparent international transfers',
                    style: AppTextStyles.bodyMedium,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: const Color(0xFF161B22),
                    ),
                    child: Column(
                      children: [
                        /// SEND
                        _AmountCard(
                          title: 'You Send',
                          currencyFlag: fromCurrency.flag,
                          currencyCode: fromCurrency.code,
                          amount: state.senderAmount.toString(),
                          onCurrencyTap: () {
                            _showCurrencySelector(
                              context,
                              isFromCurrency: true,
                              currentState: state,
                            );
                          },
                          onAmountChanged: (value) {
                            context.read<ExchangeBloc>().add(
                              AmountChanged(value),
                            );
                          },
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        /// SWAP BUTTON
                        GestureDetector(
                          onTap: () async {
                            await _swapAnimationController.forward();

                            await _swapAnimationController.reverse();

                            if (!context.mounted) {
                              return;
                            }

                            context.read<ExchangeBloc>().add(
                              const SwapCurrencies(),
                            );
                          },
                          child: RotationTransition(
                            turns: Tween<double>(begin: 0, end: 0.5).animate(
                              CurvedAnimation(
                                parent: _swapAnimationController,
                                curve: Curves.easeInOut,
                              ),
                            ),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.08),
                              ),
                              child: const Icon(
                                Icons.swap_vert,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        /// RECEIVE
                        _AmountCard(
                          title: 'Recipient Gets',
                          currencyFlag: toCurrency.flag,
                          currencyCode: toCurrency.code,
                          amount: state.recipientAmount.toString(),
                          onCurrencyTap: () {
                            _showCurrencySelector(
                              context,
                              isFromCurrency: false,
                              currentState: state,
                            );
                          },
                          onAmountChanged: (value) {
                            context.read<ExchangeBloc>().add(
                              RecipientAmountChanged(value),
                            );
                          },
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        /// RATE CARD
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: Column(
                            children: [
                              _InfoRow(
                                title: 'Exchange Rate',
                                value:
                                    '1 ${state.fromCurrency} = ${state.exchangeRate} ${state.toCurrency}',
                              ),

                              const SizedBox(height: AppSpacing.md),

                              _InfoRow(
                                title: 'Transfer Fee',
                                value: state.fee.toString(),
                              ),

                              const SizedBox(height: AppSpacing.md),

                              _InfoRow(
                                title: 'Total Payable',
                                value: state.totalPayable.toString(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        /// LIVE STATUS
                        LiveRateIndicator(
                          isStale: state.isStale,
                          lastUpdated: state.lastUpdated,
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        if (state.lastUpdated != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Updated: ${state.lastUpdated}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ),

                        if (state.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.md),
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
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
  }

  void _showCurrencySelector(
    BuildContext context, {
    required bool isFromCurrency,
    required ExchangeState currentState,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CurrencySelectorBottomSheet(
          onCurrencySelected: (currency) {
            context.read<ExchangeBloc>().add(
              CurrencyChanged(
                fromCurrency: isFromCurrency
                    ? currency.code
                    : currentState.fromCurrency,
                toCurrency: isFromCurrency
                    ? currentState.toCurrency
                    : currency.code,
              ),
            );
          },
        );
      },
    );
  }
}

class _AmountCard extends StatelessWidget {
  final String title;

  final String currencyFlag;

  final String currencyCode;

  final String amount;

  final VoidCallback onCurrencyTap;

  final ValueChanged<String> onAmountChanged;

  const _AmountCard({
    required this.title,
    required this.currencyFlag,
    required this.currencyCode,
    required this.amount,
    required this.onCurrencyTap,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodyMedium),

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              GestureDetector(
                onTap: onCurrencyTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(0.08),
                  ),
                  child: Row(
                    children: [
                      Text(currencyFlag, style: const TextStyle(fontSize: 20)),

                      const SizedBox(width: 8),

                      Text(currencyCode),

                      const SizedBox(width: 4),

                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: onAmountChanged,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  controller: TextEditingController(text: amount),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;

  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
