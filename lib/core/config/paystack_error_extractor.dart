import 'package:dio/dio.dart';

class PaystackErrorExtractor {
  /// Safely extracts error messages from a native Paystack API response.
  static String? extractMessage(dynamic responseData) {
    try {

      if (responseData is Map<String, dynamic>) {
        // Paystack uses a direct 'message' key for its description
        if (responseData.containsKey('message')) {
          return responseData['message']?.toString();
        }
      }
    } catch (_) {
      // Fallback silently if JSON parsing fails structurally
    }
    return null;
  }
}