import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/core/services/exchange_calculator_service.dart';
import 'package:fluxpay/core/services/live_rate_simulation_service.dart';

import 'package:fluxpay/features/exchange/domain/entities/exchange_rate_entity.dart';
import 'package:fluxpay/features/exchange/domain/repositories/exchange_repository.dart';

import 'exchange_event.dart';
import 'exchange_state.dart';

class ExchangeBloc extends Bloc<ExchangeEvent, ExchangeState> {
  final ExchangeRepository repository;

  final ExchangeCalculatorService calculatorService;

  final LiveRateSimulationService liveRateSimulationService;

  Timer? _refreshTimer;

  StreamSubscription<Decimal>? _liveRateSubscription;

  ExchangeBloc({
    required this.repository,
    required this.calculatorService,
    required this.liveRateSimulationService,
  }) : super(ExchangeState.initial()) {
    on<FetchExchangeRate>(_onFetchExchangeRate);

    on<AmountChanged>(_onAmountChanged);

    on<RecipientAmountChanged>(_onRecipientAmountChanged);

    on<SwapCurrencies>(_onSwapCurrencies);

    on<CurrencyChanged>(_onCurrencyChanged);

    on<RefreshExchangeRates>(_onRefreshExchangeRates);

    on<MarkRatesAsStale>(_onMarkRatesAsStale);

    on<LiveRateUpdated>(_onLiveRateUpdated);

    _startAutoRefresh();

    _liveRateSubscription = liveRateSimulationService.stream.listen((
      updatedRate,
    ) {
      add(LiveRateUpdated(updatedRate));
    });
  }

  Future<void> _onFetchExchangeRate(
    FetchExchangeRate event,
    Emitter<ExchangeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final ExchangeRateEntity rateEntity = await repository.getExchangeRate(
        from: event.fromCurrency,
        to: event.toCurrency,
      );

      final calculation = calculatorService.calculate(
        amount: state.senderAmount,
        rate: rateEntity.rate,
        isWeekend: _isWeekend(),
        sameCurrency: event.fromCurrency == event.toCurrency,
      );

      liveRateSimulationService.start(baseRate: calculation.exchangeRate);

      emit(
        state.copyWith(
          isLoading: false,
          isStale: false,
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
          exchangeRate: calculation.exchangeRate,
          recipientAmount: calculation.recipientGets,
          fee: calculation.fee,
          totalPayable: calculation.totalPayable,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isStale: true,
          errorMessage: 'Unable to refresh live rates',
        ),
      );
    }
  }

  void _onAmountChanged(AmountChanged event, Emitter<ExchangeState> emit) {
    final amount = Decimal.tryParse(event.amount) ?? Decimal.zero;

    final calculation = calculatorService.calculate(
      amount: amount,
      rate: state.exchangeRate,
      isWeekend: _isWeekend(),
      sameCurrency: state.fromCurrency == state.toCurrency,
    );

    emit(
      state.copyWith(
        senderAmount: amount,
        recipientAmount: calculation.recipientGets,
        fee: calculation.fee,
        totalPayable: calculation.totalPayable,
      ),
    );
  }

  void _onRecipientAmountChanged(
    RecipientAmountChanged event,
    Emitter<ExchangeState> emit,
  ) {
    final recipientAmount = Decimal.tryParse(event.amount) ?? Decimal.zero;

    if (state.exchangeRate == Decimal.zero) {
      return;
    }

    final senderAmount = (recipientAmount / state.exchangeRate).toDecimal();

    final calculation = calculatorService.calculate(
      amount: senderAmount,
      rate: state.exchangeRate,
      isWeekend: _isWeekend(),
      sameCurrency: state.fromCurrency == state.toCurrency,
    );

    emit(
      state.copyWith(
        senderAmount: senderAmount,
        recipientAmount: calculation.recipientGets,
        fee: calculation.fee,
        totalPayable: calculation.totalPayable,
      ),
    );
  }

  Future<void> _onSwapCurrencies(
    SwapCurrencies event,
    Emitter<ExchangeState> emit,
  ) async {
    final from = state.toCurrency;

    final to = state.fromCurrency;

    add(FetchExchangeRate(fromCurrency: from, toCurrency: to));
  }

  Future<void> _onCurrencyChanged(
    CurrencyChanged event,
    Emitter<ExchangeState> emit,
  ) async {
    add(
      FetchExchangeRate(
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
      ),
    );
  }

  Future<void> _onRefreshExchangeRates(
    RefreshExchangeRates event,
    Emitter<ExchangeState> emit,
  ) async {
    add(
      FetchExchangeRate(
        fromCurrency: state.fromCurrency,
        toCurrency: state.toCurrency,
      ),
    );
  }

  void _onMarkRatesAsStale(
    MarkRatesAsStale event,
    Emitter<ExchangeState> emit,
  ) {
    emit(state.copyWith(isStale: true));
  }

  void _onLiveRateUpdated(LiveRateUpdated event, Emitter<ExchangeState> emit) {
    final calculation = calculatorService.calculate(
      amount: state.senderAmount,
      rate: event.updatedRate,
      isWeekend: _isWeekend(),
      sameCurrency: state.fromCurrency == state.toCurrency,
    );

    emit(
      state.copyWith(
        exchangeRate: calculation.exchangeRate,
        recipientAmount: calculation.recipientGets,
        fee: calculation.fee,
        totalPayable: calculation.totalPayable,
      ),
    );
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      add(const MarkRatesAsStale());

      await Future.delayed(const Duration(seconds: 1));

      add(const RefreshExchangeRates());
    });
  }

  bool _isWeekend() {
    final now = DateTime.now();

    return now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();

    _liveRateSubscription?.cancel();

    liveRateSimulationService.dispose();

    return super.close();
  }
}
