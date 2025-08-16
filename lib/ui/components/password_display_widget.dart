import 'package:flutter/material.dart';

class PasswordDisplayWidget extends StatefulWidget {
  /// Creates a PasswordDisplayWidget widget.
  const PasswordDisplayWidget({
    required this.password,
    required this.onCopy,
    super.key,
  });

  final String password;
  final VoidCallback onCopy;

  @override
  State<PasswordDisplayWidget> createState() => _PasswordDisplayWidgetState();
}

class _PasswordDisplayWidgetState extends State<PasswordDisplayWidget> {
  bool _showCopiedMessage = false;
  late Duration _messageDuration;

  @override
  void initState() {
    super.initState();
    _messageDuration = const Duration(seconds: 2);
  }

  void _handleCopy() {
    widget.onCopy();
    setState(() {
      _showCopiedMessage = true;
    });

    // Hide the copied message after the specified duration
    Future.delayed(_messageDuration, () {
      if (mounted) {
        setState(() {
          _showCopiedMessage = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.shortestSide >= 500;
    final textFontSize = isLargeScreen ? 22.0 : 18.0;
    final containerPadding = isLargeScreen ? 20.0 : 16.0;
    final containerMargin = isLargeScreen ? 20.0 : 16.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(containerPadding),
          margin: EdgeInsets.all(containerMargin),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.password.isEmpty ? 'Generating...' : widget.password,
            style: TextStyle(
              fontSize: textFontSize,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ElevatedButton.icon(
          onPressed: _handleCopy,
          icon: const Icon(Icons.copy),
          label: Text(_showCopiedMessage ? 'Copied!' : 'Copy to Clipboard'),
        ),
      ],
    );
  }
}
