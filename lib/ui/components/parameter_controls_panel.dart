import 'package:flutter/material.dart';
import '../../models/password_params.dart';

class ParameterControlsPanel extends StatefulWidget {
  /// Creates a ParameterControlsPanel widget.
  const ParameterControlsPanel({
    required this.params,
    required this.onParamsChanged,
    super.key,
  });

  final PasswordParams params;
  final ValueChanged<PasswordParams> onParamsChanged;

  @override
  State<ParameterControlsPanel> createState() => _ParameterControlsPanelState();
}

class _ParameterControlsPanelState extends State<ParameterControlsPanel> {
  late TextEditingController _separatorController;

  @override
  void initState() {
    super.initState();
    _separatorController = TextEditingController(text: widget.params.separator);
  }

  @override
  void didUpdateWidget(covariant ParameterControlsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.params.separator != widget.params.separator) {
      _separatorController.text = widget.params.separator;
    }
  }

  @override
  void dispose() {
    _separatorController.dispose();
    super.dispose();
  }

  void _updateParams(PasswordParams newParams) {
    widget.onParamsChanged(newParams);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.shortestSide >= 500;
    final theme = Theme.of(context);
    final titleStyle = TextStyle(
      fontSize: isLargeScreen ? 20 : 18,
      fontWeight: FontWeight.bold,
      // Adapt title color to theme
      color: theme.textTheme.titleLarge?.color,
    );
    final spacing = isLargeScreen ? 20.0 : 16.0;

    return Card(
      margin: EdgeInsets.all(isLargeScreen ? 20 : 16),
      // Adapt card color to theme
      color: theme.brightness == Brightness.dark
          ? theme.cardColor
          : null, // Use default card color for light theme
      child: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password Parameters', style: titleStyle),
            SizedBox(height: spacing),
            // Word Count Slider
            Row(
              children: [
                Text(
                  'Word Count: ',
                  // Adapt text color to theme
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                ),
                Text(
                  '${widget.params.wordCount}',
                  // Adapt text color to theme
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                ),
              ],
            ),
            Slider(
              value: widget.params.wordCount.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: widget.params.wordCount.toString(),
              onChanged: (value) {
                _updateParams(widget.params.copyWith(wordCount: value.toInt()));
              },
              // Adapt slider colors to theme
              activeColor: theme.colorScheme.primary,
              inactiveColor: theme.brightness == Brightness.dark
                  ? Colors.grey[700]
                  : Colors.grey[300],
            ),
            SizedBox(height: spacing),
            // Capitalize Words
            SwitchListTile(
              title: Text(
                'Capitalize Words',
                // Adapt text color to theme
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
              value: widget.params.capitalize,
              onChanged: (value) {
                _updateParams(widget.params.copyWith(capitalize: value));
              },
              // Adapt switch colors to theme
              activeThumbColor: theme.colorScheme.primary,
              inactiveThumbColor: theme.brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[400],
            ),
            // Append Number
            SwitchListTile(
              title: Text(
                'Append Number',
                // Adapt text color to theme
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
              value: widget.params.appendNumber,
              onChanged: (value) {
                _updateParams(widget.params.copyWith(appendNumber: value));
              },
              // Adapt switch colors to theme
              activeThumbColor: theme.colorScheme.primary,
              inactiveThumbColor: theme.brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[400],
            ),
            // Append Symbol
            SwitchListTile(
              title: Text(
                'Append Symbol',
                // Adapt text color to theme
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
              value: widget.params.appendSymbol,
              onChanged: (value) {
                _updateParams(widget.params.copyWith(appendSymbol: value));
              },
              // Adapt switch colors to theme
              activeThumbColor: theme.colorScheme.primary,
              inactiveThumbColor: theme.brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[400],
            ),
            SizedBox(height: spacing),
            // Separator Input
            Text(
              'Separator:',
              // Adapt text color to theme
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
            TextField(
              controller: _separatorController,
              maxLength: 1,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _updateParams(widget.params.copyWith(separator: value));
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter separator',
                helperText: 'Single character only',
                // Adapt input decoration colors to theme
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? theme.cardColor
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
              // Adapt text color to theme
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
          ],
        ),
      ),
    );
  }
}
