import 'package:benchmark_harness/benchmark_harness.dart';
import '../../lib/core/word_repository.dart';

class WordListLoadingBenchmark extends BenchmarkBase {
  late WordRepository _repository;

  WordListLoadingBenchmark() : super('Word List Loading');

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
