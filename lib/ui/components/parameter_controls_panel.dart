import 'package:flutter/material.dart';
import '../../models/password_params.dart';

class ParameterControlsPanel extends StatefulWidget {
  /// Creates a ParameterControlsPanel widget.
  const ParameterControlsPanel({
    required this.params, required this.onParamsChanged, super.key,
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
    final titleStyle = TextStyle(
      fontSize: isLargeScreen ? 20 : 18,
      fontWeight: FontWeight.bold,
    );
    final spacing = isLargeScreen ? 20.0 : 16.0;

    return Card(
      margin: EdgeInsets.all(isLargeScreen ? 20 : 16),
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
                const Text('Word Count: '),
                Text('${widget.params.wordCount}'),
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
            ),
            SizedBox(height: spacing),
            // Capitalize Words
            SwitchListTile(
              title: const Text('Capitalize Words'),
              value: widget.params.capitalize,
              onChanged: (value) {
                _updateParams(widget.params.copyWith(capitalize: value));
              },
            ),
            // Append Number
            SwitchListTile(
              title: const Text('Append Number'),
              value: widget.params.appendNumber,
              onChanged: (value) {
                _updateParams(widget.params.copyWith(appendNumber: value));
              },
            ),
            // Append Symbol
            SwitchListTile(
              title: const Text('Append Symbol'),
              value: widget.params.appendSymbol,
              onChanged: (value) {
                _updateParams(widget.params.copyWith(appendSymbol: value));
              },
            ),
            SizedBox(height: spacing),
            // Separator Input
            const Text('Separator:'),
            TextField(
              controller: _separatorController,
              maxLength: 1,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _updateParams(widget.params.copyWith(separator: value));
                }
              },
              decoration: const InputDecoration(
                hintText: 'Enter separator',
                helperText: 'Single character only',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
