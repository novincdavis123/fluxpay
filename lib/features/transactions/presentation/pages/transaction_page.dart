import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxpay/features/transactions/presentation/widgets/amount_field.dart';
import 'package:intl/intl.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/core/connectivity/connectivity_cubit.dart';
import 'package:fluxpay/core/connectivity/connectivity_state.dart';
import 'package:fluxpay/core/utils/app_snackbar.dart';
import 'package:fluxpay/core/widgets/offline_empty_state.dart';

import 'package:fluxpay/features/transactions/domain/entities/transaction_filter.dart';

import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';

import 'package:fluxpay/features/transactions/presentation/widgets/transaction_tile.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _minAmountController = TextEditingController();

  final TextEditingController _maxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    context.read<TransactionBloc>().add(const LoadTransactions());
  }

  @override
  void dispose() {
    _scrollController.dispose();

    _searchController.dispose();

    _minAmountController.dispose();

    _maxAmountController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final threshold = _scrollController.position.maxScrollExtent - 300;

    if (_scrollController.position.pixels >= threshold) {
      context.read<TransactionBloc>().add(const LoadMoreTransactions());
    }
  }

  bool get _hasAmountFilter {
    return _minAmountController.text.isNotEmpty ||
        _maxAmountController.text.isNotEmpty;
  }

  void _showAdvancedFilterBottomSheet(TransactionState state) {
    final currencies = [
      {'code': 'USD', 'symbol': '\$'},
      {'code': 'EUR', 'symbol': '€'},
      {'code': 'GBP', 'symbol': '£'},
      {'code': 'INR', 'symbol': '₹'},
      {'code': 'AED', 'symbol': 'د.إ'},
    ];

    String? selectedCurrency = state.selectedCurrency;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              decoration: BoxDecoration(
                color: AppColors.getCardColor(context),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(34),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.getBorderColor(context),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    'Advanced Filters',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: currencies.map((currencyData) {
                      final code = currencyData['code']!;
                      final symbol = currencyData['symbol']!;

                      final selected = selectedCurrency == code;

                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedCurrency = selected ? null : code;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selected
                                ? AppColors.primary
                                : AppColors.getInputFill(context),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.getBorderColor(context),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                symbol,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(width: 8),

                              Text(
                                code,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.getTextPrimary(context),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Row(
                    children: [
                      Expanded(
                        child: AmountField(
                          controller: _minAmountController,
                          hint: 'Min Amount',
                          onChanged: (_) {},
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: AmountField(
                          controller: _maxAmountController,
                          hint: 'Max Amount',
                          onChanged: (_) {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            /// CLEAR TEXTFIELDS
                            _searchController.clear();
                            _minAmountController.clear();
                            _maxAmountController.clear();

                            /// CLEAR ALL FILTERS
                            context.read<TransactionBloc>().add(
                              const SearchTransactions(''),
                            );

                            context.read<TransactionBloc>().add(
                              const ClearTransactionFilters(),
                            );

                            /// FORCE UI REFRESH
                            setState(() {});

                            Navigator.pop(context);
                          },
                          child: const Text('Clear'),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final minAmount = double.tryParse(
                              _minAmountController.text,
                            );

                            final maxAmount = double.tryParse(
                              _maxAmountController.text,
                            );

                            context.read<TransactionBloc>().add(
                              CurrencyFilterChanged(selectedCurrency),
                            );

                            context.read<TransactionBloc>().add(
                              AmountRangeFilterChanged(
                                minAmount: minAmount,
                                maxAmount: maxAmount,
                              ),
                            );

                            Navigator.pop(context);

                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
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

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: AppColors.getBackground(context),
              centerTitle: false,
              title: Text(
                'Transactions',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      final currentState = context
                          .read<TransactionBloc>()
                          .state;

                      _showAdvancedFilterBottomSheet(currentState);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _hasAmountFilter
                            ? AppColors.primary
                            : AppColors.getCardColor(context),
                        border: Border.all(
                          color: _hasAmountFilter
                              ? AppColors.primary
                              : AppColors.getBorderColor(context),
                        ),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        size: 22,
                        color: _hasAmountFilter
                            ? Colors.white
                            : AppColors.getTextPrimary(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: isOffline
                ? OfflineEmptyState(
                    title: 'Offline Mode',
                    subtitle: 'Cached transactions are still available.',
                    onRetry: () {
                      context.read<ConnectivityCubit>().checkConnection();
                    },
                  )
                : BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                      if (state.isLoading &&
                          state.filteredTransactions.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.getInputFill(context),
                                border: Border.all(
                                  color: AppColors.getBorderColor(context),
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.getTextPrimary(context),
                                ),
                                onChanged: (value) {
                                  context.read<TransactionBloc>().add(
                                    SearchTransactions(value),
                                  );

                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search transactions',
                                  hintStyle: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.getTextMuted(context),
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: AppColors.getTextSecondary(context),
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            _searchController.clear();

                                            context.read<TransactionBloc>().add(
                                              const SearchTransactions(''),
                                            );

                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.close_rounded,
                                            color: AppColors.getTextSecondary(
                                              context,
                                            ),
                                          ),
                                        )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          SizedBox(
                            height: 46,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              children: [
                                _FilterChipWidget(
                                  label: 'All',
                                  selected:
                                      state.filter == TransactionFilter.all,
                                  onTap: () {
                                    context.read<TransactionBloc>().add(
                                      const FilterTransactions(
                                        TransactionFilter.all,
                                      ),
                                    );
                                  },
                                ),

                                _FilterChipWidget(
                                  label: 'Completed',
                                  selected:
                                      state.filter ==
                                      TransactionFilter.completed,
                                  onTap: () {
                                    context.read<TransactionBloc>().add(
                                      const FilterTransactions(
                                        TransactionFilter.completed,
                                      ),
                                    );
                                  },
                                ),

                                _FilterChipWidget(
                                  label: 'Pending',
                                  selected:
                                      state.filter == TransactionFilter.pending,
                                  onTap: () {
                                    context.read<TransactionBloc>().add(
                                      const FilterTransactions(
                                        TransactionFilter.pending,
                                      ),
                                    );
                                  },
                                ),

                                _FilterChipWidget(
                                  label: 'Processing',
                                  selected:
                                      state.filter ==
                                      TransactionFilter.processing,
                                  onTap: () {
                                    context.read<TransactionBloc>().add(
                                      const FilterTransactions(
                                        TransactionFilter.processing,
                                      ),
                                    );
                                  },
                                ),

                                _FilterChipWidget(
                                  label: 'Failed',
                                  selected:
                                      state.filter == TransactionFilter.failed,
                                  onTap: () {
                                    context.read<TransactionBloc>().add(
                                      const FilterTransactions(
                                        TransactionFilter.failed,
                                      ),
                                    );
                                  },
                                ),

                                _FilterChipWidget(
                                  label: 'Refunded',
                                  selected:
                                      state.filter ==
                                      TransactionFilter.refunded,
                                  onTap: () {
                                    context.read<TransactionBloc>().add(
                                      const FilterTransactions(
                                        TransactionFilter.refunded,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          if (state.filteredTransactions.isEmpty)
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.receipt_long_rounded,
                                      size: 72,
                                      color: AppColors.getTextMuted(
                                        context,
                                      ).withOpacity(0.3),
                                    ),

                                    const SizedBox(height: AppSpacing.lg),

                                    Text(
                                      'No transactions found',
                                      style: AppTextStyles.headingSmall
                                          .copyWith(
                                            color: AppColors.getTextPrimary(
                                              context,
                                            ),
                                          ),
                                    ),

                                    const SizedBox(height: AppSpacing.sm),

                                    Text(
                                      'Try changing filters or search',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.getTextSecondary(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: RefreshIndicator(
                                color: AppColors.primary,
                                backgroundColor: AppColors.getCardColor(
                                  context,
                                ),
                                onRefresh: () async {
                                  context.read<TransactionBloc>().add(
                                    const LoadTransactions(),
                                  );
                                },
                                child: ListView.builder(
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                    left: AppSpacing.lg,
                                    right: AppSpacing.lg,
                                    bottom: AppSpacing.xl,
                                  ),
                                  itemCount:
                                      state.filteredTransactions.length +
                                      (state.isPaginating ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index >=
                                        state.filteredTransactions.length) {
                                      return const Padding(
                                        padding: EdgeInsets.all(AppSpacing.lg),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }

                                    final transaction =
                                        state.filteredTransactions[index];

                                    final currentDate = DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(transaction.createdAt);

                                    final showHeader =
                                        index == 0 ||
                                        currentDate !=
                                            DateFormat('yyyy-MM-dd').format(
                                              state
                                                  .filteredTransactions[index -
                                                      1]
                                                  .createdAt,
                                            );

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (showHeader)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 18,
                                              bottom: 12,
                                            ),
                                            child: Text(
                                              _formatTimelineDate(
                                                transaction.createdAt,
                                              ),
                                              style: AppTextStyles.headingSmall
                                                  .copyWith(
                                                    color:
                                                        AppColors.getTextPrimary(
                                                          context,
                                                        ),
                                                  ),
                                            ),
                                          ),

                                        TransactionTile(
                                          transaction: transaction,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  String _formatTimelineDate(DateTime date) {
    final now = DateTime.now();

    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Yesterday';
    }

    return DateFormat('dd MMM yyyy').format(date);
  }
}

class _FilterChipWidget extends StatelessWidget {
  final String label;

  final bool selected;

  final VoidCallback onTap;

  const _FilterChipWidget({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: selected
                ? AppColors.primary
                : AppColors.getCardColor(context),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.getBorderColor(context),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style:
                  (selected
                          ? AppTextStyles.bodyMedium
                          : AppTextStyles.bodySmall)
                      .copyWith(
                        color: selected
                            ? Colors.white
                            : AppColors.getTextSecondary(context),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
