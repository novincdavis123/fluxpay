import 'package:flutter/material.dart';

import 'package:fluxpay/core/constants/currency_data.dart';

class CurrencySelectorBottomSheet extends StatefulWidget {
  final Function(CurrencyData currency) onCurrencySelected;

  const CurrencySelectorBottomSheet({
    super.key,
    required this.onCurrencySelected,
  });

  @override
  State<CurrencySelectorBottomSheet> createState() =>
      _CurrencySelectorBottomSheetState();
}

class _CurrencySelectorBottomSheetState
    extends State<CurrencySelectorBottomSheet> {
  final TextEditingController searchController = TextEditingController();

  List<CurrencyData> filteredCurrencies = currencies;

  void onSearch(String query) {
    setState(() {
      filteredCurrencies = currencies
          .where(
            (currency) =>
                currency.code.toLowerCase().contains(query.toLowerCase()) ||
                currency.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),

                const SizedBox(height: 24),

                TextField(
                  controller: searchController,
                  onChanged: onSearch,
                  decoration: InputDecoration(
                    hintText: 'Search currency',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: filteredCurrencies.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final currency = filteredCurrencies[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          widget.onCurrencySelected(currency);

                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Text(
                                currency.flag,
                                style: const TextStyle(fontSize: 28),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currency.code,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(currency.name),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
