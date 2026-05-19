import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:fluxpay/app/app.dart';

import 'package:fluxpay/core/constants/hive_boxes.dart';
import 'package:fluxpay/core/lifecycle/app_lifecycle_handler.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:fluxpay/features/exchange/data/models/exchange_rate_model.dart';

import 'package:fluxpay/features/settings/data/models/settings_model.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

import 'package:fluxpay/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ======================================================
  /// PORTRAIT ONLY
  /// ======================================================

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// ======================================================
  /// STATUS BAR
  /// ======================================================

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  /// ======================================================
  /// INITIALIZE HIVE
  /// ======================================================

  await Hive.initFlutter();

  /// ======================================================
  /// REGISTER ADAPTERS
  /// ======================================================

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(SettingsModelAdapter());
  }

  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(ExchangeRateModelAdapter());
  }

  /// ======================================================
  /// OPEN BOXES
  /// ======================================================

  await Future.wait([
    Hive.openBox(HiveBoxes.beneficiaries),

    Hive.openBox<TransactionModel>(HiveBoxes.transactions),

    Hive.openBox<ExchangeRateModel>(HiveBoxes.exchangeRates),

    Hive.openBox<SettingsModel>(HiveBoxes.settings),
  ]);

  /// ======================================================
  /// DEPENDENCY INJECTION
  /// ======================================================

  await initDependencies();

  /// ======================================================
  /// APP LIFECYCLE LOCKING
  /// ======================================================

  final authBloc = sl<AuthBloc>();

  WidgetsBinding.instance.addObserver(AppLifecycleHandler(authBloc: authBloc));

  /// ======================================================
  /// RUN APP
  /// ======================================================

  runApp(const FluxPayApp());
}
