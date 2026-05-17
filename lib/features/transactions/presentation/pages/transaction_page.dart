import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';
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

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    context.read<TransactionBloc>().add(const LoadTransactions());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<TransactionBloc>().add(const LoadMoreTransactions());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundblack,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: Text('Transactions', style: AppTextStyles.headingSmall),
      ),

      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              const SizedBox(height: 12),

              /// SEARCH BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: TextField(
                  onChanged: (value) {
                    context.read<TransactionBloc>().add(
                      SearchTransactions(value),
                    );
                  },

                  decoration: InputDecoration(
                    hintText: 'Search transactions',

                    hintStyle: AppTextStyles.bodySmall,

                    prefixIcon: const Icon(Icons.search),

                    filled: true,

                    fillColor: Colors.white.withOpacity(0.05),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// FILTER CHIPS
              SizedBox(
                height: 44,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  children: [
                    _FilterChipWidget(
                      label: 'All',

                      selected: state.filter == TransactionFilter.all,

                      onTap: () {
                        context.read<TransactionBloc>().add(
                          const FilterTransactions(TransactionFilter.all),
                        );
                      },
                    ),

                    _FilterChipWidget(
                      label: 'Completed',

                      selected: state.filter == TransactionFilter.completed,

                      onTap: () {
                        context.read<TransactionBloc>().add(
                          const FilterTransactions(TransactionFilter.completed),
                        );
                      },
                    ),

                    _FilterChipWidget(
                      label: 'Pending',

                      selected: state.filter == TransactionFilter.pending,

                      onTap: () {
                        context.read<TransactionBloc>().add(
                          const FilterTransactions(TransactionFilter.pending),
                        );
                      },
                    ),

                    _FilterChipWidget(
                      label: 'Failed',

                      selected: state.filter == TransactionFilter.failed,

                      onTap: () {
                        context.read<TransactionBloc>().add(
                          const FilterTransactions(TransactionFilter.failed),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// EMPTY STATE
              if (state.filteredTransactions.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'No transactions found',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                )
              else
                /// TIMELINE
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,

                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    itemCount: state.filteredTransactions.length,

                    itemBuilder: (context, index) {
                      final transaction = state.filteredTransactions[index];

                      final currentDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(transaction.createdAt);

                      final showHeader =
                          index == 0 ||
                          currentDate !=
                              DateFormat('yyyy-MM-dd').format(
                                state.filteredTransactions[index - 1].createdAt,
                              );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          if (showHeader)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 12,
                                top: 12,
                              ),

                              child: Text(
                                _formatTimelineDate(transaction.createdAt),

                                style: AppTextStyles.headingSmall,
                              ),
                            ),

                          TransactionTile(transaction: transaction),
                        ],
                      );
                    },
                  ),
                ),
            ],
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
      padding: const EdgeInsets.only(right: 12),

      child: GestureDetector(
        onTap: onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),

          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),

            color: selected
                ? AppColors.primary
                : Colors.white.withOpacity(0.05),
          ),

          child: Center(child: Text(label, style: AppTextStyles.bodySmall)),
        ),
      ),
    );
  }
}
