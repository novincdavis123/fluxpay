import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:fluxpay/app/app.dart';

import 'package:fluxpay/core/constants/hive_boxes.dart';

import 'package:fluxpay/features/settings/data/models/settings_model.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

import 'package:fluxpay/features/exchange/data/models/exchange_rate_model.dart';

import 'package:fluxpay/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// LOCK PORTRAIT MODE
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// INITIALIZE HIVE
  await Hive.initFlutter();

  /// REGISTER HIVE ADAPTERS
  Hive.registerAdapter(TransactionModelAdapter());

  Hive.registerAdapter(SettingsModelAdapter());

  Hive.registerAdapter(ExchangeRateModelAdapter());

  /// OPEN HIVE BOXES
  await Hive.openBox(HiveBoxes.beneficiaries);

  await Hive.openBox<TransactionModel>(HiveBoxes.transactions);

  await Hive.openBox<ExchangeRateModel>(HiveBoxes.exchangeRates);

  await Hive.openBox<SettingsModel>(HiveBoxes.settings);

  /// DEPENDENCY INJECTION
  await initDependencies();

  runApp(const FluxPayApp());
}
