import 'dart:io';
import 'package:crypto/crypto.dart';

Future<void> main() async {
  // Calculate checksum for words.txt
  final wordsFile = File('assets/words.txt');
  final wordsBytes = await wordsFile.readAsBytes();
  final wordsDigest = sha256.convert(wordsBytes);
  print('assets/words.txt: $wordsDigest');
  
  // Calculate checksum for short-words.txt
  final shortWordsFile = File('assets/short-words.txt');
  final shortWordsBytes = await shortWordsFile.readAsBytes();
  final shortWordsDigest = sha256.convert(shortWordsBytes);
  print('assets/short-words.txt: $shortWordsDigest');
}