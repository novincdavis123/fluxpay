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
          final previousRate = state.exchangeRate;

          Decimal percentageChange = Decimal.zero;

          /// SAFE PERCENTAGE CALCULATION
          if (previousRate > Decimal.zero) {
            final difference = updatedRate - previousRate;

            final percentageAsDouble =
                (difference.toDouble() / previousRate.toDouble()) * 100;

            percentageChange = Decimal.parse(
              percentageAsDouble.toStringAsFixed(4),
            );
          }

          add(
            LiveRateUpdated(
              updatedRate: updatedRate,
              percentageChange: percentageChange,
            ),
          );
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

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final ExchangeRateEntity rateEntity = await repository.getExchangeRate(
        from: event.fromCurrency,
        to: event.toCurrency,
      );

      final calculation = calculatorService.calculateFromSender(
        senderAmount: state.senderAmount,
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

          previousRate: state.exchangeRate,

          exchangeRate: calculation.exchangeRate,

          senderAmount: calculation.senderPays,
          recipientAmount: calculation.recipientGets,

          fee: calculation.fee,
          totalPayable: calculation.totalPayable,

          lastUpdated: DateTime.now(),

          rateChangePercent: Decimal.zero,
          isRateIncreasing: true,

          clearError: true,
        ),
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('✅ EXCHANGE RATE UPDATED');
        debugPrint('${event.fromCurrency} → ${event.toCurrency}');
        debugPrint('Rate: ${calculation.exchangeRate}');
        debugPrint('Sender: ${calculation.senderPays}');
        debugPrint('Recipient: ${calculation.recipientGets}');
        debugPrint('Fee: ${calculation.fee}');
        debugPrint('');
      }
    }
    /// FAILURE
    on Failure catch (failure) {
      emit(
        state.copyWith(
          isLoading: false,
          isStale: true,
          errorMessage: failure.message,
        ),
      );

      if (kDebugMode) {
        debugPrint('❌ Exchange Failure: ${failure.message}');
      }
    }
    /// UNKNOWN ERROR
    catch (e, stackTrace) {
      emit(
        state.copyWith(
          isLoading: false,
          isStale: true,
          errorMessage: 'Unexpected error occurred',
        ),
      );

      if (kDebugMode) {
        debugPrint('❌ Unexpected Error: $e');
        debugPrint('$stackTrace');
      }
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
    final amount = Decimal.tryParse(event.amount.toString()) ?? Decimal.zero;

    final calculation = calculatorService.calculateFromSender(
      senderAmount: amount,
      rate: state.exchangeRate,
      isWeekend: _isWeekend(),
      sameCurrency: state.fromCurrency == state.toCurrency,
    );

    emit(
      state.copyWith(
        senderAmount: calculation.senderPays,
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
    final recipientAmount =
        Decimal.tryParse(event.amount.toString()) ?? Decimal.zero;

    if (state.exchangeRate <= Decimal.zero) {
      return;
    }

    final calculation = calculatorService.calculateFromRecipient(
      recipientAmount: recipientAmount,
      rate: state.exchangeRate,
      isWeekend: _isWeekend(),
      sameCurrency: state.fromCurrency == state.toCurrency,
    );

    emit(
      state.copyWith(
        senderAmount: calculation.senderPays,
        recipientAmount: calculation.recipientGets,
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

    final calculation = calculatorService.calculateFromSender(
      senderAmount: amount,
      rate: state.exchangeRate,
      isWeekend: _isWeekend(),
      sameCurrency: state.fromCurrency == state.toCurrency,
    );

    emit(
      state.copyWith(
        senderAmount: calculation.senderPays,
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

    if (state.exchangeRate <= Decimal.zero) {
      return;
    }

    final calculation = calculatorService.calculateFromRecipient(
      recipientAmount: recipientAmount,
      rate: state.exchangeRate,
      isWeekend: _isWeekend(),
      sameCurrency: state.fromCurrency == state.toCurrency,
    );

    emit(
      state.copyWith(
        senderAmount: calculation.senderPays,
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
    final oldSenderAmount = state.senderAmount;

    final oldRecipientAmount = state.recipientAmount;

    final fromCurrency = state.toCurrency;

    final toCurrency = state.fromCurrency;

    emit(
      state.copyWith(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,

        senderAmount: oldRecipientAmount,

        recipientAmount: oldSenderAmount,
      ),
    );

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
    final calculation = calculatorService.calculateFromSender(
      senderAmount: state.senderAmount,
      rate: event.updatedRate,
      isWeekend: _isWeekend(),
      sameCurrency: state.fromCurrency == state.toCurrency,
    );

    emit(
      state.copyWith(
        previousRate: state.exchangeRate,

        exchangeRate: calculation.exchangeRate,

        rateChangePercent: event.percentageChange,

        isRateIncreasing: event.percentageChange >= Decimal.zero,

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
    emit(state.copyWith(clearError: true));
  }

  /// ======================================================
  /// AUTO REFRESH
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
