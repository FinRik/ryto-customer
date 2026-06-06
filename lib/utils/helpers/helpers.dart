class Helpers {
  Helpers._();

  static String maskPhoneNumber(String phone, {int visibleDigits = 4}) {
    if (phone.length <= visibleDigits) return phone;

    final visiblePart = phone.substring(0, visibleDigits);
    final maskedPart = '*' * (phone.length - visibleDigits);

    return '$visiblePart$maskedPart';
  }

  static int? autoExtractAndRound(String? input) {
    if (input == null) return null;

    // 1. Trim whitespace and safely parse to a double
    final double? parsedValue = double.tryParse(input.trim());

    // 2. Return null if it's not a valid number
    if (parsedValue == null) {
      return null;
    }

    // 3. Automatically round based on the decimal
    // (e.g., 20.0 -> 20, 20.4 -> 20, 20.5 -> 21)
    return parsedValue.round();
  }
}
