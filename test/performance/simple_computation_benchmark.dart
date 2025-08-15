import 'package:benchmark_harness/benchmark_harness.dart';
import 'dart:math';

class SimpleComputationBenchmark extends BenchmarkBase {
  SimpleComputationBenchmark() : super('Simple Computation');

  static void main() {
    SimpleComputationBenchmark().report();
  }

  @override
  void run() {
    // Perform a simple computation
    var result = 0;
    for (var i = 0; i < 1000000; i++) {
      result += i * 2;
    }
  }
}

void main() {
  SimpleComputationBenchmark.main();
}
