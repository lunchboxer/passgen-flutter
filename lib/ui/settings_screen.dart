import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme_manager.dart';
import '../../models/app_theme.dart';
import '../../models/password_params.dart';

class SettingsScreen extends StatefulWidget {
  /// Creates a SettingsScreen widget.
  const SettingsScreen({
    required this.currentParams,
    required this.themeManager,
    required this.onSave,
    super.key,
  });

  final PasswordParams currentParams;
  final ThemeManager themeManager;
  final ValueChanged<PasswordParams> onSave;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late PasswordParams _params;
  late AppTheme _selectedTheme;
  late TextEditingController _separatorController;
  late TextEditingController _lengthConstraintController;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _params = widget.currentParams;
    _selectedTheme = widget.themeManager.getCurrentTheme();
    _separatorController = TextEditingController(text: _params.separator);
    _lengthConstraintController = TextEditingController(
      text: _params.lengthConstraint?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _separatorController.dispose();
    _lengthConstraintController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    // Validate parameters before saving
    if (_params.validate()) {
      widget.onSave(_params);
      widget.themeManager.setTheme(_selectedTheme);
      Navigator.of(context).pop();
    } else {
      // Show validation error
      setState(() {
        _validationError = 'Invalid parameters. Please check your inputs.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Re-validate on each build to clear error when params are fixed
    if (_validationError != null && _params.validate()) {
      _validationError = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Default Password Parameters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_validationError != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _validationError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Theme Selection
            const Text(
              'Theme:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile<AppTheme>(
              title: const Text('Light'),
              value: AppTheme.light,
              groupValue: _selectedTheme,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTheme = value;
                  });
                }
              },
            ),
            RadioListTile<AppTheme>(
              title: const Text('Dark'),
              value: AppTheme.dark,
              groupValue: _selectedTheme,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTheme = value;
                  });
                }
              },
            ),
            RadioListTile<AppTheme>(
              title: const Text('Black'),
              value: AppTheme.black,
              groupValue: _selectedTheme,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTheme = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Word Count Slider
            Row(
              children: [
                const Text('Word Count: '),
                Text('${_params.wordCount}'),
              ],
            ),
            Slider(
              value: _params.wordCount.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: _params.wordCount.toString(),
              onChanged: (value) {
                setState(() {
                  _params = _params.copyWith(wordCount: value.toInt());
                });
              },
            ),
            const SizedBox(height: 16),
            // Capitalize Words
            SwitchListTile(
              title: const Text('Capitalize Words'),
              value: _params.capitalize,
              onChanged: (value) {
                setState(() {
                  _params = _params.copyWith(capitalize: value);
                });
              },
            ),
            // Append Number
            SwitchListTile(
              title: const Text('Append Number'),
              value: _params.appendNumber,
              onChanged: (value) {
                setState(() {
                  _params = _params.copyWith(appendNumber: value);
                });
              },
            ),
            // Append Symbol
            SwitchListTile(
              title: const Text('Append Symbol'),
              value: _params.appendSymbol,
              onChanged: (value) {
                setState(() {
                  _params = _params.copyWith(appendSymbol: value);
                });
              },
            ),
            const SizedBox(height: 16),
            // Separator Input
            const Text('Separator:'),
            TextField(
              controller: _separatorController,
              maxLength: 1,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _params = _params.copyWith(separator: value);
                  });
                }
              },
              decoration: const InputDecoration(
                hintText: 'Enter separator',
                helperText: 'Single character only',
              ),
            ),
            const SizedBox(height: 16),
            // Length Constraint
            const Text('Length Constraint (optional):'),
            TextField(
              controller: _lengthConstraintController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _params = _params.copyWith();
                  });
                } else {
                  final parsed = int.tryParse(value);
                  if (parsed != null) {
                    setState(() {
                      _params = _params.copyWith(lengthConstraint: parsed);
                    });
                  }
                }
              },
              decoration: const InputDecoration(
                hintText: 'Minimum password length',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
