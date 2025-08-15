import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:passgen/core/logger.dart';
import 'package:passgen/core/password_generator_model.dart';
import 'package:passgen/core/clipboard_service.dart';
import 'package:passgen/ui/components/password_display_widget.dart';
import 'package:passgen/ui/components/parameter_controls_panel.dart';
import 'package:passgen/ui/components/action_buttons_row.dart';
import 'package:passgen/ui/settings_screen.dart';

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
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Logger.debug('Building MyApp widget');
    return ChangeNotifierProvider(
      create: (context) => PasswordGeneratorModel()..initialize(),
      child: MaterialApp(
        title: 'Passgen',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreen(),
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
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Passgen'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final mediaQuery = MediaQuery.of(context);
              final isLargeScreen = mediaQuery.size.shortestSide >= 500; // ~5 inch diagonal
              
              // For larger screens, we can use a more spacious layout
              if (isLargeScreen) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      PasswordDisplayWidget(
                        password: model.currentPassword,
                        onCopy: () => _copyToClipboard(context, model.currentPassword),
                      ),
                      const SizedBox(height: 24),
                      ParameterControlsPanel(
                        params: model.currentParams,
                        onParamsChanged: (newParams) => model.updateParams(newParams),
                      ),
                      const SizedBox(height: 24),
                      ActionButtonsRow(
                        onRegenerate: model.regeneratePassword,
                        onSettings: () => _navigateToSettings(context, model),
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
                        onCopy: () => _copyToClipboard(context, model.currentPassword),
                      ),
                      ParameterControlsPanel(
                        params: model.currentParams,
                        onParamsChanged: (newParams) => model.updateParams(newParams),
                      ),
                      ActionButtonsRow(
                        onRegenerate: model.regeneratePassword,
                        onSettings: () => _navigateToSettings(context, model),
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
  void _copyToClipboard(BuildContext context, String password) async {
    try {
      await ClipboardService.copyToClipboard(password);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password copied to clipboard')),
        );
      }
    } catch (e) {
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
            model.updateParams(newParams);
            model.saveSettings(newParams);
          },
        ),
      ),
    );
  }
}
