import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_theme.dart';

import 'package:fluxpay/core/connectivity/connectivity_cubit.dart';

import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';

import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_bloc.dart';

import 'package:fluxpay/features/exchange/presentation/pages/home_page.dart';

import 'package:fluxpay/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:fluxpay/features/settings/presentation/bloc/settings_event.dart';
import 'package:fluxpay/features/settings/presentation/bloc/settings_state.dart';

import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';

import 'package:fluxpay/injection_container.dart';

class FluxPayApp extends StatelessWidget {
  const FluxPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// ======================================================
        /// EXCHANGE
        /// ======================================================
        BlocProvider(create: (_) => sl<ExchangeBloc>()),

        /// ======================================================
        /// BENEFICIARIES
        /// ======================================================
        BlocProvider(create: (_) => sl<BeneficiaryBloc>()),

        /// ======================================================
        /// TRANSACTIONS
        /// ======================================================
        BlocProvider(
          create: (_) => sl<TransactionBloc>()..add(const LoadTransactions()),
        ),

        /// ======================================================
        /// CONNECTIVITY
        /// ======================================================
        BlocProvider(create: (_) => sl<ConnectivityCubit>()),

        /// ======================================================
        /// SETTINGS
        /// ======================================================
        BlocProvider(
          create: (_) => sl<SettingsBloc>()..add(const LoadSettings()),
        ),
      ],

      /// ======================================================
      /// REACTIVE THEME
      /// ======================================================
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'FluxPay',

            debugShowCheckedModeBanner: false,

            theme: AppTheme.lightTheme,

            darkTheme: AppTheme.darkTheme,

            themeMode: state.themeMode,

            home: const HomePage(),
          );
        },
      ),
    );
  }
}
