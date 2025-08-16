import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:passgen/core/word_repository.dart';

class WordListLoadingBenchmark extends BenchmarkBase {
  WordListLoadingBenchmark() : super('Word List Loading');
  late WordRepository _repository;

  static void main() {
    WordListLoadingBenchmark().report();
  }

  @override
  Future<void> setup() async {
    _repository = WordRepository();
  }

  @override
  Future<void> run() async {
    await _repository.initialize();
  }
}

void main() {
  WordListLoadingBenchmark.main();
}
