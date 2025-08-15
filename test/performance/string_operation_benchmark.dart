import 'package:benchmark_harness/benchmark_harness.dart';
import 'dart:math';

class StringOperationBenchmark extends BenchmarkBase {
  final List<String> _words = List.generate(1000, (index) => 'word$index');
  final Random _random = Random();

  StringOperationBenchmark() : super('String Operation');

  static void main() {
    StringOperationBenchmark().report();
  }

  @override
  void run() {
    // Perform string operations
    var result = '';
    for (var i = 0; i < 1000; i++) {
      final word1 = _words[_random.nextInt(_words.length)];
      final word2 = _words[_random.nextInt(_words.length)];
      final word3 = _words[_random.nextInt(_words.length)];
      
      // Join words with a separator and capitalize
      result = '${word1}_${word2}_${word3}'.toUpperCase();
    }
  }
}

void main() {
  StringOperationBenchmark.main();
}