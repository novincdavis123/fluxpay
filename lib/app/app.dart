import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxpay/app/theme/app_theme.dart';
import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_bloc.dart';
import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';
import 'package:fluxpay/features/exchange/presentation/pages/home_page.dart';
import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:fluxpay/injection_container.dart';

class FluxPayApp extends StatelessWidget {
  const FluxPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide all necessary blocs to the widget tree
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ExchangeBloc>()),
        BlocProvider(create: (_) => sl<BeneficiaryBloc>()),
        BlocProvider(
          create: (_) => sl<TransactionBloc>()..add(const LoadTransactions()),
        ),
      ],

      child: MaterialApp(
        title: 'FluxPay',
        debugShowCheckedModeBanner: false,

        theme: AppTheme.lightTheme,

        darkTheme: AppTheme.darkTheme,

        themeMode: ThemeMode.system,

        home: const HomePage(),
      ),
    );
  }
}
