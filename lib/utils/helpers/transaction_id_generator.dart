import 'dart:math';

class TransactionIdGenerator {
  static final Random _random = Random.secure();

  /// Timestamp (ms) + 4 random digits, e.g. 17272345678901234
  static int generate() {
    final timestamp = DateTime.now().millisecondsSinceEpoch; // 13 digits
    final randomPart = _random.nextInt(10000);               // 0-9999
    return timestamp * 10000 + randomPart;
  }

  /// Purely random N-digit number (default 10 digits)
  static int randomDigits([int length = 10]) {
    final min = pow(10, length - 1).toInt();
    final max = pow(10, length).toInt();
    return min + _random.nextInt(max - min);
  }
}