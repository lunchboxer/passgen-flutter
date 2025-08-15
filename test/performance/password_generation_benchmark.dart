import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:passgen/core/password_generator.dart';
import 'package:passgen/core/word_repository.dart';
import 'package:passgen/models/password_params.dart';

class PasswordGenerationBenchmark extends BenchmarkBase {
  late WordRepository _repository;
  late PasswordGeneratorService _generator;
  final PasswordParams _params;

  PasswordGenerationBenchmark()
    : _params = PasswordParams(),
      super('Password Generation');

  static void main() {
    PasswordGenerationBenchmark().report();
  }

  @override
  Future<void> setup() async {
    _repository = WordRepository();
    await _repository.initialize();
    _generator = PasswordGeneratorService(_repository);
  }

  @override
  void run() {
    _generator.generate(_params);
  }
}

void main() {
  PasswordGenerationBenchmark().report();
}
