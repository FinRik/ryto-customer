class StripePaymentIntentResult {
  final String clientSecret;
  final String? paymentIntentId;

  const StripePaymentIntentResult({
    required this.clientSecret,
    this.paymentIntentId,
  });

  factory StripePaymentIntentResult.fromJson(Map<String, dynamic> json) {
    final clientSecret =
        json['clientSecret'] as String? ?? json['client_secret'] as String?;
    final explicitId =
        json['paymentIntentId'] as String? ?? json['id'] as String?;

    return StripePaymentIntentResult(
      clientSecret: clientSecret ?? '',
      paymentIntentId: explicitId ?? _extractIntentId(clientSecret),
    );
  }

  // Stripe client secrets are formatted as "pi_XXX_secret_YYY".
  static String? _extractIntentId(String? clientSecret) {
    if (clientSecret == null) return null;
    final index = clientSecret.indexOf('_secret_');
    return index == -1 ? null : clientSecret.substring(0, index);
  }
}
