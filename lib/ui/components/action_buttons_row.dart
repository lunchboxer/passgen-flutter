import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onRegenerate;
  final VoidCallback onSettings;

  const ActionButtonsRow({
    super.key,
    required this.onRegenerate,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.shortestSide >= 500;
    final buttonPadding = isLargeScreen ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16) : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    final buttonTextStyle = TextStyle(fontSize: isLargeScreen ? 16 : 14);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: onRegenerate,
          icon: const Icon(Icons.refresh),
          label: Text('Regenerate', style: buttonTextStyle),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
          ),
        ),
        ElevatedButton.icon(
          onPressed: onSettings,
          icon: const Icon(Icons.settings),
          label: Text('Settings', style: buttonTextStyle),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
          ),
        ),
      ],
    );
  }
}