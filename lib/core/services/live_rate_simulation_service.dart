import 'dart:async';
import 'dart:math';
import 'package:decimal/decimal.dart';

class LiveRateSimulationService {
  final _controller = StreamController<Decimal>.broadcast();

  Timer? _timer;

  Stream<Decimal> get stream => _controller.stream;
  // Simulate live rate updates by randomly fluctuating the base rate every 3 seconds
  void start({required Decimal baseRate}) {
    _timer?.cancel();

    Decimal currentRate = baseRate;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final random = Random();

      final fluctuation = (random.nextDouble() - 0.5) * 0.08;

      final updatedRate = currentRate.toDouble() + fluctuation;

      currentRate = Decimal.parse(updatedRate.toStringAsFixed(4));

      _controller.add(currentRate);
    });
  }

  void stop() {
    _timer?.cancel();
  }

  void dispose() {
    stop();

    _controller.close();
  }
}
