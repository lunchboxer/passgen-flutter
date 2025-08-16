import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  /// Creates an ActionButtonsRow widget.
  const ActionButtonsRow({
    required this.onRegenerate,
    required this.onSettings,
    super.key,
  });

  final VoidCallback onRegenerate;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.shortestSide >= 500;
    final theme = Theme.of(context);
    final buttonPadding = isLargeScreen
        ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    final buttonTextStyle = TextStyle(
      fontSize: isLargeScreen ? 16 : 14,
      // Adapt button text color to theme
      color: theme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black87,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: onRegenerate,
          icon: const Icon(Icons.refresh),
          label: Text('Regenerate', style: buttonTextStyle),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
            // Adapt button colors to theme
            backgroundColor: theme.brightness == Brightness.dark
                ? theme.colorScheme.primary
                : theme.colorScheme.primaryContainer,
            foregroundColor: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        ElevatedButton.icon(
          onPressed: onSettings,
          icon: const Icon(Icons.settings),
          label: Text('Settings', style: buttonTextStyle),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
            // Adapt button colors to theme
            backgroundColor: theme.brightness == Brightness.dark
                ? theme.colorScheme.secondary
                : theme.colorScheme.secondaryContainer,
            foregroundColor: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
      ],
    );
  }
}
