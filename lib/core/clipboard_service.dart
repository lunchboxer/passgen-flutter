import 'package:flutter/services.dart';
import 'package:passgen/core/logger.dart';

class ClipboardService {
  /// Copies text to the clipboard
  static Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      Logger.debug('Text copied to clipboard');
    } catch (e) {
      Logger.error('Failed to copy text to clipboard: $e');
      rethrow;
    }
  }

  /// Gets text from the clipboard
  static Future<String?> getClipboardText() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      Logger.debug('Retrieved text from clipboard');
      return clipboardData?.text;
    } catch (e) {
      Logger.error('Failed to get text from clipboard: $e');
      rethrow;
    }
  }
}
