import 'dart:async';

import 'package:decimal/decimal.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/core/errors/failures.dart';

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

  bool _isFetching = false;

  ExchangeBloc({
    required this.repository,
    required this.calculatorService,
    required this.liveRateSimulationService,
  }) : super(ExchangeState.initial()) {
    /// ======================================================
    /// EVENT HANDLERS
    /// ======================================================

    on<FetchExchangeRate>(_onFetchExchangeRate);

    on<AmountChanged>(_onAmountChanged);

    on<RecipientAmountChanged>(_onRecipientAmountChanged);

    on<UpdateSenderAmount>(_onUpdateSenderAmount);

    on<UpdateReceiverAmount>(_onUpdateReceiverAmount);

    on<SwapCurrencies>(_onSwapCurrencies);

    on<CurrencyChanged>(_onCurrencyChanged);

    on<ChangeFromCurrency>(_onChangeFromCurrency);

    on<ChangeToCurrency>(_onChangeToCurrency);

    on<RefreshExchangeRates>(_onRefreshExchangeRates);

    on<RefreshExchangeRate>(_onRefreshExchangeRate);

    on<MarkRatesAsStale>(_onMarkRatesAsStale);

    on<LiveRateUpdated>(_onLiveRateUpdated);

    on<ClearExchangeError>(_onClearExchangeError);

    /// ======================================================
    /// START SERVICES
    /// ======================================================

    _startAutoRefresh();

    _listenToLiveRates();
  }

  /// ======================================================
  /// LIVE RATE STREAM
  /// ======================================================

  void _listenToLiveRates() {
    _liveRateSubscription = liveRateSimulationService.stream.listen(
      (updatedRate) {
        if (!isClosed) {
          add(LiveRateUpdated(updatedRate));
        }
      },
      onError: (error) {
        if (kDebugMode) {
          debugPrint('❌ Live Rate Stream Error: $error');
        }
      },
    );
  }

  /// ======================================================
  /// FETCH EXCHANGE RATE
  /// ======================================================

  Future<void> _onFetchExchangeRate(
    FetchExchangeRate event,
    Emitter<ExchangeState> emit,
  ) async {
    if (_isFetching) {
      return;
    }

    _isFetching = true;

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

      /// START LIVE SIMULATION
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
          errorMessage: null,
        ),
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('✅ EXCHANGE RATE UPDATED');
        debugPrint('${event.fromCurrency} → ${event.toCurrency}');
        debugPrint('Rate: ${calculation.exchangeRate}');
        debugPrint('');
      }
    }
    /// FAILURES
    on Failure catch (failure) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('════════ EXCHANGE FAILURE ════════');
        debugPrint('TYPE: ${failure.runtimeType}');
        debugPrint('MESSAGE: ${failure.message}');
        debugPrint('══════════════════════════════════');
        debugPrint('');
      }

      emit(
        state.copyWith(
          isLoading: false,
          isStale: true,
          errorMessage: failure.message,
        ),
      );
    }
    /// UNKNOWN ERROR
    catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('❌ UNEXPECTED EXCHANGE ERROR');
        debugPrint('$e');
        debugPrint('$stackTrace');
        debugPrint('');
      }

      emit(
        state.copyWith(
          isLoading: false,
          isStale: true,
          errorMessage: 'Unexpected error occurred',
        ),
      );
    } finally {
      _isFetching = false;
    }
  }

  /// ======================================================
  /// UPDATE SENDER AMOUNT
  /// ======================================================

  void _onUpdateSenderAmount(
    UpdateSenderAmount event,
    Emitter<ExchangeState> emit,
  ) {
    final amount = Decimal.parse(event.amount.toString());

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

  /// ======================================================
  /// UPDATE RECEIVER AMOUNT
  /// ======================================================

  void _onUpdateReceiverAmount(
    UpdateReceiverAmount event,
    Emitter<ExchangeState> emit,
  ) {
    final recipientAmount = Decimal.parse(event.amount.toString());

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
        recipientAmount: recipientAmount,
        fee: calculation.fee,
        totalPayable: calculation.totalPayable,
      ),
    );
  }

  /// ======================================================
  /// AMOUNT CHANGED
  /// ======================================================

  void _onAmountChanged(AmountChanged event, Emitter<ExchangeState> emit) {
    final amount = Decimal.tryParse(event.amount.trim()) ?? Decimal.zero;

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

  /// ======================================================
  /// RECIPIENT AMOUNT CHANGED
  /// ======================================================

  void _onRecipientAmountChanged(
    RecipientAmountChanged event,
    Emitter<ExchangeState> emit,
  ) {
    final recipientAmount =
        Decimal.tryParse(event.amount.trim()) ?? Decimal.zero;

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

  /// ======================================================
  /// SWAP CURRENCIES
  /// ======================================================

  Future<void> _onSwapCurrencies(
    SwapCurrencies event,
    Emitter<ExchangeState> emit,
  ) async {
    final fromCurrency = state.toCurrency;

    final toCurrency = state.fromCurrency;

    emit(state.copyWith(fromCurrency: fromCurrency, toCurrency: toCurrency));

    add(FetchExchangeRate(fromCurrency: fromCurrency, toCurrency: toCurrency));
  }

  /// ======================================================
  /// CHANGE BOTH CURRENCIES
  /// ======================================================

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

  /// ======================================================
  /// CHANGE FROM CURRENCY
  /// ======================================================

  Future<void> _onChangeFromCurrency(
    ChangeFromCurrency event,
    Emitter<ExchangeState> emit,
  ) async {
    add(
      FetchExchangeRate(
        fromCurrency: event.currencyCode,
        toCurrency: state.toCurrency,
      ),
    );
  }

  /// ======================================================
  /// CHANGE TO CURRENCY
  /// ======================================================

  Future<void> _onChangeToCurrency(
    ChangeToCurrency event,
    Emitter<ExchangeState> emit,
  ) async {
    add(
      FetchExchangeRate(
        fromCurrency: state.fromCurrency,
        toCurrency: event.currencyCode,
      ),
    );
  }

  /// ======================================================
  /// REFRESH RATES
  /// ======================================================

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

  /// ======================================================
  /// REFRESH EXCHANGE RATE
  /// ======================================================

  Future<void> _onRefreshExchangeRate(
    RefreshExchangeRate event,
    Emitter<ExchangeState> emit,
  ) async {
    add(
      FetchExchangeRate(
        fromCurrency: state.fromCurrency,
        toCurrency: state.toCurrency,
      ),
    );
  }

  /// ======================================================
  /// MARK STALE
  /// ======================================================

  void _onMarkRatesAsStale(
    MarkRatesAsStale event,
    Emitter<ExchangeState> emit,
  ) {
    emit(state.copyWith(isStale: true));
  }

  /// ======================================================
  /// LIVE RATE UPDATED
  /// ======================================================

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
        lastUpdated: DateTime.now(),
      ),
    );
  }

  /// ======================================================
  /// CLEAR ERROR
  /// ======================================================

  void _onClearExchangeError(
    ClearExchangeError event,
    Emitter<ExchangeState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }

  /// ======================================================
  /// AUTO REFRESH TIMER
  /// ======================================================

  void _startAutoRefresh() {
    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (isClosed) {
        return;
      }

      add(const MarkRatesAsStale());

      await Future.delayed(const Duration(seconds: 1));

      if (!isClosed) {
        add(const RefreshExchangeRates());
      }
    });
  }

  /// ======================================================
  /// WEEKEND CHECK
  /// ======================================================

  bool _isWeekend() {
    final now = DateTime.now();

    return now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  }

  @override
  Future<void> close() async {
    _refreshTimer?.cancel();

    await _liveRateSubscription?.cancel();

    liveRateSimulationService.dispose();

    return super.close();
  }
}
