class StripeErrorExtractor {
  /// Safely extracts error messages from a Stripe API response.
  static String? extractMessage(dynamic responseData) {
    try {
      // Check if the response contains Stripe's signature error payload map
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('error')) {
        final stripeError = responseData['error'];

        if (stripeError is Map<String, dynamic>) {
          // Fallback tree to capture the most descriptive message available
          return stripeError['message']?.toString() ??
              stripeError['code']?.toString() ??
              stripeError['type']?.toString();
        }
      }
    } catch (_) {
      // Fallback silently if JSON parsing fails structurally
    }
    return null;
  }
}
