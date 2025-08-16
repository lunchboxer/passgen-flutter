// Sort directive sections alphabetically
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/clipboard_service.dart';
import '../core/logger.dart';
import '../core/password_generator_model.dart';
import '../core/settings_manager.dart';
import '../core/theme_provider.dart';
import '../ui/components/parameter_controls_panel.dart';
import '../ui/components/password_display_widget.dart';
import '../ui/settings_screen.dart';

/// The main entry point for the Passgen application.
///
/// This function initializes the logging system and starts the Flutter app.
void main() {
  // Initialize logging
  Logger.info('Starting Passgen application');
  runApp(const MyApp());
}

/// The root widget of the Passgen application.
///
/// This widget sets up the app with a Material theme and the main screen.
class MyApp extends StatefulWidget {
  /// Creates a MyApp widget.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SettingsManager _settingsManager;
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _initializeTheme();
  }

  /// Initialize the theme provider
  Future<void> _initializeTheme() async {
    _settingsManager = SettingsManager();
    await _settingsManager.initialize();
    _themeProvider = ThemeProvider(_settingsManager);
    setState(() {}); // Rebuild with theme provider
  }

  @override
  Widget build(BuildContext context) {
    Logger.debug('Building MyApp widget');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PasswordGeneratorModel()..initialize(),
        ),
        ChangeNotifierProvider<ThemeProvider>.value(value: _themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          title: 'Passgen',
          theme: themeProvider.getThemeData(),
          home: const MainScreen(),
        ),
      ),
    );
  }
}

/// The main screen of the Passgen application.
///
/// This widget displays the password generator interface with:
/// - Password display area
/// - Parameter controls
/// - Action buttons (regenerate, settings)
class MainScreen extends StatelessWidget {
  /// Creates a MainScreen widget.
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Logger.debug('Building MainScreen widget');

    return Consumer<PasswordGeneratorModel>(
      builder: (context, model, child) {
        if (!model.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Passgen'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _navigateToSettings(context, model),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final mediaQuery = MediaQuery.of(context);
              final isLargeScreen =
                  mediaQuery.size.shortestSide >= 500; // ~5 inch diagonal

              // For larger screens, we can use a more spacious layout
              if (isLargeScreen) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      PasswordDisplayWidget(
                        password: model.currentPassword,
                        onCopy: () =>
                            _copyToClipboard(context, model.currentPassword),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: model.regeneratePassword,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Regenerate'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ParameterControlsPanel(
                        params: model.currentParams,
                        onParamsChanged: (newParams) =>
                            model.updateParams(newParams),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }
              // For smaller screens, we optimize space usage
              else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      PasswordDisplayWidget(
                        password: model.currentPassword,
                        onCopy: () =>
                            _copyToClipboard(context, model.currentPassword),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: model.regeneratePassword,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Regenerate'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ParameterControlsPanel(
                        params: model.currentParams,
                        onParamsChanged: (newParams) =>
                            model.updateParams(newParams),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  /// Copies the given [password] to the clipboard.
  ///
  /// Shows a snackbar with success or error message.
  Future<void> _copyToClipboard(BuildContext context, String password) async {
    try {
      await ClipboardService.copyToClipboard(password);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password copied to clipboard')),
        );
      }
    } on Exception catch (e) {
      Logger.error('Failed to copy password to clipboard: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to copy password to clipboard')),
        );
      }
    }
  }

  /// Navigates to the settings screen.
  ///
  /// Passes the current parameters and a callback to save new parameters.
  void _navigateToSettings(BuildContext context, PasswordGeneratorModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          currentParams: model.currentParams,
          onSave: (newParams) {
            model
              ..updateParams(newParams)
              ..saveSettings(newParams);
          },
        ),
      ),
    );
  }
}
