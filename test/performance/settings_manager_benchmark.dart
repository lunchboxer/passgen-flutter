import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:passgen/core/settings_manager.dart';
import 'package:passgen/models/password_params.dart';

class SettingsManagerBenchmark extends BenchmarkBase {
  late SettingsManager _settingsManager;
  late PasswordParams _params;

  SettingsManagerBenchmark() : super('Settings Manager');

  static void main() {
    SettingsManagerBenchmark().report();
  }

  @override
  Future<void> setup() async {
    _settingsManager = SettingsManager();
    await _settingsManager.initialize();
    _params = PasswordParams(
      wordCount: 5,
      capitalize: false,
      separator: '_',
      appendNumber: true,
      appendSymbol: true,
    );
  }

  @override
  Future<void> run() async {
    await _settingsManager.saveSettings(_params);
    await _settingsManager.loadSettings();
  }
}

void main() {
  SettingsManagerBenchmark.main();
}
