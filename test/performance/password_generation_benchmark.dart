import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:passgen/core/password_generator.dart';
import 'package:passgen/core/word_repository.dart';
import 'package:passgen/models/password_params.dart';

class PasswordGenerationBenchmark extends BenchmarkBase {
  final PasswordGeneratorService _generator;
  final PasswordParams _params;

  PasswordGenerationBenchmark()
      : _generator = PasswordGeneratorService(WordRepository()),
        _params = PasswordParams(),
        super('Password Generation');

  static void main() {
    PasswordGenerationBenchmark().report();
  }

  @override
  Future<void> setup() async {
    await _generator.initialize();
  }

  @override
  void run() {
    _generator.generate(_params);
  }
}

void main() {
  PasswordGenerationBenchmark.main();
}