// lib/core/utils/date_formatter_utils.dart
import 'package:intl/intl.dart';

class DateFormatterUtils {
  static final DateFormat _displayFormat = DateFormat('dd / MM / yyyy');
  static final DateFormat _backendFormat = DateFormat('yyyy-MM-dd');

  static String get departureDate =>
      DateFormat('d MMM, yyyy').format(DateTime.now());

  // For showing in TextField (e.g., 15 / 01 / 1990)
  static String toDisplayFormat(DateTime date) {
    return _displayFormat.format(date);
  }

  // For backend (yyyy-MM-dd)
  static String toBackendFormat(DateTime date) {
    return _backendFormat.format(date);
  }

  // Parse from display format (15 / 01 / 1990) → DateTime
  static String? parseBackendFormat(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) {
      return null;
    }

    final constructDate = dateStr.split("/");
    final month = constructDate.first;
    final day = constructDate[1];
    final year = constructDate.last;

    try {
      return "$year-$month-$day";
    } catch (e) {
      return null;
    }
  }
}
